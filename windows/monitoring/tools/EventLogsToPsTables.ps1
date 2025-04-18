$startTime = (Get-Date).AddSeconds(-86400)
$endTime = (Get-Date)

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

