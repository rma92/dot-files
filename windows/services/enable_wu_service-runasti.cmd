@REM runasti enable_wu_service-runasti.cmd

sc config WaaSMedicSvc start= demand
sc config wuauserv start= demand
sc config UsoSvc start= demand
sc config BITS start= demand
sc config DoSvc start= demand
sc config SecurityHealthService start= demand
sc config WaaSMedicSvc start= demand

pause
