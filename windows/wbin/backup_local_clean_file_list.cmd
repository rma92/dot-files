@echo off
setlocal enabledelayedexpansion

set "input=rclone-filelist.txt"
set "output=rclone-filelist-clean.txt"

> "%output%" (
    for /f "tokens=1,2,3* delims= " %%A in (%input%) do (
        set "ts=%%B"
        set "ts=!ts:~0,10! %%C"
        echo %%A !ts! %%D
    )
)

echo Cleaned file list saved to %output%
endlocal

