<#
.SYNOPSIS
Imports a migration directory created by Export-USMTState.ps1.

.DESCRIPTION
Restores a USMT migration store with loadstate.exe and can selectively restore
user and/or system environment variables from the export sidecars.

Run from an elevated PowerShell prompt on the destination Windows install.
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$ExportDirectory,

    [Parameter()]
    [string]$USMTPath,

    [Parameter()]
    [string[]]$IncludeUsers,

    [Parameter()]
    [string[]]$ExcludeUsers,

    [Parameter()]
    [switch]$SkipUSMT,

    [Parameter()]
    [switch]$RestoreUserEnvironment,

    [Parameter()]
    [switch]$RestoreSystemEnvironment,

    [Parameter()]
    [switch]$CreateLocalAccounts,

    [Parameter()]
    [switch]$EnableCreatedAccounts,

    [Parameter()]
    [switch]$NoCompress
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
        $loadState = Join-Path -Path $archPath -ChildPath 'loadstate.exe'
        if (Test-Path -LiteralPath $loadState) {
            return (Resolve-Path -LiteralPath $archPath).Path
        }

        $loadState = Join-Path -Path $candidate -ChildPath 'loadstate.exe'
        if (Test-Path -LiteralPath $loadState) {
            return (Resolve-Path -LiteralPath $candidate).Path
        }
    }

    throw 'Could not find loadstate.exe. Install Windows ADK USMT, or pass -USMTPath to the folder containing loadstate.exe.'
}

function Import-EnvironmentMap {
    param(
        [Parameter(Mandatory)]
        [string]$JsonPath,

        [Parameter(Mandatory)]
        [ValidateSet('User', 'Machine')]
        [string]$Target
    )

    if (-not (Test-Path -LiteralPath $JsonPath)) {
        throw "Environment sidecar not found: $JsonPath"
    }

    $values = Get-Content -LiteralPath $JsonPath -Raw | ConvertFrom-Json
    foreach ($property in $values.PSObject.Properties) {
        [Environment]::SetEnvironmentVariable($property.Name, [string]$property.Value, $Target)
    }
}

if (-not (Test-IsAdministrator)) {
    throw 'Run this script from an elevated PowerShell prompt so loadstate can restore profiles and system settings.'
}

$resolvedExportDirectory = (Resolve-Path -LiteralPath $ExportDirectory).Path
$storePath = Join-Path -Path $resolvedExportDirectory -ChildPath 'store'
$logPath = Join-Path -Path $resolvedExportDirectory -ChildPath 'logs'
$sidecarPath = Join-Path -Path $resolvedExportDirectory -ChildPath 'sidecar'

if (-not (Test-Path -LiteralPath $storePath)) {
    throw "USMT store directory not found: $storePath"
}

New-Item -ItemType Directory -Path $logPath -Force | Out-Null

if (-not $SkipUSMT) {
    $resolvedUSMTPath = Resolve-USMTPath -Path $USMTPath
    $loadState = Join-Path -Path $resolvedUSMTPath -ChildPath 'loadstate.exe'
    $migApp = Join-Path -Path $resolvedUSMTPath -ChildPath 'MigApp.xml'
    $migDocs = Join-Path -Path $resolvedUSMTPath -ChildPath 'MigDocs.xml'

    foreach ($requiredFile in @($loadState, $migApp, $migDocs)) {
        if (-not (Test-Path -LiteralPath $requiredFile)) {
            throw "Required USMT file not found: $requiredFile"
        }
    }

    $loadArgs = @(
        $storePath,
        "/i:$migApp",
        "/i:$migDocs",
        '/c',
        '/v:13',
        "/l:$(Join-Path -Path $logPath -ChildPath 'loadstate.log')",
        "/progress:$(Join-Path -Path $logPath -ChildPath 'loadstate-progress.log')"
    )

    if ($NoCompress) {
        $loadArgs += '/nocompress'
    }

    if ($CreateLocalAccounts) {
        $loadArgs += '/lac'
    }

    if ($EnableCreatedAccounts) {
        $loadArgs += '/lae'
    }

    foreach ($user in $IncludeUsers) {
        $loadArgs += "/ui:$user"
    }

    foreach ($user in $ExcludeUsers) {
        $loadArgs += "/ue:$user"
    }

    if ($PSCmdlet.ShouldProcess($storePath, 'Restore USMT store')) {
        Write-Host "Starting USMT import from $storePath"
        & $loadState @loadArgs
        $exitCode = $LASTEXITCODE

        if ($exitCode -ne 0) {
            throw "loadstate.exe failed with exit code $exitCode. See $(Join-Path -Path $logPath -ChildPath 'loadstate.log')."
        }
    }
}

if ($RestoreUserEnvironment) {
    $userEnvPath = Join-Path -Path $sidecarPath -ChildPath 'user-environment.json'
    if ($PSCmdlet.ShouldProcess('User environment', "Restore from $userEnvPath")) {
        Import-EnvironmentMap -JsonPath $userEnvPath -Target 'User'
    }
}

if ($RestoreSystemEnvironment) {
    $systemEnvPath = Join-Path -Path $sidecarPath -ChildPath 'system-environment.json'
    if ($PSCmdlet.ShouldProcess('System environment', "Restore from $systemEnvPath")) {
        Import-EnvironmentMap -JsonPath $systemEnvPath -Target 'Machine'
    }
}

Write-Host "Import complete from $resolvedExportDirectory. Restart or sign out/in for restored environment variables to be picked up by new processes."
