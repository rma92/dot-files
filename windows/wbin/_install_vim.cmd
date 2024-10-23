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
curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/_vimrc --output %wbin_dir%gvim91p\vim\vimrc
curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/colors/bbx.vim --output %wbin_dir%gvim91p\vim\vim91\colors\bbx.vim
curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/syntax/ps1.vim --output %wbin_dir%gvim91p\vim\vim91\syntax\ps1.vim
curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/indent/ps1.vim --output %wbin_dir%gvim91p\vim\vim91\indent\ps1.vim
curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/ftplugin/ps1.vim --output %wbin_dir%gvim91p\vim\vim91\ftplugin\ps1.vim
curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/doc/ps1.txt --output %wbin_dir%gvim91p\vim\vim91\doc\ps1.txt
curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/README_ps1.markdown --output %wbin_dir%gvim91p\vim\vim91\doc\README_ps1.markdown
curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/wbin/gvim_bats/gvim.bat --output %wbin_dir%gvim.bat
curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/wbin/gvim_bats/gvimdiff.bat --output %wbin_dir%gvimdiff.bat
curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/wbin/gvim_bats/vim.bat --output %wbin_dir%vim.bat
curl %CURL_PROXY_OPTS% https://raw.githubusercontent.com/rma92/dot-files/main/windows/wbin/gvim_bats/vimdiff.bat --output %wbin_dir%vimdiff.bat

reg add "HKEY_CURRENT_USER\SOFTWARE\Classes\*\Shell\Vim" /ve /t REG_SZ /d "Edit with &Vim" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Classes\*\Shell\Vim" /v "Icon" /t REG_SZ /d "%wbin_dir%gvim91p\vim\vim91\gvim.exe" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Classes\*\Shell\Vim\command" /ve /t REG_SZ /d "%wbin_dir%gvim91p\vim\vim91\gvim.exe \"%%1\"" /f
