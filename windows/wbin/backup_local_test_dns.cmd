@echo off
setlocal enabledelayedexpansion

REM List of critical domains
set domains=graph.microsoft.com login.microsoftonline.com login.live.com account.microsoft.com officeapps.live.com view.officeapps.live.com

echo Checking connectivity to Microsoft services...

for %%D in (%domains%) do (
    echo.
    echo Testing %%D...
    nslookup %%D >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] %%D could not be resolved.
        set failed=1
    ) else (
        ping -n 1 %%D >nul 2>&1
        if errorlevel 1 (
            echo [WARNING] %%D resolved but did not respond to ping.
        ) else (
            echo [OK] %%D is reachable.
        )
    )
)

echo.
if defined failed (
    echo One or more critical domains failed to resolve.
    echo Please check your hosts file or network settings.
    exit /b 1
) else (
    echo All critical domains are reachable.
)

REM Proceed with backup or other tasks here...
REM call your-backup-script.bat

endlocal

