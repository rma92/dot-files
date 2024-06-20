@echo off
rem -- Run Vim --
rem # uninstall key: vim90 #

setlocal
set VIM_EXE_DIR=C:\Program Files (x86)\Vim\vim90
if exist "%VIM%\vim90\vimtutor.bat" set VIM_EXE_DIR=%VIM%\vim90
if exist "%VIMRUNTIME%\vimtutor.bat" set VIM_EXE_DIR=%VIMRUNTIME%

if not exist "%VIM_EXE_DIR%\vimtutor.bat" (
    echo "%VIM_EXE_DIR%\vimtutor.bat" not found
    goto :eof
)

"%VIM_EXE_DIR%\vimtutor.bat"  %*
