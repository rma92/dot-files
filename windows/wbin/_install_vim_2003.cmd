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
@cmd /c js "https://raw.githubusercontent.com/rma92/dot-files/main/windows/_vimrc" -saveTo %CD%\gvim90p\vim\vimrc -ignoreCertError yes -force yes
@cmd /c js "https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/colors/bbx.vim" -saveTo %CD%\gvim90p\vim\vim90\colors\bbx.vim -ignoreCertError yes -force yes
@cmd /c js "https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/syntax/ps1.vim" -saveTo %CD%\gvim90p\vim\vim90\syntax\ps1.vim -ignoreCertError yes -force yes
@cmd /c js "https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/indent/ps1.vim" -saveTo %CD%\gvim90p\vim\vim90\indent\ps1.vim -ignoreCertError yes -force yes
@cmd /c js "https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/ftplugin/ps1.vim" -saveTo %CD%\gvim90p\vim\vim90\ftplugin\ps1.vim -ignoreCertError yes -force yes
@cmd /c js "https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/doc/ps1.txt" -saveTo %CD%\gvim90p\vim\vim90\doc\ps1.txt -ignoreCertError yes -force yes
@cmd /c js "https://raw.githubusercontent.com/rma92/dot-files/main/windows/vimfiles/README_ps1.markdown" -saveTo %CD%\gvim90p\vim\vim90\doc\README_ps1.markdown -ignoreCertError yes -force yes
@cmd /c js "https://raw.githubusercontent.com/rma92/dot-files/main/windows/wbin/gvim_bats/gvim.bat" -saveTo %CD%\gvim.bat -ignoreCertError yes -force yes
@cmd /c js "https://raw.githubusercontent.com/rma92/dot-files/main/windows/wbin/gvim_bats/gvimdiff.bat" -saveTo %CD%\gvimdiff.bat -ignoreCertError yes -force yes
@cmd /c js "https://raw.githubusercontent.com/rma92/dot-files/main/windows/wbin/gvim_bats/vim.bat" -saveTo %CD%\vim.bat -ignoreCertError yes -force yes
@cmd /c js "https://raw.githubusercontent.com/rma92/dot-files/main/windows/wbin/gvim_bats/vimdiff.bat" -saveTo %CD%\vimdiff.bat -ignoreCertError yes -force yes

reg add "HKEY_CURRENT_USER\SOFTWARE\Classes\*\Shell\Vim" /ve /t REG_SZ /d "Edit with &Vim" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Classes\*\Shell\Vim" /v "Icon" /t REG_SZ /d "%~dp0gvim90p\vim\vim90\gvim.exe" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Classes\*\Shell\Vim\command" /ve /t REG_SZ /d "%~dp0gvim90p\vim\vim90\gvim.exe \"^%%1\"" /f
