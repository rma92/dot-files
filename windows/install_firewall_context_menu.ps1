# Install-FirewallContextMenus.ps1 (elevated)

# --- Paths ---
$sys32 = Join-Path $env:WINDIR 'System32'
$unblockScript = Join-Path $sys32 'UnblockFirewall.ps1'
$removeScript  = Join-Path $sys32 'RemoveFirewall.ps1'

# --- Helper: UnblockFirewall.ps1 ---
$unblockContent = @'
param([Parameter(Mandatory=$true)][string]$TargetExe)

try {
    if (-not (Test-Path -LiteralPath $TargetExe)) {
        throw "File not found: $TargetExe"
    }
    $exeFull = (Resolve-Path -LiteralPath $TargetExe).Path
    $ruleName = "Unblock - " + [System.IO.Path]::GetFileNameWithoutExtension($exeFull)

    $netsh = "netsh advfirewall firewall add rule name=""$ruleName"" dir=out action=allow program=""$exeFull"" enable=yes profile=any"
    $proc = Start-Process -FilePath cmd.exe -ArgumentList "/c $netsh" -Wait -PassThru -WindowStyle Hidden
    $ok = ($proc.ExitCode -eq 0)

    Add-Type -AssemblyName PresentationFramework
    if ($ok) {
        [System.Windows.MessageBox]::Show("Firewall rule added for:`n`n$exeFull","Windows Firewall",0,'Information') | Out-Null
    } else {
        [System.Windows.MessageBox]::Show("Failed to add firewall rule for:`n`n$exeFull`n`nExit code: $($proc.ExitCode)","Windows Firewall",0,'Error') | Out-Null
    }
}
catch {
    try { Add-Type -AssemblyName PresentationFramework } catch {}
    [System.Windows.MessageBox]::Show("Error: $($_.Exception.Message)","Windows Firewall",0,'Error') | Out-Null
    exit 1
}
'@

# --- Helper: RemoveFirewall.ps1 ---
$removeContent = @'
param([Parameter(Mandatory=$true)][string]$TargetExe)

try {
    if (-not (Test-Path -LiteralPath $TargetExe)) {
        throw "File not found: $TargetExe"
    }
    $exeFull = (Resolve-Path -LiteralPath $TargetExe).Path
    $ruleName = "Unblock - " + [System.IO.Path]::GetFileNameWithoutExtension($exeFull)

    $netsh = "netsh advfirewall firewall delete rule name=""$ruleName"""
    $proc = Start-Process -FilePath cmd.exe -ArgumentList "/c $netsh" -Wait -PassThru -WindowStyle Hidden
    $ok = ($proc.ExitCode -eq 0)

    Add-Type -AssemblyName PresentationFramework
    if ($ok) {
        [System.Windows.MessageBox]::Show("Firewall rule removed:`n`n$ruleName","Windows Firewall",0,'Information') | Out-Null
    } else {
        [System.Windows.MessageBox]::Show("No matching rule found or deletion failed:`n`n$ruleName`n`nExit code: $($proc.ExitCode)","Windows Firewall",0,'Warning') | Out-Null
    }
}
catch {
    try { Add-Type -AssemblyName PresentationFramework } catch {}
    [System.Windows.MessageBox]::Show("Error: $($_.Exception.Message)","Windows Firewall",0,'Error') | Out-Null
    exit 1
}
'@

# --- Write/overwrite helper scripts (idempotent) ---
Set-Content -LiteralPath $unblockScript -Value $unblockContent -Encoding UTF8 -Force
Set-Content -LiteralPath $removeScript  -Value $removeContent  -Encoding UTF8 -Force

# --- Build the elevated command lines that Explorer will run ---
# We keep %1 for the clicked file path. Start-Process -Verb RunAs triggers UAC.
$unblockCmd = 'powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList ''-NoProfile -ExecutionPolicy Bypass -File \"\"' + $unblockScript + '\"\" \"%1\"'' -Verb RunAs"'
$removeCmd  = 'powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList ''-NoProfile -ExecutionPolicy Bypass -File \"\"' + $removeScript  + '\"\" \"%1\"'' -Verb RunAs"'

# --- Registry paths (EXE-only context menu) ---
$baseUnblock = 'Registry::HKEY_CLASSES_ROOT\exefile\shell\Unblock in Firewall'
$baseRemove  = 'Registry::HKEY_CLASSES_ROOT\exefile\shell\Remove from Firewall'

# Create keys and the 'command' subkeys explicitly (idempotent)
New-Item -Path $baseUnblock -Force | Out-Null
New-Item -Path (Join-Path $baseUnblock 'command') -Force | Out-Null
New-Item -Path $baseRemove  -Force | Out-Null
New-Item -Path (Join-Path $baseRemove 'command') -Force | Out-Null

# Set labels/icons
Set-ItemProperty -Path $baseUnblock -Name '(Default)' -Value 'Windows Firewall - Unblock'
Set-ItemProperty -Path $baseUnblock -Name 'Icon'       -Value 'imageres.dll,-109' -Type String
Set-ItemProperty -Path $baseRemove  -Name '(Default)' -Value 'Windows Firewall - Remove Unblock'
Set-ItemProperty -Path $baseRemove  -Name 'Icon'       -Value 'imageres.dll,-101' -Type String

# Set the command strings as the (Default) value of the command subkeys
Set-ItemProperty -Path (Join-Path $baseUnblock 'command') -Name '(Default)' -Value $unblockCmd -Type String
Set-ItemProperty -Path (Join-Path $baseRemove  'command') -Name '(Default)' -Value $removeCmd  -Type String

Write-Host "Installed context menus for EXE files:"
Write-Host "  - Unblock in Firewall"
Write-Host "  - Remove from Firewall"

