@echo off
@REM usage: apply_profile.cmd bv_xp_safe.txt
setlocal EnableExtensions

if "%~1"=="" (
  echo Usage: %~nx0 ^<profile.txt^>
  echo Each line:  ServiceName  StartType
  echo StartType: auto ^| demand ^| disabled ^| boot ^| system
  exit /b 1
)

set "LIST=%~1"
if not exist "%LIST%" (
  echo Profile file "%LIST%" not found.
  exit /b 2
)

echo This will change service start types per "%LIST%".
choice /m "Proceed"
if errorlevel 2 exit /b 3

for /f "usebackq tokens=1,2 delims=,= " %%A in ("%LIST%") do (
  rem skip blank/comment lines
  if not "%%A"=="" if /i not "%%A"=="rem" if not "%%A"=="::" (
    set "SVC=%%A"
    set "MODE=%%B"
    if /i "%%B"=="auto"    set "MODE=auto"
    if /i "%%B"=="manual"  set "MODE=demand"
    if /i "%%B"=="demand"  set "MODE=demand"
    if /i "%%B"=="disabled" set "MODE=disabled"
    if /i "%%B"=="boot"    set "MODE=boot"
    if /i "%%B"=="system"  set "MODE=system"

    if defined MODE (
      echo sc config "!SVC!" start^= !MODE!
      sc config "!SVC!" start= !MODE! >nul
    ) else (
      echo Skipping "%%A" - unrecognized mode "%%B"
    )
  )
)

echo Done.
endlocal

