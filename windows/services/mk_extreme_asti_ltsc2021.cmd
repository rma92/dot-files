sc config AxInstSV Start= disabled
sc config CDPSvc Start= disabled
sc config DusmSvc Start= disabled
sc config EventLog Start= disabled
sc config FontCache Start= disabled
sc config CscService start= disabled

sc config ShellHWDetection Start= disabled
sc config Themes Start= disabled
sc config TrkWks Start= disabled
sc config DispBrokerDesktopSvc Start= disabled


sc config iphlpsvc start= disabled
sc config WinHttpAutoProxySvc start= disabled
sc config DnsCache start= disabled

REM net sec stuff
REM sc config KeyIso Start= disabled

REM network connections stuff
REM sc config RmService start= disabled
REM sc config Wcmsvc start= disabled
rem sc config NcbServe Start= disabled
rem sc config Netman Start= disabled
rem sc config netprofm Start= disabled

REM Windows Update/Modules
rem sc config TrustedInstaller start= disabled


REM WinRT stuff
REM sc config TokenBroker start= disabled
