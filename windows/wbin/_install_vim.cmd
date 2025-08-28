REM  to make the script standalone, comment out the copy lines and uncoment the curl lines that download files from github.
REM  
if not defined CURL_PROXY_OPTS set CURL_PROXY_OPTS=
%~d0
cd %~dp0
set wbin_dir=%~dp0

curl %CURL_PROXY_OPTS% -L "https://github.com/vim/vim-win32-installer/releases/download/v9.1.0/gvim_9.1.0_x64_signed.zip" --output gvim_9.1.0_x64_signed.zip
REM powershell -command "Expand-Archive -Force gvim_9.1.0_x64_signed.zip gvim91p"
expand unzip.ex_ unzip.exe
unzip -qq -o gvim_9.1.0_x64_signed.zip -d gvim91p

SETX VIM %wbin_dir%gvim91p\vim
SETX VIMRUNTIME %wbin_dir%gvim91p\vim\vim91
copy %~dp0\..\_vimrc %wbin_dir%gvim91p\vim\vimrc
copy %~dp0\..\vimfiles\colors\bbx.vim %wbin_dir%gvim91p\vim\vim91\colors\bbx.vim
copy %~dp0\..\vimfiles\colors\ps1.vim %wbin_dir%gvim91p\vim\vim91\syntax\ps1.vim
copy %~dp0\..\vimfiles\indent\ps1.vim %wbin_dir%gvim91p\vim\vim91\indent\ps1.vim
copy %~dp0\..\vimfiles\indent\ps1.vim %wbin_dir%gvim91p\vim\vim91\indent\ps1.vim
copy %~dp0\..\vimfiles\ftplugin\ps1.vim %wbin_dir%gvim91p\vim\vim91\ftplugin\ps1.vim
copy %~dp0\gvim_bats\gvim.bat %~dp0
copy %~dp0\gvim_bats\gvimdiff.bat %~dp0
copy %~dp0\gvim_bats\vim.bat %~dp0
copy %~dp0\gvim_bats\vimdiff.bat %~dp0


REM curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/_vimrc --output %wbin_dir%gvim91p\vim\vimrc
REM curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/colors/bbx.vim --output %wbin_dir%gvim91p\vim\vim91\colors\bbx.vim
REM curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/syntax/ps1.vim --output %wbin_dir%gvim91p\vim\vim91\syntax\ps1.vim
REM curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/indent/ps1.vim --output %wbin_dir%gvim91p\vim\vim91\indent\ps1.vim
REM curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/ftplugin/ps1.vim --output %wbin_dir%gvim91p\vim\vim91\ftplugin\ps1.vim
REM curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/doc/ps1.txt --output %wbin_dir%gvim91p\vim\vim91\doc\ps1.txt
REM curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/README_ps1.markdown --output %wbin_dir%gvim91p\vim\vim91\doc\README_ps1.markdown
REM curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/wbin/gvim_bats/gvim.bat --output %wbin_dir%gvim.bat
REM curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/wbin/gvim_bats/gvimdiff.bat --output %wbin_dir%gvimdiff.bat
REM curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/wbin/gvim_bats/vim.bat --output %wbin_dir%vim.bat
REM curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/wbin/gvim_bats/vimdiff.bat --output %wbin_dir%vimdiff.bat

reg add "HKEY_CURRENT_USER\SOFTWARE\Classes\*\Shell\Vim" /ve /t REG_SZ /d "Edit with &Vim" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Classes\*\Shell\Vim" /v "Icon" /t REG_SZ /d "%wbin_dir%gvim91p\vim\vim91\gvim.exe" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Classes\*\Shell\Vim\command" /ve /t REG_SZ /d "%wbin_dir%gvim91p\vim\vim91\gvim.exe \"%%1\"" /f
