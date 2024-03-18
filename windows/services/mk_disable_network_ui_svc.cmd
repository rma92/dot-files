sc config RmService start= disabled
sc config Wcmsvc start= disabled
sc config NcbServe Start= disabled
sc config Netman Start= disabled
sc config netprofm Start= disabled
REM this breaks dhcp
REM sc config nsi start= disabled