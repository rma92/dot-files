start cmd /c setsvc BITS 4
start cmd /c setsvc WaaSMedicSvc 4
start cmd /c setsvc wuauserv 4
start cmd /c setsvc UsoSvc 4
start cmd /c runasti schtasks /Change /TN "\Microsoft\Windows\WaaSMedic\WaaSMedic PerformRemediation" /Disable
@REM a copy of the PerformRemediation task is present in this directory.
