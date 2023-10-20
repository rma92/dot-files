@echo off
setlocal enabledelayedexpansion

rem Define the paths
set "_vimrc_target=%CD%\_vimrc"
set "_vimrc_link=%USERPROFILE%\_vimrc"

set "vimfiles_target=%CD%\vimfiles"
set "vimfiles_link=%USERPROFILE%\vimfiles"

rem Create symlinks
mklink "%_vimrc_link%" "%_vimrc_target%" >NUL 2>&1
if !errorlevel! equ 0 (
    echo Created symlink for _vimrc
) else (
    echo Failed to create symlink for _vimrc
)

mklink /d "%vimfiles_link%" "%vimfiles_target%" >NUL 2>&1
if !errorlevel! equ 0 (
    echo Created directory symlink for vimfiles
) else (
    echo Failed to create directory symlink for vimfiles
)

endlocal

