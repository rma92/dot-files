$startTime = (Get-Date).AddSeconds(-86400)
$endTime = (Get-Date)
$remoteComputer = $env:COMPUTERNAME

$scriptBlock = {
  $sysFilter = @{
    StartTime = $startTime
    EndTime = $endTime
    LogName = "System"
  }
  $sysEvents = Get-WinEvent -FilterHashTable $sysFilter -ErrorAction SilentlyContinue

  $appFilter = @{
    StartTime = $startTime
    EndTime = $endTime
    LogName = "Application"
  }
  $appEvents = Get-WinEvent -FilterHashTable $appFilter -ErrorAction SilentlyContinue

  $securityFilter = @{
    StartTime = $startTime
    EndTime = $endTime
    LogName = "Security"
    ID = 4264, 4265, 4728, 4732, 4756, 1102, 4740, 4663
  }
  $securityEvents = Get-WinEvent -FilterHashTable $securityFilter -ErrorAction SilentlyContinue

  $sysmonFilter = @{
    StartTime = $startTime
    EndTime = $endTime
    LogName = "Microsoft-Windows-Sysmon/Operational"
  }
  $sysmonEvents = Get-WinEvent -FilterHashTable $sysmonFilter -ErrorAction SilentlyContinue

  return @{
    SysEvents = $sysEvents
    AppEvents = $appEvents
    SecurityEvents = $securityEvents
    SysmonEvents = $sysmonEvents
  }
}

$results = Invoke-Command -ComputerName $remoteComputer -ScriptBlock $scriptBlock -ArgumentList $startTime, $endTime

$sysEvents = $results.SysEvents
$appEvents = $results.AppEvents
$securityEvents = $results.SecurityEvents
$sysmonEvents = $results.sysmonEvents

Write-Host "System Events: $($sysEvents.Count)"
Write-Host "Application Events: $($appEvents.Count)"
Write-Host "Security Events: $($securityEvents.Count)"
Write-Host "Sysmon Events: $($sysmonEvents.Count)"
