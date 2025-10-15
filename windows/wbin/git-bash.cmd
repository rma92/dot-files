@echo off
REM Launch Git for Windows' Bash in the current directory.
REM If args are provided, run them as a bash command/script.

setlocal

REM --- Locate Git Bash (adjust if you installed elsewhere) ---
set "BASH_EXE=C:\Program Files\Git\usr\bin\bash.exe"
if not exist "%BASH_EXE%" (
  echo Git Bash not found at: "%BASH_EXE%"
  echo Update BASH_EXE in this file to your Git installation path.
  exit /b 1
)

REM --- Keep working directory (don’t cd to HOME) ---
set "CHERE_INVOKING=1"

REM --- Work from the directory where the user ran this file ---
cd /d "%cd%"

if "%~1"=="" (
  REM No args: open an interactive Git Bash in this folder
  "%BASH_EXE%" --login -i
) else (
  REM With args: run the provided command/script from this folder
  REM Example: git-bash.cmd ./myscript.sh arg1
  "%BASH_EXE%" --login -c "%*"
)

endlocal

