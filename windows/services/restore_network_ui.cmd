sc config RmService start= disabled
sc config Wcmsvc start= auto
sc config NcbServe Start= demand
sc config Netman Start= auto
sc config netprofm Start= demand
REM this breaks dhcp
REM sc config nsi start= disabled