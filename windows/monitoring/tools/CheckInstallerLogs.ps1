$filter = @{
  LogName = "Application"
  ProviderName = "MsiInstaller"
}

function Convert-SIDToUsername {
  param (
      [Parameter(Mandatory=$true)]
      [string]$SID
      )
  try {
    $sidObj = New-Object System.Security.Principal.SecurityIdentifier($SID)
    $user = $sidObj.Translate([System.Security.Principal.NTAccount])
    return $user.Value
  } catch {
    return $SID
  }
}

$events = Get-WinEvent -FilterHashTable $filter

$events | ForEach-Object {
  $username = if( $_.UserId ) { Convert-SIDToUsername -SID $_.UserId.Value } else { "N/A" }
  [PSCustomObject]@{
    DateTime     = $_.TimeCreated
    Username     = $username
    ComputerName = $_.MachineName
    Source       = $_.ProviderName
    EventID      = $_.Id
    Description  = $_.Message
  }
} | Format-Table -Autosize
