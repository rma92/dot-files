REM start cmd /c setsvc BITS 4
REM start cmd /c setsvc WaaSMedicSvc 4
REM start cmd /c setsvc wuauserv 4
REM start cmd /c setsvc UsoSvc 4
start cmd /c runasti cmd /c sc stop WaaSMedicSvc
start cmd /c runasti cmd /c sc stop wuauserv
start cmd /c runasti cmd /c sc stop UsoSvc
start cmd /c runasti cmd /c sc stop BITS

start cmd /c runasti cmd /c sc config WaaSMedicSvc start= disabled
start cmd /c runasti cmd /c sc config wuauserv start= disabled
start cmd /c runasti cmd /c sc config UsoSvc start= disabled
start cmd /c runasti cmd /c sc config BITS start= disabled
start cmd /c runasti schtasks /Change /TN "\Microsoft\Windows\WaaSMedic\WaaSMedic PerformRemediation" /Disable
start cmd /c runasti schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" /Disable
@REM a copy of the PerformRemediation task is present in this directory.
