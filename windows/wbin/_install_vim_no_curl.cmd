if not defined CURL_PROXY_OPTS set CURL_PROXY_OPTS=
%~d0
cd %~dp0
set wbin_dir=%~dp0
..\downloader\dump_winjs.cmd
cmd /c %wbin_dir%js "https://github.com/vim/vim-win32-installer/releases/download/v9.1.0/gvim_9.1.0_x64_signed.zip" -saveTo %wbin_dir%gvim_9.1.0_x64_signed.zip
REM curl %CURL_PROXY_OPTS% -L "https://github.com/vim/vim-win32-installer/releases/download/v9.1.0/gvim_9.1.0_x64_signed.zip" --output gvim_9.1.0_x64_signed.zip
REM powershell -command "Expand-Archive -Force gvim_9.1.0_x64_signed.zip gvim91p"
expand %wbin_dir%unzip.ex_ %wbin_dir%unzip.exe
unzip -qq -o %wbin_dir%gvim_9.1.0_x64_signed.zip -d %wbin_dir%gvim91p

SETX VIM %wbin_dir%gvim91p\vim
SETX VIMRUNTIME %wbin_dir%gvim91p\vim\vim91
cmd /c %wbin_dir%js https://raw.githubusercontent.com/rma92/dot-files/main/windows/_vimrc -saveTo %wbin_dir%gvim91p\vim\vimrc
cmd /c %wbin_dir%js https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/colors/bbx.vim -saveTo %wbin_dir%gvim91p\vim\vim91\colors\bbx.vim
cmd /c %wbin_dir%js https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/syntax/ps1.vim -saveTo %wbin_dir%gvim91p\vim\vim91\syntax\ps1.vim
cmd /c %wbin_dir%js https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/indent/ps1.vim -saveTo %wbin_dir%gvim91p\vim\vim91\indent\ps1.vim
cmd /c %wbin_dir%js https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/ftplugin/ps1.vim -saveTo %wbin_dir%gvim91p\vim\vim91\ftplugin\ps1.vim
cmd /c %wbin_dir%js https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/doc/ps1.txt -saveTo %wbin_dir%gvim91p\vim\vim91\doc\ps1.txt
cmd /c %wbin_dir%js https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/README_ps1.markdown -saveTo %wbin_dir%gvim91p\vim\vim91\doc\README_ps1.markdown
cmd /c %wbin_dir%js https://raw.githubusercontent.com/rma92/dot-files/main/windows/wbin/gvim_bats/gvim.bat -saveTo %wbin_dir%gvim.bat
cmd /c %wbin_dir%js https://raw.githubusercontent.com/rma92/dot-files/main/windows/wbin/gvim_bats/gvimdiff.bat -saveTo %wbin_dir%gvimdiff.bat
cmd /c %wbin_dir%js https://raw.githubusercontent.com/rma92/dot-files/main/windows/wbin/gvim_bats/vim.bat -saveTo %wbin_dir%vim.bat
cmd /c %wbin_dir%js https://raw.githubusercontent.com/rma92/dot-files/main/windows/wbin/gvim_bats/vimdiff.bat -saveTo %wbin_dir%vimdiff.bat

reg add "HKEY_CURRENT_USER\SOFTWARE\Classes\*\Shell\Vim" /ve /t REG_SZ /d "Edit with &Vim" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Classes\*\Shell\Vim" /v "Icon" /t REG_SZ /d "%wbin_dir%gvim91p\vim\vim91\gvim.exe" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Classes\*\Shell\Vim\command" /ve /t REG_SZ /d "%wbin_dir%gvim91p\vim\vim91\gvim.exe \"%%1\"" /f
