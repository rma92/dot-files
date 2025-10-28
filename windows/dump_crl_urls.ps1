# Dump certificate revocation server urls
# Run in an elevated PowerShell
$stores = @('My','Root','CA','AuthRoot','TrustedPublisher','TrustedPeople','Disallowed')
$modes  = @('', '-user')   # '' = LocalMachine (default), '-user' = CurrentUser
$urls   = New-Object System.Collections.Generic.List[string]

foreach ($mode in $modes) {
  foreach ($store in $stores) {
    try {
      # Run certutil; capture the WHOLE output as one string to avoid missing wrapped lines
      $args = @('certutil','-store','-v') + @($mode) + @($store)
      $text = (& $args[0] $args[1] $args[2] $args[3] 2>$null) -join "`n"
      if (-not $text) { continue }

      # Pull any ldap/http/https URL from the verbose dump
      foreach ($m in [regex]::Matches($text, '(?i)\b(ldap|http|https)://\S+')) {
        $u = $m.Value.TrimEnd(')',']',';','.',',')
        if ($u) { $urls.Add($u) }
      }
    } catch { }
  }
}

$unique = $urls | Sort-Object -Unique
$unique | ForEach-Object { $_ }

# Save handy artifacts
$csv = "$env:USERPROFILE\Desktop\revocation_endpoints.csv"
$unique | ForEach-Object {
  $uri = [uri]$_
  [pscustomobject]@{ Type = if($_ -match '^ldap'){'LDAP'} elseif($_ -match '/ocsp'){ 'OCSP' } else { 'HTTP' }
                     Host = $uri.Host; Url = $_ }
} | Sort-Object Host, Url -Unique | Export-Csv -NoTypeInformation -Encoding UTF8 $csv
"Saved: $csv"

"Unique hosts:"
$unique | ForEach-Object { ([uri]$_).Host } | Where-Object { $_ } | Sort-Object -Unique

