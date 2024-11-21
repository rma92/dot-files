REM this installs vim in this directory and adds it to the right-click menu
%~d0
cd %~dp0
cmd /c ..\downloader\dump-winjs.cmd
cmd /c js "https://github.com/vim/vim-win32-installer/releases/download/v8.0.0003/gvim_8.0.0003_x86.zip" -saveTo gvim_8.0.0003_x86.zip -ignoreCertError yes -force yes
expand unzip.ex_ unzip.exe
unzip.exe -qq -o gvim_8.0.0003_x86.zip -d gvim80p
SETX VIM %CD%\gvim80p\vim
SETX VIMRUNTIME %CD%\gvim80p\vim\vim80
copy ../_vimrc %CD%\gvim80p\vim\vimrc
xcopy /E ..\vimfiles \gvim80p\vim\vim80\
reg add "HKEY_CURRENT_USER\SOFTWARE\Classes\*\Shell\Vim" /ve /t REG_SZ /d "Edit with &Vim" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Classes\*\Shell\Vim" /v "Icon" /t REG_SZ /d "%~dp0gvim80p\vim\vim80\gvim.exe" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Classes\*\Shell\Vim\command" /ve /t REG_SZ /d "%~dp0gvim80p\vim\vim80\gvim.exe \"^%%1\"" /f
