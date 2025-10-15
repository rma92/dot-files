@REM runasti disable_wu_service-runasti.cmd

sc stop WaaSMedicSvc
sc stop wuauserv
sc stop UsoSvc
sc stop BITS
sc stop DoSvc
sc stop SecurityHealthService
sc stop WaaSMedicSvc

sc config WaaSMedicSvc start= disabled
sc config wuauserv start= disabled
sc config UsoSvc start= disabled
sc config BITS start= disabled
sc config DoSvc start= disabled
sc config SecurityHealthService start= disabled
sc config WaaSMedicSvc start= disabled

pause
