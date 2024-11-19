Remove-Variable * -ea 0
$iTimeout = 15
$szDatabaseName = "promdb.sqlite3"
$szTargetUrl = "http://localhost:9102/metrics"
$errorActionPreference = 'stop'

$libName = ('sqlite3', 'winsqlite3.dll')[$env:OS -eq 'Windows_NT']
Add-Type -ReferencedAssemblies System.Data, System.Xml -TypeDefinition @"
using System;
using System.Data;
using System.Collections.Generic;
using System.Runtime.InteropServices;

public static class Sqlite {
  [DllImport("$libName", EntryPoint="sqlite3_open16", CharSet=CharSet.Unicode)]    public  static extern int    open(string filename, out IntPtr db);
  [DllImport("$libName", EntryPoint="sqlite3_prepare16", CharSet=CharSet.Unicode)] private static extern int    prepare(IntPtr db, string query, int len, out IntPtr stmt, IntPtr dummy);
  [DllImport("$libName", EntryPoint="sqlite3_step")]                               private static extern int    step(IntPtr stmt);
  [DllImport("$libName", EntryPoint="sqlite3_column_count")]                       private static extern int    column_count( IntPtr stmt);
  [DllImport("$libName", EntryPoint="sqlite3_column_name16")]                      private static extern IntPtr column_name(  IntPtr stmt, int col);
  [DllImport("$libName", EntryPoint="sqlite3_column_type")]                        private static extern int    column_type(  IntPtr stmt, int col);
  [DllImport("$libName", EntryPoint="sqlite3_column_double")]                      private static extern Double column_double(IntPtr stmt, int col);
  [DllImport("$libName", EntryPoint="sqlite3_column_int")]                         private static extern int    column_int(   IntPtr stmt, int col);
  [DllImport("$libName", EntryPoint="sqlite3_column_int64")]                       private static extern Int64  column_int64( IntPtr stmt, int col);
  [DllImport("$libName", EntryPoint="sqlite3_column_text16")]                      private static extern IntPtr column_text(  IntPtr stmt, int col);
  [DllImport("$libName", EntryPoint="sqlite3_column_blob")]                        private static extern IntPtr column_blob(  IntPtr stmt, int col);
  [DllImport("$libName", EntryPoint="sqlite3_column_bytes")]                       private static extern int    column_bytes( IntPtr stmt, int col);
  [DllImport("$libName", EntryPoint="sqlite3_finalize")]                           private static extern int    finalize(IntPtr stmt);
  [DllImport("$libName", EntryPoint="sqlite3_close_v2")]                           public  static extern int    close(IntPtr db);

   public static DataTable Execute(IntPtr db, string query) {
      IntPtr stmt = IntPtr.Zero;
      DataTable dt = new DataTable();

      int result = prepare(db, query, -1, out stmt, IntPtr.Zero);
      if (stmt == IntPtr.Zero) {return dt;}
      int colCount = column_count(stmt);
      int[] columnTypes = new int[colCount];

      if (step(stmt) == 100) {
        for (int c = 0; c < colCount; c++) {
          columnTypes[c] = column_type(stmt, c);
          dt.Columns.Add(Marshal.PtrToStringUni(column_name(stmt, c)), typeof(object));
        }
      } else {
        result = finalize(stmt);
        return dt;
      }

      object[] rowData = new object[colCount];
      do {
        for (int i = 0; i < colCount; i++) {
          switch (columnTypes[i]) {
            case 1:
              rowData[i] = column_int64(stmt, i);
              break;
            case 2:
              rowData[i] = column_double(stmt, i);
              break;
            case 3:
              rowData[i] = Marshal.PtrToStringUni(column_text(stmt, i));
              break;
            case 4:
              IntPtr ptr = column_blob(stmt, i);
              int len = column_bytes(stmt, i);
              byte[] arr = new byte[len];
              Marshal.Copy(ptr, arr, 0, len);
              rowData[i] = arr;
              break;
            default: 
              rowData[i] = DBNull.Value;
              break;
          }
        }
        dt.Rows.Add(rowData);
      } while (step(stmt) == 100);

      result = finalize(stmt);
      return dt;
  }
}
"@

while ($true) {
  $oResponse = Invoke-WebRequest -Uri $szTargetUrl -UseBasicParsing
  $szContent = $oResponse.Content

  $db = [IntPtr]::Zero
  $iResult = [sqlite]::open($szDatabaseName, [ref]$db)

  if ($iResult -eq 0) {
    [sqlite]::execute($db, "PRAGMA synchronous=OFF;PRAGMA count_changes=OFF;PRAGMA journal_mode=OFF;PRAGMA temp_store=OFF;")
    $iUTCTIME = [int][double]::Parse((Get-Date -UFormat %s))
    $szContent -split "`n" | ForEach-Object {
      $szLine = $_.Trim()
      if( $szLine -and -not $szLine.StartsWith('#')) {
        $iLastSpaceIndex = $szLine.LastIndexOf(' ')
        $szSubstring = $szLine.Substring(0, $iLastSpaceIndex)
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($szSubstring)
        $szBase64TableName = [System.Convert]::ToBase64String($bytes)
        $iVal = $szLine.Substring($iLastSpaceIndex + 1)
        $szQuery1 = "CREATE TABLE IF NOT EXISTS $szBase64TableName (TIME INTEGER, V INTEGER)"
        $szQuery2 = "INSERT INTO $szBase64TableName (TIME, V) VALUES ($iUTCTIME, $iVal)"
        $dataTable = [sqlite]::execute($db, $szQuery1)
        $dataTable = [sqlite]::execute($db, $szQuery2)
      }
    }
    Write-Host "Update for $iUTCTIME"
  }
  else {
    Write-Host "db connection failed."
  }

  [sqlite]::close($db)
  Start-Sleep -Seconds $iTimeout
}

# Sample query
$query = @"
SELECT * FROM MyTable
"@

# Connect to the database file or use ':memory:' for in-memory DB
$db = [IntPtr]::Zero
$filename = "path/to/your/database.sqlite3"
$result = [sqlite]::open($filename, [ref]$db)

if ($result -eq 0) {
    # Query the database
    $dataTable = [sqlite]::execute($db, $query)

    # Display the result
    $dataTable
}
else {
    Write-Host "Database connection failed."
}

# Close the database connection
[sqlite]::close($db)
