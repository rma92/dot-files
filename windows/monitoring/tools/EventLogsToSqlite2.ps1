<#
  Converts event logs to Sqlite
#>
$startTime = (Get-Date).AddSeconds(-86400)
$endTime = (Get-Date)
  
$szDatabaseName = "db" +[int][Math]::Floor((Get-Date $endTime.ToUniversalTime() -UFormat %s)) + ".db"

function Get-Events {
  param (
      [Parameter(Mandatory=$true)]
      [string]$LogName,

      [Parameter(Mandatory=$false)]
      [string]$Source,

      [Parameter(Mandatory=$true)]
      [datetime]$startTime,

      [Parameter(Mandatory=$false)]
      [datetime]$endTime
  )
  # Initialize the filter with mandatory parameters
  $filter = @{
      LogName = $LogName
      StartTime = $startTime
  }

  # Add optional parameters if they are provided
  if ($PSBoundParameters.ContainsKey('szSource') -and $szSource) {
      $filter.ProviderName = $Source
  }
  if ($PSBoundParameters.ContainsKey('endTime') -and $endTime) {
      $filter.EndTime = $endTime
  }
  
  return Get-WinEvent -FilterHashTable $filter -ErrorAction SilentlyContinue
}

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

$db = [IntPtr]::Zero
$iResult = [sqlite]::open($szDatabaseName, [ref]$db)
if( $iResult -eq 0 )
{
  [sqlite]::execute($db, "PRAGMA synchronous=OFF;PRAGMA count_changes=OFF;PRAGMA journal_mode=OFF;PRAGMA temp_store=OFF;")
  [sqlite]::execute($db, @"
  CREATE TABLE IF NOT EXISTS events (
      xid INTEGER PRIMARY KEY AUTOINCREMENT,
      Message TEXT,
      Id INTEGER,
      Version INTEGER,
      Level INTEGER,
      Task INTEGER,
      Opcode INTEGER,
      RecordId INTEGER,
      ProviderName TEXT,
      ProviderId TEXT,
      LogName TEXT,
      ProcessId INTEGER,
      ThreadId INTEGER,
      MachineName TEXT,
      UserId TEXT,
      OpcodeDisplayName TEXT
  );
"@
  )

  Get-Events -LogName "System" -StartTime $startTime | ForEach-Object {
    # Construct the INSERT statement for each event
    $query = @"
INSERT INTO events (
    Message, 
    Id,
    Version, 
    Level,
    Task, 
    Opcode, 
    RecordId, 
    ProviderName, 
    ProviderId, 
    LogName, 
    ProcessId, 
    ThreadId, 
    MachineName, 
    UserId
) VALUES (
    '$($_.Message.Replace("'", "''"))', 
    $($_.Id), 
    $($_.Version), 
    $($_.Level), 
    $($_.Task), 
    $($_.Opcode), 
    $($_.RecordId), 
    '$($_.ProviderName.Replace("'", "''"))', 
    '$($_.ProviderId)', 
    '$($_.LogName.Replace("'", "''"))', 
    $($_.ProcessId), 
    $($_.ThreadId), 
    '$($_.MachineName.Replace("'", "''"))', 
    '$($_.UserId)'
);
"@
    # Execute the query using the SQLite library
    [Sqlite]::Execute($db, $query)
  }

  [sqlite]::close($db)
}

<#
#>
#Get-Events -LogName "System" -StartTime $startTime | ft

<#
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
}
$securityEvents = Get-WinEvent -FilterHashTable $securityFilter -ErrorAction SilentlyContinue

$sysmonFilter = @{
  StartTime = $startTime
  EndTime = $endTime
  LogName = "Microsoft-Windows-Sysmon/Operational"
}
$sysmonEvents = Get-WinEvent -FilterHashTable $sysmonFilter -ErrorAction SilentlyContinue
#>
