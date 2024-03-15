 Get-WMIObject win32_service | Select Name, DisplayName, StartMode, State | Sort Name | ForEach-Object { 
  Write-Host sc config $_.Name start= $_.StartMode
 }

