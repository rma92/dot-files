REM REG IMPORT AddTakeownToContextMenu.reg
REG IMPORT AddTextMode92XToConsole-user.reg
REG IMPORT AeroShake-Disable.reg
REG IMPORT cmdhere.reg
REG IMPORT cmdhere_admin.reg
REG IMPORT "Disable Bing Searches.reg"
REG IMPORT "ExplorerUserSettings.reg"
REG IMPORT "marino-cmd-powershell-console-TextMode92Xfont.reg"
REG IMPORT MouseHoverTime100.reg
REG IMPORT PSHashifyFolder.reg
REG IMPORT PuttyDefaultSettings-TextMode92X-small.reg
REG IMPORT "Windows 11 Old Context Menu.reg"
ECHO Press any key to restart explorer (note all explorer.exe)
pause
taskkill -f -im explorer.exe -fi "USERNAME eq %USERNAME%" && start explorer

ECHO if using Windows 10, press any key to disable new alt tab UI.
pause
REM do not use on Windows 11, there will be no Alt-Tab UI.
REG IMPORT "DisableNewAltTab.reg"
