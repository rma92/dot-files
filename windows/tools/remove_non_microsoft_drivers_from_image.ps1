#Remove non built-in drivers from a Windows image using DISM:
#powershell -file remove_non_microsoft_drivers_from_image.ps1 > driver.txt
$mountDir = "F:\"
$infDir = "$mountDir\Windows\inf"
$oemFiles = Get-ChildItem -Path $infDir -Filter "oem*.inf"
foreach( $file in $oemFiles )
{
  Write-Host "Dism /image:$mountDir /Remove-Driver /Driver:$file"
}

