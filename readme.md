# dot-files
(public rma92 dot-files repo)
Eventually, this will contain pretty much all of my user config.  It's incomplete now, but contains my most important things.

# Linux
The stuff here mostly goes in ~.  The .vimrc file should be the same as the `_vimrc` for Windows, and the .vim folder should be the same as the vimfiles folder for Windows.

To export this:
github-svn export https://github.com/rma92/dot-files/trunk/linux

# Windows
These generally belong in the user directory (C:\Users).

wbin belongs in the path.

tools contains various scripts.

reg contains registry files.

The .theme file contains the high contrast (Bloomberg Terminal) color scheme I use.

## Cloning using PowerShell
CD to user directory.  Then...
```powershell
$cmd = "svn export https://github.com/rma92/dot-files/trunk/windows"
iex $cmd
move windows\vimfiles .
move windows\_vimrc .
```

## Download and extract a zip without cloning
```
C:
mkdir \local
cd \local
curl -L https://codeload.github.com/rma92/dot-files/zip/refs/heads/master --output dot-files.zip
tar -xf dot-file.zip
cd dot-files-master\windows
call copy-vimfiles
powershell.exe -Command "[System.Environment]::SetEnvironmentVariable('PATH', \"$env:PATH;C:\local\dot-files-master\windows\wbin\", [System.EnvironmentVariableTarget]::User)"

reg import C:\local\dot-files-master\windows\reg\cmdhere.reg
reg import C:\local\dot-files-master\windows\reg\DisableNewAltTab.reg
reg import C:\local\dot-files-master\windows\reg\ExplorerUserSettings.reg
reg import C:\local\dot-files-master\windows\reg\PSHashifyFolder.reg
reg import C:\local\dot-files-master\windows\reg\MouseHoverTime100.reg
reg import C:\local\dot-files-master\windows\reg\Restore_Windows_Photo_Viewer_CURRENT_USER.reg
reg import C:\local\dot-files-master\windows\reg\AddTextMode92XToConsole-user.reg
powershell.exe -Command "Start-Process -FilePath 'cmd.exe' -ArgumentList '/c', 'copy C:\local\dot-files-master\windows\hosts\disable-edge-telemetry\hosts %SYSTEMROOT%\system32\drivers\etc\hosts /y' -Verb RunAs"


mkdir C:\local\setup
C:
cd \local\setup
curl -L https://7-zip.org/a/7z2301-x64.msi --output 7z2301-x64.msi
msiexec /i 7z2301-x64.msi /passive
curl -L https://ftp.nluug.nl/pub/vim/pc/gvim90.exe --output gvim90.exe
start gvim90.exe
start C:\local\dot-files-master\fonts
start C:\Windows\Fonts

C:
cd C:\local\dot-files-master\windows\wbin\
curl -L "https://the.earth.li/~sgtatham/putty/latest/w64/putty.exe" --output putty.exe
curl -L "https://the.earth.li/~sgtatham/putty/latest/w64/pscp.exe" --output pscp.exe

curl -L "https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe" --output plink.exe
curl -L "https://the.earth.li/~sgtatham/putty/latest/w64/pageant.exe" --output pageant.exe
curl -L "https://the.earth.li/~sgtatham/putty/latest/w64/puttygen.exe" --output puttygen.exe
curl -L "https://the.earth.li/~sgtatham/putty/latest/w64/pterm.exe" --output pterm.exe
```
This is useful for short-lived Windows installations.  This will create C:\local, download the file, extract the file (Windows 10 > 1703), and add the wbin folder to the user's path.

## Using symlinks for VIM into a git repository instead of copy
The following links should be created in %USERPROFILE% (open cmd).
```
mklink _vimrc \local\git\dot-files\windows\_vimrc
mklink /D vimfiles \local\git\dot-files\windows\vimfiles
```
## Installing just the _vimrc and vimfiles\colors\bbx.vim on Windows
The `_vimrc` file and the color file can be installed on any Windows by simply running the following commands.
```
curl https://raw.githubusercontent.com/rma92/dot-files/master/windows/_vimrc --output %USERPROFILE%\_vimrc
curl https://raw.githubusercontent.com/rma92/dot-files/master/windows/vimfiles/colors/bbx.vim --output %USERPROFILE%\vimfiles\colors\bbx.vim
```

## Additional Considerations
### Microsoft Edge / Google Chrome
* Enable `edge://flags/#enable-force-dark` or `chrome://flags/#enable-force-dark`.
* Normal extension set: uBlock Origin, VideoDownloadHelper
* uBlock Origin Settings:
  * Enable annoyances filter lists.

I used InTune to set the following.  These can be configured through AD or manually if the machine will not be joined to MDM.
* Install the above extensions
  * The setting is called "Control which extensions are installed silently
  * odfafepnkmbhccpbejgmiehpchacaeak
  * jmkaglaafmhbcpleggkmaliipiilhldn
* Enable full-tab promotional content: Disabled
* Show Hubs Sidebar: Disabled
* Allow quick links on the new tab page: Disabled
* Allow Microsoft News content on the new tab page: Disbaled
* Set Home Pages: about:blank
* Set New Tab Page URL: about:blank
* Configure Do Not Track: Enabled
  * There are two versions of this setting, device and user.  I set both because I often use a local account.

### Other Windows InTune / Group Policy settings
* Allow Windows Spotlight (User): Block

#### Windows Services
* Disabled
  * AllJoyn Router Service
  * Connected User Experiences and Telemetry
  * Diagnostic Execution Service
  * Diagnostic Policy Service
  * Diagnostic Service Host
  * Diagnostic System Host
  * Downloaded Maps Manager
  * Microsoft App-V Client
  * Microsoft Defender Antivirus Service
    * Either disable the service in base image for setup, or disable it using the group policy setting
    * Computer Configuration > Administrative Templates > Windows Components > Microsoft Defender Antivirus. Double-click the "Turn off Microsoft Defender Antivirus"
  * Microsoft Keyboard Filter
  * Net.Tcp Port Sharing Service
  * OpenSSH Authentication Agent
  * Remote Registry
  * Routing and Remote Access
  * Shared PC Account Manager
  * SSDP Discovery
  * SysMain
    * Enable this if there is a hard drive after initial setup.
  * UPnP Device Host
  * User Experience Virtualization Service
  * Windows Update
    * Enable it after setup, or when it's time for patching.
  * Xbox Accessory Management Service
  * Xbox Live Auth Manager
  * Xbox Live Game Save
  * Xbox Live Networking Service
  * WinHTTP Web Proxy Auto-Discovery Service
    * Disabling this removes risk of proxy spoofing.
    * It cannot be disabled by GUI - Set start to 4 in regedit -- `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WinHttpAutoProxySvc`
<!--
# Fonts
This contains various fonts.  They go in the .font folder on Linux
## Cloning using PowerShell
```powershell
$cmd = "svn export https://github.com/rma92/dot-files/trunk/fonts"
iex $cmd
```
-->
