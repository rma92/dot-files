# Offline source preparation: run on an admin workstation after manually downloading
# the x64 Office 2016 MSI full-file EXE updates from the Microsoft KB/Catalog links.
# Example:
# .\Stage-Office2016-Updates.ps1 -PackageFolder D:\OfficePatchEXEs -OfficeSource D:\Office2016
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$PackageFolder,
    [Parameter(Mandatory=$true)][string]$OfficeSource
)
$ErrorActionPreference = 'Stop'
$PackageFolder = (Resolve-Path $PackageFolder).Path
$OfficeSource = (Resolve-Path $OfficeSource).Path
if (-not (Test-Path (Join-Path $OfficeSource 'setup.exe'))) {
    throw 'OfficeSource must be the root of the original Office 2016 MSI media (setup.exe missing).'
}
$updates = Join-Path $OfficeSource 'Updates'
New-Item -ItemType Directory -Force -Path $updates | Out-Null
$exeFiles = @(Get-ChildItem -LiteralPath $PackageFolder -Filter '*.exe' -File)
if ($exeFiles.Count -eq 0) { throw 'No downloaded EXE packages found.' }
$workRoot = Join-Path $env:TEMP ('Office2016MSP-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $workRoot | Out-Null
$seen = @{}
try {
    foreach ($exe in $exeFiles) {
        if ($exe.Name -match '(?i)-x86-') { throw "x86 package in x64 collection: $($exe.Name)" }
        $dest = Join-Path $workRoot ([guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $dest | Out-Null
        Write-Host "Extracting $($exe.Name) ..."
        # Microsoft Office self-extracting updates generally accept /extract and /quiet.
        $proc = Start-Process -FilePath $exe.FullName -ArgumentList @("/extract:`"$dest`"", '/quiet') -Wait -PassThru
        if ($proc.ExitCode -ne 0) { throw "Extraction failed: $($exe.Name), exit code $($proc.ExitCode)" }
        $patches = @(Get-ChildItem -LiteralPath $dest -Filter '*.msp' -File -Recurse)
        if ($patches.Count -eq 0) { throw "No MSP extracted from $($exe.Name)" }
        foreach ($patch in $patches) {
            $key = $patch.Name.ToLowerInvariant()
            if ($seen.ContainsKey($key)) {
                throw "Duplicate MSP filename $($patch.Name): $($seen[$key]) and $($exe.Name). Review supersedence manually."
            }
            $seen[$key] = $exe.Name
            $target = Join-Path $updates $patch.Name
            if (Test-Path -LiteralPath $target) {
                throw "Target already exists: $target. Use a clean Updates folder or review manually."
            }
            Copy-Item -LiteralPath $patch.FullName -Destination $target
            Write-Host "  Staged $($patch.Name)"
        }
    }
    Write-Host "Staged $($seen.Count) MSPs in $updates"
    Write-Warning 'Review MSPs against the manifest and test on a clean VM before distributing the media.'
}
finally {
    Remove-Item -LiteralPath $workRoot -Recurse -Force -ErrorAction SilentlyContinue
}
