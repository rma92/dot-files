<# 
.SYNOPSIS
Exports local user profiles, Windows/app settings, and environment variables with USMT.

.DESCRIPTION
Creates a timestamped migration directory containing:
  - A USMT migration store created by scanstate.exe.
  - scanstate logs.
  - User and system environment variable sidecars for selective restore.
  - A manifest describing the export.

Run from an elevated PowerShell prompt. USMT is installed with the Windows ADK
User State Migration Tool feature.
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$DestinationRoot = (Join-Path -Path $PSScriptRoot -ChildPath 'exports'),

    [Parameter()]
    [string]$USMTPath,

    [Parameter()]
    [string[]]$IncludeUsers,

    [Parameter()]
    [string[]]$ExcludeUsers,

    [Parameter()]
    [switch]$Overwrite,

    [Parameter()]
    [switch]$NoCompress,

    [Parameter()]
    [switch]$IncludeNetworkDrives,

    [Parameter()]
    [switch]$SkipEncryptedFiles
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Test-IsAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Resolve-USMTPath {
    param([string]$Path)

    $candidates = @()
    if ($Path) {
        $candidates += $Path
    }

    $kitsRoot = "${env:ProgramFiles(x86)}\Windows Kits"
    if (Test-Path -LiteralPath $kitsRoot) {
        $candidates += Get-ChildItem -LiteralPath $kitsRoot -Directory -ErrorAction SilentlyContinue |
            ForEach-Object {
                Join-Path -Path $_.FullName -ChildPath 'Assessment and Deployment Kit\User State Migration Tool'
            }
    }

    $candidates += @(
        "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\User State Migration Tool",
        "${env:ProgramFiles}\Windows Kits\10\Assessment and Deployment Kit\User State Migration Tool"
    )

    foreach ($candidate in $candidates | Where-Object { $_ } | Select-Object -Unique) {
        $archPath = Join-Path -Path $candidate -ChildPath 'amd64'
        $scanState = Join-Path -Path $archPath -ChildPath 'scanstate.exe'
        if (Test-Path -LiteralPath $scanState) {
            return (Resolve-Path -LiteralPath $archPath).Path
        }

        $scanState = Join-Path -Path $candidate -ChildPath 'scanstate.exe'
        if (Test-Path -LiteralPath $scanState) {
            return (Resolve-Path -LiteralPath $candidate).Path
        }
    }

    throw 'Could not find scanstate.exe. Install Windows ADK USMT, or pass -USMTPath to the folder containing scanstate.exe.'
}

function ConvertTo-EnvMap {
    param([hashtable]$Values)

    $ordered = [ordered]@{}
    foreach ($key in ($Values.Keys | Sort-Object)) {
        $ordered[$key] = [string]$Values[$key]
    }
    return $ordered
}

if (-not (Test-IsAdministrator)) {
    throw 'Run this script from an elevated PowerShell prompt so scanstate can read all profiles and system settings.'
}

$resolvedUSMTPath = Resolve-USMTPath -Path $USMTPath
$scanState = Join-Path -Path $resolvedUSMTPath -ChildPath 'scanstate.exe'
$migApp = Join-Path -Path $resolvedUSMTPath -ChildPath 'MigApp.xml'
$migDocs = Join-Path -Path $resolvedUSMTPath -ChildPath 'MigDocs.xml'

foreach ($requiredFile in @($scanState, $migApp, $migDocs)) {
    if (-not (Test-Path -LiteralPath $requiredFile)) {
        throw "Required USMT file not found: $requiredFile"
    }
}

$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$exportRoot = Join-Path -Path $DestinationRoot -ChildPath "usmt-export-$timestamp"
$storePath = Join-Path -Path $exportRoot -ChildPath 'store'
$logPath = Join-Path -Path $exportRoot -ChildPath 'logs'
$sidecarPath = Join-Path -Path $exportRoot -ChildPath 'sidecar'

if ((Test-Path -LiteralPath $exportRoot) -and -not $Overwrite) {
    throw "Export directory already exists: $exportRoot. Use -Overwrite to allow scanstate /o."
}

if ($PSCmdlet.ShouldProcess($exportRoot, 'Create USMT export')) {
    New-Item -ItemType Directory -Path $storePath, $logPath, $sidecarPath -Force | Out-Null

    $userEnv = ConvertTo-EnvMap -Values ([Environment]::GetEnvironmentVariables('User'))
    $machineEnv = ConvertTo-EnvMap -Values ([Environment]::GetEnvironmentVariables('Machine'))

    $userEnv | ConvertTo-Json -Depth 3 | Set-Content -LiteralPath (Join-Path -Path $sidecarPath -ChildPath 'user-environment.json') -Encoding UTF8
    $machineEnv | ConvertTo-Json -Depth 3 | Set-Content -LiteralPath (Join-Path -Path $sidecarPath -ChildPath 'system-environment.json') -Encoding UTF8

    & reg.exe export 'HKCU\Environment' (Join-Path -Path $sidecarPath -ChildPath 'HKCU-Environment.reg') /y | Out-Null
    & reg.exe export 'HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' (Join-Path -Path $sidecarPath -ChildPath 'HKLM-Environment.reg') /y | Out-Null

    $scanArgs = @(
        $storePath,
        "/i:$migApp",
        "/i:$migDocs",
        '/c',
        '/v:13',
        "/l:$(Join-Path -Path $logPath -ChildPath 'scanstate.log')",
        "/progress:$(Join-Path -Path $logPath -ChildPath 'scanstate-progress.log')"
    )

    if ($Overwrite) {
        $scanArgs += '/o'
    }

    if ($NoCompress) {
        $scanArgs += '/nocompress'
    }

    if (-not $IncludeNetworkDrives) {
        $scanArgs += '/localonly'
    }

    if (-not $SkipEncryptedFiles) {
        $scanArgs += '/efs:copyraw'
    }

    foreach ($user in $IncludeUsers) {
        $scanArgs += "/ui:$user"
    }

    foreach ($user in $ExcludeUsers) {
        $scanArgs += "/ue:$user"
    }

    $manifest = [ordered]@{
        CreatedAt = (Get-Date).ToString('o')
        ComputerName = $env:COMPUTERNAME
        UserName = "$env:USERDOMAIN\$env:USERNAME"
        USMTPath = $resolvedUSMTPath
        StorePath = $storePath
        IncludeUsers = @($IncludeUsers)
        ExcludeUsers = @($ExcludeUsers)
        NoCompress = [bool]$NoCompress
        IncludeNetworkDrives = [bool]$IncludeNetworkDrives
        SkipEncryptedFiles = [bool]$SkipEncryptedFiles
        ScanStateArguments = @($scanArgs)
    }

    $manifest | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path -Path $exportRoot -ChildPath 'manifest.json') -Encoding UTF8

    Write-Host "Starting USMT export to $storePath"
    & $scanState @scanArgs
    $exitCode = $LASTEXITCODE

    if ($exitCode -ne 0) {
        throw "scanstate.exe failed with exit code $exitCode. See $(Join-Path -Path $logPath -ChildPath 'scanstate.log')."
    }

    Write-Host "USMT export complete: $exportRoot"
}
