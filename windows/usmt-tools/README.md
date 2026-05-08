# USMT Export/Import Helpers

These PowerShell scripts wrap the Windows User State Migration Tool (USMT) for a full local migration store, plus explicit user/system environment variable sidecars.

Install the Windows ADK User State Migration Tool feature on both machines, then run the scripts from an elevated PowerShell prompt.

## Export

```powershell
.\Export-USMTState.ps1 -DestinationRoot D:\migration
```

This creates a directory such as `D:\migration\usmt-export-20260508-181500` containing:

- `store\`: USMT migration store created by `scanstate.exe`.
- `logs\`: scanstate logs and progress.
- `sidecar\`: user/system environment variables as JSON and `.reg` backups.
- `manifest.json`: source metadata and scanstate arguments.

Useful options:

```powershell
.\Export-USMTState.ps1 -DestinationRoot D:\migration -IncludeUsers 'OLDPC\alice'
.\Export-USMTState.ps1 -DestinationRoot D:\migration -ExcludeUsers 'OLDPC\temp*'
.\Export-USMTState.ps1 -DestinationRoot D:\migration -USMTPath 'C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\User State Migration Tool\amd64'
```

## Import

```powershell
.\Import-USMTState.ps1 -ExportDirectory D:\migration\usmt-export-20260508-181500 -CreateLocalAccounts
```

To restore environment variables explicitly:

```powershell
.\Import-USMTState.ps1 -ExportDirectory D:\migration\usmt-export-20260508-181500 -RestoreUserEnvironment -RestoreSystemEnvironment
```

Selective examples:

```powershell
.\Import-USMTState.ps1 -ExportDirectory D:\migration\usmt-export-20260508-181500 -IncludeUsers 'OLDPC\alice'
.\Import-USMTState.ps1 -ExportDirectory D:\migration\usmt-export-20260508-181500 -SkipUSMT -RestoreSystemEnvironment
```

Notes:

- Run import before heavy customization of the destination profile where possible.
- `-CreateLocalAccounts` passes USMT `/lac`; add `-EnableCreatedAccounts` to pass `/lae`.
- The scripts use `MigApp.xml` and `MigDocs.xml` from the installed USMT folder.
- Environment variable changes are written to the registry, but existing processes do not see them until restart or sign out/in.
