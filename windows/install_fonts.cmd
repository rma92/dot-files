@echo off
setlocal enabledelayedexpansion

rem Define the source directory containing the fonts
set "source=%CD%\Fonts"

rem Check if the source directory exists
if not exist "%source%" (
    echo Source directory does not exist.
    exit /b 1
)

rem Define the destination directory (the Windows Fonts folder)
set "destination=%SystemRoot%\Fonts"

rem Loop through each font file in the source directory and copy it to the destination
for %%i in ("%source%\*.*") do (
    set "fontFile=%%~nxi"
    copy "%%i" "%destination%\!fontFile!" /Y >NUL 2>&1
    if !errorlevel! equ 0 (
        echo Installed font: !fontFile!
    ) else (
        echo Failed to install font: !fontFile!
    )
)

endlocal

