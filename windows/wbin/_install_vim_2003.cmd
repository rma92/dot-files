REM this installs vim in this directory and adds it to the right-click menu
if not defined CURL_PROXY_OPTS set CURL_PROXY_OPTS=

%~d0
cd %~dp0
REM curl %CURL_PROXY_OPTS% -L "https://github.com/vim/vim-win32-installer/releases/download/v9.1.0/gvim_9.1.0_x64_signed.zip" --output gvim_9.1.0_x64_signed.zip
cmd /c ..\downloader\dump-winjs.cmd
cmd /c js "https://github.com/vim/vim-win32-installer/releases/download/v9.0.2189/gvim_9.0.2189_x86.zip" -saveTo gvim_9.0.2189_x86.zip -ignoreCertError yes -force yes
expand unzip.ex_ unzip.ex
unzip.exe -qq -o gvim_9.0.2189_x86.zip -d gvim90p
SETX VIM %CD%\gvim90p\vim
SETX VIMRUNTIME %CD%\gvim90p\vim\vim90
copy ../_vimrc %CD%\gvim90p\vim\vimrc
xcopy /E ..\vimfiles \gvim90p\vim\vim90\
reg add "HKEY_CURRENT_USER\SOFTWARE\Classes\*\Shell\Vim" /ve /t REG_SZ /d "Edit with &Vim" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Classes\*\Shell\Vim" /v "Icon" /t REG_SZ /d "%~dp0gvim90p\vim\vim90\gvim.exe" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Classes\*\Shell\Vim\command" /ve /t REG_SZ /d "%~dp0gvim90p\vim\vim90\gvim.exe \"^%%1\"" /f
