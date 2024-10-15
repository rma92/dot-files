@echo off
setlocal

:: Check if curl is available
curl --version >nul 2>&1
if %errorlevel% equ 0 (
    echo Curl is available, using curl to download the file.
    curl %CURL_PROXY_OPTS% -L https://download.sysinternals.com/files/Sysmon.zip --output sysmon.zip
    expand ..\wbin\unzip.ex_ unzip.exe
    unzip sysmon.zip
) else (
    REM echo Curl is not available, using PowerShell to download the file.
    REM powershell -Command "Invoke-WebRequest -Uri 'https://download.sysinternals.com/files/Sysmon.zip' -OutFile 'sysmon.zip'"
    echo Curl is not available, using winjs to download the file.
    cmd /c ..\downloader\dump-winjs.cmd
    js https://download.sysinternals.com/files/Sysmon.zip -saveTo sysmon.zip
    expand ..\wbin\unzip.ex_ unzip.exe
    unzip sysmon.zip
)

REM Normal system: sysmon64 -i swift-nodns.xml
REM Server: sysmon64 -i swift-config.xml
endlocal

