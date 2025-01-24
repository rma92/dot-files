#Paste Reconstruct-Productcode and the needed function into a powershell window.
function Reconstruct-ProductCode {
  param (
      [string]$strMungedCode
      )
    $arrSequence = @(8,7,6,5,4,3,2,1,12,11,10,9,16,15,14,13,18,17,20,19,22,21,24,23,26,25,28,27,30,29,32,31)
    $strProductCode = "{"
    $intArraySize = 32
    for ($intIndex = 0; $intIndex -lt $intArraySize; $intIndex++) {
      $strProductCode += $strMungedCode.Substring($arrSequence[$intIndex] - 1, 1)
        if ($intIndex -eq 7 -or $intIndex -eq 11 -or $intIndex -eq 15 -or $intIndex -eq 19) {
          $strProductCode += "-"
        }
    }
  $strProductCode += "}"
    return $strProductCode
}

<#
  Find patches that are marked as superseded, outputs commands to remove
  them using msiexec.

  State registry values: 1 = applied, 2 = superseded, 4 = obsolete

  Ignores patches not marked as uninstallable - use Get-OldPatchesForced
  to get commands to remove patches that are superseded but marked as uninstallable.
#>
function Get-OldPatches {
  $HKLM = [Microsoft.Win32.RegistryHive]::LocalMachine
  $instKey = "SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products"
  $reg = [Microsoft.Win32.RegistryKey]::OpenBaseKey($HKLM, [Microsoft.Win32.RegistryView]::Default)

  $productsKey = $reg.OpenSubKey($instKey)
  $arrProducts = $productsKey.GetSubKeyNames()

  foreach ($product in $arrProducts) {
    $productU = Reconstruct-ProductCode $product
    $productKey = $productsKey.OpenSubKey("$product\InstallProperties")
    $productN = $productKey.GetValue("DisplayName", "")

    $patchesKey = $productsKey.OpenSubKey("$product\Patches")
    if ($patchesKey) {
      $arrPatches = $patchesKey.GetSubKeyNames()
      foreach ($patch in $arrPatches) {
        $patchU = Reconstruct-ProductCode $patch
        $patchKey = $patchesKey.OpenSubKey($patch)
        $patchN = $patchKey.GetValue("DisplayName", "")
        $sta = $patchKey.GetValue("State", 0)
        $msi3 = $patchKey.GetValue("MSI3", 0)
        $uninsta = $patchKey.GetValue("Uninstallable", 0)

        if ($sta -eq 2) {
          if ($msi3 -eq 1) {
            if ($uninsta -eq 1) {
              Write-Output "#$patchKey"
              Write-Output "#$productN : $patchN"
              $cmd = "msiexec /package $productU /uninstall $patchU /passive /qr /norestart"
              Write-Output $cmd
            }
          } else {
            Write-Output "Cannot uninstall $productN : $patchN â€” Patch removal is available starting with MSI 3.0"
          } #$msi3 == 1
        } #$sta == 2
      } #foreach
    } #patchesKey
  } #foreach
}#Get-OldPatches

# Use this to get patches not marked as uninstallable.
function Get-OldPatchesForced {
  $HKLM = [Microsoft.Win32.RegistryHive]::LocalMachine
  $instKey = "SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products"
  $reg = [Microsoft.Win32.RegistryKey]::OpenBaseKey($HKLM, [Microsoft.Win32.RegistryView]::Default)

  $productsKey = $reg.OpenSubKey($instKey)
  $arrProducts = $productsKey.GetSubKeyNames()

  foreach ($product in $arrProducts) {
    $productU = Reconstruct-ProductCode $product
    $productKey = $productsKey.OpenSubKey("$product\InstallProperties")
    $productN = $productKey.GetValue("DisplayName", "")

    $patchesKey = $productsKey.OpenSubKey("$product\Patches")
    if ($patchesKey) {
      $arrPatches = $patchesKey.GetSubKeyNames()
      foreach ($patch in $arrPatches) {
        $patchU = Reconstruct-ProductCode $patch
        $patchKey = $patchesKey.OpenSubKey($patch)
        $patchN = $patchKey.GetValue("DisplayName", "")
        $sta = $patchKey.GetValue("State", 0)
        $msi3 = $patchKey.GetValue("MSI3", 0)
        $uninsta = $patchKey.GetValue("Uninstallable", 0)

        if ($sta -eq 2) { #1 = applied 2 = superseded 4 = obsolete
          if ($msi3 -eq 1) {
            if ($uninsta -ne 1) {
                Write-Output "# force uninstall $productN : $patchN"
                Write-Host "reg add ""$patchKey""  /v Uninstallable /t REG_DWORD /d 1 /f"
                $cmd = "msiexec /package $productU /uninstall $patchU /passive /qr /norestart"
                Write-Output $cmd
            }
          } else {
            Write-Output "Cannot uninstall $productN : $patchN â€” Patch removal is available starting with MSI 3.0"
          } #$msi3 == 1
        } #$sta == 2
      } #foreach
    } #patchesKey
  } #foreach
}

Get-OldPatches
