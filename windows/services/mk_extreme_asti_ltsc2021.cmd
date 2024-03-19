sc config SSDPSRV start= disabled
sc config AxInstSV Start= disabled
rem sc config CDPSvc Start= disabled
sc config DusmSvc Start= disabled
sc config EventLog Start= disabled
sc config FontCache Start= disabled
sc config CscService start= disabled

sc config ShellHWDetection Start= disabled
sc config Themes Start= disabled
sc config TrkWks Start= disabled
sc config DispBrokerDesktopSvc Start= disabled
sc config DispEnhancementService Start= disabled

sc config wpdbusenum start= disabled
sc config WSearch Start= disabled

REM above here
REM other things
sc config camsvc start= disabled
sc config dps start= disabled
sc config wdiservicehost start= disabled
start cmd /c setsvc iphlpsvc 4
start cmd /c setsvc WinHttpAutoProxySvc 4
start cmd /c setsvc DnsCache 4


rem this must be done with the registry.
rem sc config iphlpsvc start= disabled
rem sc config WinHttpAutoProxySvc start= disabled
rem sc config DnsCache start= disabled
rem sc config SgrmBroker start= disabled (system guard)
rem sc config wscsvc start= disabled
rem sc config SecurityHealthService start= disabled

REM net sec stuff
sc config KeyIso Start= disabled

REM network connections stuff
REM sc config RmService start= disabled
REM sc config Wcmsvc start= disabled
rem sc config NcbServe Start= disabled
rem sc config Netman Start= disabled
rem sc config netprofm Start= disabled
rem sc config nsi start= disabled

REM Windows Update/Modules
rem sc config TrustedInstaller start= disabled

REM app compatibility - compatability options don't work with these disabled.
rem sc config pcasvc start= disabled

REM WinRT stuff
REM sc config TokenBroker start= disabled
