REM this installs vim in this directory and adds it to the right-click menu
if not defined CURL_PROXY_OPTS set CURL_PROXY_OPTS=

%~d0
cd %~dp0
curl %CURL_PROXY_OPTS% -L "https://github.com/vim/vim-win32-installer/releases/download/v9.1.0/gvim_9.1.0_x64_signed.zip" --output gvim_9.1.0_x64_signed.zip
REM powershell -command "Expand-Archive -Force gvim_9.1.0_x64_signed.zip gvim91p"
expand unzip.ex_ unzip.exe
unzip.exe -qq -o gvim_9.1.0_x64_signed.zip -d gvim91p
SETX VIM %CD%\gvim91p\vim
SETX VIMRUNTIME %CD%\gvim91p\vim\vim91
@curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/_vimrc --output %CD%\gvim91p\vim\vimrc
@curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/colors/bbx.vim --output %CD%\gvim91p\vim\vim91\colors\bbx.vim
@curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/syntax/ps1.vim --output %CD%\gvim91p\vim\vim91\syntax\ps1.vim
@curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/indent/ps1.vim --output %CD%\gvim91p\vim\vim91\indent\ps1.vim
@curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/ftplugin/ps1.vim --output %CD%\gvim91p\vim\vim91\ftplugin\ps1.vim
@curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/doc/ps1.txt --output %CD%\gvim91p\vim\vim91\doc\ps1.txt
@curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/README_ps1.markdown --output %CD%\gvim91p\vim\vim91\doc\README_ps1.markdown
@curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/wbin/gvim_bats/gvim.bat --output %CD%\gvim.bat
@curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/wbin/gvim_bats/gvimdiff.bat --output %CD%\gvimdiff.bat
@curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/wbin/gvim_bats/vim.bat --output %CD%\vim.bat
@curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/wbin/gvim_bats/vimdiff.bat --output %CD%\vimdiff.bat

reg add "HKEY_CURRENT_USER\SOFTWARE\Classes\*\Shell\Vim" /ve /t REG_SZ /d "Edit with &Vim" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Classes\*\Shell\Vim" /v "Icon" /t REG_SZ /d "%~dp0gvim91p\vim\vim91\gvim.exe" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Classes\*\Shell\Vim\command" /ve /t REG_SZ /d "%~dp0gvim91p\vim\vim91\gvim.exe \"^%%1\"" /f
