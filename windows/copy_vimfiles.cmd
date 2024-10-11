copy "%CD%\_vimrc" "%USERPROFILE%\_vimrc"
ren "%USERPROFILE%\vimfiles" vimfiles_old
xcopy /E /I /Y ".\vimfiles" "%USERPROFILE%\vimfiles\"
pause
