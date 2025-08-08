@echo off
setlocal

set "batchDir=%~dp0"
set "localHosts=%batchDir%hosts"
set "systemHosts=%SystemRoot%\System32\drivers\etc\hosts"
if not exist "%localHosts%" (
    echo Local hosts file not found: %localHosts%
    exit /b 1
)
echo Appending contents of %localHosts% to %systemHosts%
type "%localHosts%" >> "%systemHosts%"

echo Done.
endlocal

