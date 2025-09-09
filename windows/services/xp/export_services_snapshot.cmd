@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem === output file ===
for /f "tokens=1-3 delims=/ " %%a in ("%date%") do set TODAY=%%c%%a%%b
set "OUT=services-config-%COMPUTERNAME%-%TODAY%.bat"

> "%OUT%" (
  echo @echo off
  echo rem Snapshot of service start types from %COMPUTERNAME% on %date% %time%
  echo rem Replay to restore: run as Administrator.
  echo.
)

rem === enumerate all services ===
for /f "tokens=2 delims=:" %%S in ('sc query type^= service state^= all ^| findstr /b /c:"SERVICE_NAME"') do (
  rem Trim leading spaces from the service name after the colon
  for /f "tokens=* delims= " %%A in ("%%S") do set "SVC=%%A"

  rem Pull the START_TYPE line and grab the number after the colon
  for /f "usebackq tokens=2 delims=:" %%x in (`sc qc "!SVC!" ^| findstr /c:"START_TYPE"`) do (
    rem %%x looks like " 2   AUTO_START" -> first token is the number
    for /f "tokens=1" %%n in ("%%x") do set "NUM=%%n"
    set "MODE="
    if "!NUM!"=="0" set "MODE=boot"
    if "!NUM!"=="1" set "MODE=system"
    if "!NUM!"=="2" set "MODE=auto"
    if "!NUM!"=="3" set "MODE=demand"
    if "!NUM!"=="4" set "MODE=disabled"

    if defined MODE (
      >>"%OUT%" echo sc config "!SVC!" start^= !MODE!
    ) else (
      >>"%OUT%" echo rem UNKNOWN START_TYPE for "!SVC!" (raw: %%x)
    )
  )
)

echo.
echo Wrote "%OUT%".
echo You can open it to review/edit, then run it (as Admin) to restore these start types.
endlocal

