# Services scripts
Run everything _that makes changes_ either with admin powershell or run it using RunAsTi.cmd from Atlas.

Export current services settings to a script, in cmd run:
```batch
powershell " Get-WMIObject win32_service | Select Name, DisplayName, StartMode, State | Sort Name | ForEach-Object { Write-Host sc config $_.Name start= $_.StartMode } " > restore1.cmd
```

Display the current services configuration in Powershell:
```powershell
Get-WMIObject win32_service | Select Name, DisplayName, StartMode, State | Sort Name
```

# Sample Script - Set services to preferred or current settings
Run this in a powershell console, and copy the output
```powershell
$_desired_config = @{}
$_desired_config["wsearch"] = "Disabled";
$_desired_config["AJRouter"] = "Disabled";
$_Udc = @{};
#make everything uppercase.
foreach( $K in $_desired_config.Keys ) { $_Udc[$K.ToUpper()] = $_desired_config[$K]; }


 Get-WMIObject win32_service | Select Name, DisplayName, StartMode, State | Sort Name | ForEach-Object { 
  if( $_Udc[ $_.Name.ToUpper() ] -ne $null ) {Write-Host sc config $_.Name start= $_Udc[ $_.Name.ToUpper() ] }
  else { Write-Host sc config $_.Name start= $_.StartMode }
 }
```

# Set the services to either the current settings or as recommended by CIS baselines
Run this in a powershell console, and copy the output
```powershell
$_desired_config = @{}
#PriSec Config
$_desired_config["DiagTrack"] = "Disabled";
$_desired_config["AJRouter"] = "Disabled";

#CIS Baselines
#RDP Stuff
#$_desired_config[ "SessionEnv" ] = "Disabled";
$_desired_config[ "SessionEnv" ] = "Demand";
#$_desired_config[ "TermServ" ] = "Disabled";
$_desired_config[ "TermServ" ] = "Automatic";
#$_desired_config[ "UmRdpService" ] = "Disabled";
$_desired_config[ "UmRdpService" ] = "Demand";
#End RDP Stuff
$_desired_config[ "LxssManager" ] = "Disabled"; #WSL
$_desired_config[ "icssvc" ] = "Disabled"; #Mobile Hotspot

$_desired_config["BTAGService"] = "Demand";
$_desired_config["bthserv"] = "Demand";
$_desired_config["Browser"] = "Disabled";
$_desired_config["MapsBroker"] = "Disabled";
$_desired_config["lfsvc"] = "Demand";
$_desired_config["irmon"] = "Disabled";
#$_desired_config["SharedAccess"] = "Disabled";
$_desired_config[ "lltdsvc" ] = "Disabled";

$_desired_config[ "FTPSVC" ] = "Disabled";
$_desired_config[ "MSiSCSI" ] = "Disabled";
$_desired_config[ "sshd" ] = "Disabled";
$_desired_config[ "PNRPsvc" ] = "Disabled";
$_desired_config[ "p2psvc" ] = "Disabled";
$_desired_config[ "p2pimsvc" ] = "Disabled";
$_desired_config[ "PNRPAutoReg" ] = "Disabled";
$_desired_config[ "wercplsupport" ] = "Disabled";
$_desired_config[ "RasAuto" ] = "Disabled";
$_desired_config[ "RpcLocator" ] = "Disabled";
$_desired_config[ "RemoteRegistry" ] = "Disabled";
$_desired_config[ "RemoteAccess" ] = "Disabled";
$_desired_config[ "LanmanServer" ] = "Disabled";
$_desired_config[ "simptcp" ] = "Disabled";
$_desired_config[ "SNMP" ] = "Disabled";
$_desired_config[ "SNMPTrap" ] = "Disabled"; #Disabled for VMs
$_desired_config[ "sacsvr" ] = "Disabled";
$_desired_config[ "ssdpsrv" ] = "Disabled";
$_desired_config[ "upnphost" ] = "Disabled";
$_desired_config[ "WMSvc" ] = "Disabled"; #IIS
$_desired_config[ "WerSvc" ] = "Disabled";
$_desired_config[ "WMPNetworkSvc" ] = "Disabled";
$_desired_config[ "WpnService" ] = "Disabled";
$_desired_config[ "PushToInstall" ] = "Disabled";
$_desired_config[ "WinRM" ] = "Disabled";
$_desired_config[ "W3SVC" ] = "Disabled"; #IIS
$_desired_config[ "XboxGipSvc" ] = "Disabled";
$_desired_config[ "XblAuthManager" ] = "Disabled";
$_desired_config[ "XblGameSave" ] = "Disabled";
$_desired_config[ "XboxNetApiSvc" ] = "Disabled";

#Performance options
$_desired_config[ "ALG" ] = "Disabled";
$_desired_config[ "PeerDistSvc" ] = "Disabled"; #BranchCache
$_desired_config[ "NfsClnt" ] = "Disabled"; #NFS
$_desired_config[ "Fax" ] = "Disabled";
$_desired_config[ "SmsRouter" ] = "Disabled";
$_desired_config[ "PhoneSvc" ] = "Disabled";
$_desired_config[ "CscService" ] = "Disabled";
$_desired_config[ "WpcMonSvc" ] = "Disabled";
$_desired_config[ "SEMgrSvc" ] = "Disabled";
$_desired_config[ "RetailDemo" ] = "Disabled";
$_desired_config[ "wisvc" ] = "Disabled";

$_Udc = @{};
#make everything uppercase.
foreach( $K in $_desired_config.Keys ) { $_Udc[$K.ToUpper()] = $_desired_config[$K]; }

Get-WMIObject win32_service | Select Name, DisplayName, StartMode, State | Sort Name | ForEach-Object {
if( $_Udc[ $_.Name.ToUpper() ] -ne $null ) {Write-Host sc config $_.Name start= $_Udc[ $_.Name.ToUpper() ] }
#Write-Host sc config $_.Name start= $_.StartMode
}
```

# Blackviper scripts
This is based on the old Blackviper config from: https://github.com/madbomb122/BlackViperScript

Before doing anything, export your current configuration if you want to restore it.

The numbers mean:
* 0 -Not Installed/Skip, 1 -Disable, 2 -Manual, 3 -Automatic, 4 -Auto (Delayed)
* Negative Numbers are the same as above but wont be used unless you select it or use the All Setting

The CSV files contain the config, the Excel sheet was used to build out the script.

## Tweaked Script
Run this in powershell, copy the output, run as admin to set the service config.

Note that WWAN config and WLAN config are commented out to avoid a mishap with a laptop.

Two xbox services are commented out in manual and set to disabled, as they're not useful in most of my environment.  Change this if you need them, or use Xbox Live games.

Terminal Services and Bluetooth are commented out as I often need them.

**The output of this is in mk_blackviper.cmd - this can be run in an admin cmd to make the changes.  Run it in an interactive shell so that you can see if any errors occurred.**
```powershell
$_desired_config = @{}
#MSec Config
$_desired_config["DiagTrack"] = "Disabled";

$_desired_config["AJRouter"] = "Disabled";
$_desired_config["ALG"] = "Disabled";
$_desired_config["AppMgmt"] = "Disabled";
#$_desired_config["BthAvctpSvc"] = "Disabled";
#$_desired_config["BTAGService"] = "Disabled";
#$_desired_config["BthHFSrv"] = "Disabled";
#$_desired_config["bthserv"] = "Disabled";
$_desired_config["PeerDistSvc"] = "Disabled";
$_desired_config["CaptureService_?????"] = "Disabled";
$_desired_config["CertPropSvc"] = "Disabled";
$_desired_config["dmwappushsvc"] = "Disabled";
$_desired_config["MapsBroker"] = "Disabled";
$_desired_config["Fax"] = "Disabled";
$_desired_config["lfsvc"] = "Disabled";
$_desired_config["HvHost"] = "Disabled";
$_desired_config["vmickvpexchange"] = "Disabled";
$_desired_config["vmicguestinterface"] = "Disabled";
$_desired_config["vmicshutdown"] = "Disabled";
$_desired_config["vmicheartbeat"] = "Disabled";
$_desired_config["vmicvmsession"] = "Disabled";
$_desired_config["vmicrdv"] = "Disabled";
$_desired_config["vmictimesync"] = "Disabled";
$_desired_config["vmicvss"] = "Disabled";
#$_desired_config["irmon"] = "Disabled";
$_desired_config["SharedAccess"] = "Disabled";
$_desired_config["iphlpsvc"] = "Disabled";
$_desired_config["IpxlatCfgSvc"] = "Disabled";
$_desired_config["MSiSCSI"] = "Disabled";
$_desired_config["SmsRouter"] = "Disabled";
$_desired_config["NaturalAuthentication"] = "Disabled";
$_desired_config["NetTcpPortSharing"] = "Disabled";
$_desired_config["Netlogon"] = "Disabled";
$_desired_config["NcdAutoSetup"] = "Disabled";
$_desired_config["CscService"] = "Disabled";
$_desired_config["WpcMonSvc"] = "Disabled";
$_desired_config["SEMgrSvc"] = "Disabled";
$_desired_config["PhoneSvc"] = "Disabled";
$_desired_config["SessionEnv"] = "Disabled";
#$_desired_config["TermService"] = "Disabled";
$_desired_config["UmRdpService"] = "Disabled";
$_desired_config["RpcLocator"] = "Disabled";
$_desired_config["RetailDemo"] = "Disabled";
$_desired_config["SensorDataService"] = "Disabled";
$_desired_config["SensrSvc"] = "Disabled";
$_desired_config["SensorService"] = "Disabled";
$_desired_config["ScDeviceEnum"] = "Disabled";
$_desired_config["SCPolicySvc"] = "Disabled";
$_desired_config["SNMPTRAP"] = "Disabled";
$_desired_config["TabletInputService"] = "Disabled";
$_desired_config["WebClient"] = "Disabled";
$_desired_config["WFDSConSvc"] = "Disabled";
$_desired_config["FrameServer"] = "Disabled";
$_desired_config["wcncsvc"] = "Disabled";
$_desired_config["wisvc"] = "Disabled";
$_desired_config["WMPNetworkSvc"] = "Disabled";
$_desired_config["icssvc"] = "Disabled";
$_desired_config["WinRM"] = "Disabled";
$_desired_config["workfolderssvc"] = "Disabled";
#$_desired_config["WwanSvc"] = "Disabled";
$_desired_config["XblAuthManager"] = "Disabled";
$_desired_config["XblGameSave"] = "Disabled";
$_desired_config["XboxNetApiSvc"] = "Disabled";
#$_desired_config["WlanSvc"] = "Disabled";

$_desired_config["AxInstSV"] = "Demand";
$_desired_config["AppReadiness"] = "Demand";
$_desired_config["AppIDSvc"] = "Demand";
$_desired_config["Appinfo"] = "Demand";
$_desired_config["aspnet_state"] = "Demand";
$_desired_config["AssignedAccessManagerSvc"] = "Demand";
$_desired_config["BDESVC"] = "Demand";
$_desired_config["wbengine"] = "Demand";
$_desired_config["BluetoothUserService_?????"] = "Demand";
$_desired_config["camsvc"] = "Demand";
$_desired_config["c2wts"] = "Demand";
$_desired_config["KeyIso"] = "Demand";
$_desired_config["COMSysApp"] = "Demand";
$_desired_config["Browser"] = "Demand";
$_desired_config["VaultSvc"] = "Demand";
$_desired_config["DsSvc"] = "Demand";
$_desired_config["DeviceAssociationService"] = "Demand";
$_desired_config["DeviceInstall"] = "Demand";
$_desired_config["DmEnrollmentSvc"] = "Demand";
$_desired_config["DsmSVC"] = "Demand";
$_desired_config["DevQueryBroker"] = "Demand";
$_desired_config["diagsvc"] = "Demand";
$_desired_config["WdiServiceHost"] = "Demand";
$_desired_config["WdiSystemHost"] = "Demand";
$_desired_config["MSDTC"] = "Demand";
$_desired_config["DsRoleSvc"] = "Demand";
$_desired_config["embeddedmode"] = "Demand";
$_desired_config["EFS"] = "Demand";
$_desired_config["EapHost"] = "Demand";
$_desired_config["fhsvc"] = "Demand";
$_desired_config["fdPHost"] = "Demand";
$_desired_config["FDResPub"] = "Demand";
$_desired_config["BcastDVRUserService_?????"] = "Demand";
$_desired_config["GraphicsPerfSvc"] = "Demand";
$_desired_config["HomeGroupListener"] = "Demand";
$_desired_config["HomeGroupProvider"] = "Demand";
$_desired_config["hns"] = "Demand";
$_desired_config["hidserv"] = "Demand";
$_desired_config["vmcompute"] = "Demand";
$_desired_config["IKEEXT"] = "Demand";
$_desired_config["UI0Detect"] = "Demand";
$_desired_config["PolicyAgent"] = "Demand";
$_desired_config["KtmRm"] = "Demand";
$_desired_config["lltdsvc"] = "Demand";
$_desired_config["wlpasvc"] = "Demand";
$_desired_config["MessagingService_?????"] = "Demand";
$_desired_config["diagnosticshub.standardcollector.service"] = "Demand";
$_desired_config["wlidsvc"] = "Demand";
$_desired_config["swprv"] = "Demand";
$_desired_config["smphost"] = "Demand";
$_desired_config["InstallService"] = "Demand";
$_desired_config["NcbService"] = "Demand";
$_desired_config["Netman"] = "Demand";
$_desired_config["NcaSVC"] = "Demand";
$_desired_config["netprofm"] = "Demand";
$_desired_config["NetSetupSvc"] = "Demand";
$_desired_config["ssh-agent"] = "Demand";
$_desired_config["defragsvc"] = "Demand";
$_desired_config["PNRPsvc"] = "Demand";
$_desired_config["p2psvc"] = "Demand";
$_desired_config["p2pimsvc"] = "Demand";
$_desired_config["PerfHost"] = "Demand";
$_desired_config["pla"] = "Demand";
$_desired_config["PlugPlay"] = "Demand";
$_desired_config["PNRPAutoReg"] = "Demand";
$_desired_config["WPDBusEnum"] = "Demand";
$_desired_config["PrintNotify"] = "Demand";
$_desired_config["PrintWorkflowUserSvc_?????"] = "Demand";
$_desired_config["wercplsupport"] = "Demand";
$_desired_config["QWAVE"] = "Demand";
$_desired_config["RmSvc"] = "Demand";
$_desired_config["RasAuto"] = "Demand";
$_desired_config["RasMan"] = "Demand";
$_desired_config["seclogon"] = "Demand";
$_desired_config["SstpSvc"] = "Demand";
$_desired_config["SharedRealitySvc"] = "Demand";
$_desired_config["svsvc"] = "Demand";
$_desired_config["SSDPSRV"] = "Demand";
$_desired_config["WiaRpc"] = "Demand";
$_desired_config["StorSvc"] = "Demand";
$_desired_config["TieringEngineService"] = "Demand";
$_desired_config["lmhosts"] = "Demand";
$_desired_config["TapiSrv"] = "Demand";
$_desired_config["TimeBroker"] = "Demand";
$_desired_config["UsoSvc"] = "Demand";
$_desired_config["upnphost"] = "Demand";
$_desired_config["vds"] = "Demand";
$_desired_config["VSS"] = "Demand";
$_desired_config["W3LOGSVC"] = "Demand";
$_desired_config["WalletService"] = "Demand";
$_desired_config["WarpJITSvc"] = "Demand";
$_desired_config["TokenBroker"] = "Demand";
$_desired_config["SDRSVC"] = "Demand";
$_desired_config["WbioSrvc"] = "Demand";
$_desired_config["Sense"] = "Demand";
$_desired_config["wudfsvc"] = "Demand";
$_desired_config["WEPHOSTSVC"] = "Demand";
$_desired_config["WerSvc"] = "Demand";
$_desired_config["Wecsvc"] = "Demand";
$_desired_config["StiSvc"] = "Demand";
$_desired_config["LicenseManager"] = "Demand";
$_desired_config["TrustedInstaller"] = "Demand";
$_desired_config["spectrum"] = "Demand";
$_desired_config["PushToInstall"] = "Demand";
$_desired_config["W32Time"] = "Demand";
$_desired_config["wuauserv"] = "Demand";
$_desired_config["WaaSMedicSvc"] = "Demand";
$_desired_config["WinHttpAutoProxySvc"] = "Demand";
$_desired_config["dot3svc"] = "Demand";
$_desired_config["wmiApSrv"] = "Demand";
#$_desired_config["XboxGipSvc"] = "Demand";
#$_desired_config["xbgm"] = "Demand";

$_desired_config["XboxGipSvc"] = "Disabled";
$_desired_config["xbgm"] = "Disabled";

$_Udc = @{};

foreach( $K in $_desired_config.Keys ) { $_Udc[$K.ToUpper()] = $_desired_config[$K]; }

Get-WMIObject win32_service | Select Name, DisplayName, StartMode, State | Sort Name | ForEach-Object {
if( $_Udc[ $_.Name.ToUpper() ] -ne $null ) {Write-Host sc config $_.Name start= $_Udc[ $_.Name.ToUpper() ] }
#Write-Host sc config $_.Name start= $_.StartMode
}
```
