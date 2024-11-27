function Test-PendingReboot {
    [CmdletBinding()]
    param ()

    # Initialize a variable to track reboot status
    $isRebootPending = $false

    # Check the presence of the PendingFileRenameOperations key
    if (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name "PendingFileRenameOperations" -ErrorAction SilentlyContinue) {
        Write-Host "PendingFileRenameOperations found: A reboot is pending." -ForegroundColor Yellow
        $isRebootPending = $true
    }

    # Check the RebootPending key under Windows Update
    if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired") {
        Write-Host "Windows Update indicates a reboot is pending." -ForegroundColor Yellow
        $isRebootPending = $true
    }

    # Check Component-Based Servicing (CBS) RebootPending key
    if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending") {
        Write-Host "Component-Based Servicing indicates a reboot is pending." -ForegroundColor Yellow
        $isRebootPending = $true
    }

    # Check Pending GPO settings
    if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine") {
        Write-Host "Group Policy changes require a reboot." -ForegroundColor Yellow
        $isRebootPending = $true
    }

    # Check if a pending domain join reboot is required
#    if (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" -Name "JoinDomain" -ErrorAction SilentlyContinue -eq 1) {
#        Write-Host "Domain join indicates a reboot is pending." -ForegroundColor Yellow
#        $isRebootPending = $true
#    }

    # Return reboot pending status
    if ($isRebootPending) {
        Write-Host "A reboot is required." -ForegroundColor Red
        return $true
    } else {
        Write-Host "No reboot is pending." -ForegroundColor Green
        return $false
    }
}

