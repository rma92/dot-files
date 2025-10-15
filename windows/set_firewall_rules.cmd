@echo off
REM disable everything
REM Can export profile from wf.msc, click on Windows Firewall in list in top left, Action > Export Policy.  Can also restore.
REM Recommend reset everything using the below command, and configure everything using this script
REM netsh advfirewall reset

REM Sets outbound policy to block by default and allows Edge, PortableBrowsers, Connectify, Speedify and portable tools outbound
REM Set outbound policy to block by default on all profiles
netsh advfirewall set domainprofile firewallpolicy blockinbound,blockoutbound
netsh advfirewall set privateprofile firewallpolicy blockinbound,blockoutbound
netsh advfirewall set publicprofile firewallpolicy blockinbound,blockoutbound

powershell.exe -Command "Get-NetFirewallRule -Direction Inbound | Disable-NetFirewallRule"
powershell.exe -Command "Get-NetFirewallRule -Direction Outbound | Disable-NetFirewallRule"


REM Allow default rules we want.
REM netsh advfirewall firewall set rule group="@FirewallAPI.dll,-28502" new enable=yes
REM netsh advfirewall firewall set rule name="" new enable=yes
netsh advfirewall firewall add rule name="Git Curl" dir=out action=allow program="%SYSTEMROOT%\System32\curl.exe" enable=yes
netsh advfirewall firewall add rule name="Git Curl" dir=out action=allow program="%SYSTEMROOT%\SysWow64\curl.exe" enable=yes
netsh advfirewall firewall set rule name="Microsoft Edge" new enable=yes
netsh advfirewall firewall set rule name="Core Networking - DNS (UDP-Out)" new enable=yes
netsh advfirewall firewall set rule name="Core Networking - Dynamic Host Configuration Protocol (DHCP-Out)" new enable=yes
netsh advfirewall firewall set rule name="Core Networking - Dynamic Host Configuration Protocol for IPv6(DHCPV6-Out)" new enable=yes
netsh advfirewall firewall set rule name="File and Printer Sharing (Echo Request - ICMPv4-Out)" new enable=yes
netsh advfirewall firewall set rule name="File and Printer Sharing (Echo Request - ICMPv6-Out)" new enable=yes
netsh advfirewall firewall set rule name="Core Networking Diagnostics - ICMP Echo Request (ICMPv4-Out)" new enable=yes
netsh advfirewall firewall set rule name="Core Networking Diagnostics - ICMP Echo Request (ICMPv6-Out)" new enable=yes
netsh advfirewall firewall set rule name="Core Networking - IPv6 (IPv6-Out)" new enable=yes
netsh advfirewall firewall set rule name="Connected Devices Platform (TCP-Out)" new enable=yes
netsh advfirewall firewall set rule name="Connected Devices Platform (UDP-Out)" new enable=yes
netsh advfirewall firewall set rule name="Connected Devices Platform - Wi-Fi Direct Transport (TCP-Out)" new enable=yes
netsh advfirewall firewall set rule name="Captive Portal Flow" new enable=yes
netsh advfirewall firewall set rule name="Microsoft Store" new enable=yes
netsh advfirewall firewall set rule name="Mobile Plans" new enable=yes
netsh advfirewall firewall set rule name="Wireless Display (TCP-Out)" new enable=yes
netsh advfirewall firewall set rule name="Wireless Display (UDP-Out)" new enable=yes
netsh advfirewall firewall set rule name="Windows Feature Experience Pack" new enable=yes
netsh advfirewall firewall set rule name="Wi-Fi Direct Network Discovery (In)" new enable=yes
netsh advfirewall firewall set rule name="Wi-Fi Direct Scan Service Use (In)" new enable=yes
netsh advfirewall firewall set rule name="Wi-Fi Direct Spooler Use (In)" new enable=yes
netsh advfirewall firewall set rule name="Work or school account" new enable=yes
netsh advfirewall firewall set rule name="Your account" new enable=yes
netsh advfirewall firewall set rule name="Desktop App Web Viewer" new enable=yes
REM netsh advfirewall firewall set rule name="Connected User Experiences and Telemetry" new enable=yes

REM Allow Time Service and CryptSvc (for CRL checking)
netsh advfirewall firewall add rule name="Allow Windows Time (W32Time)" dir=out action=allow service=W32Time enable=yes profile=any
netsh advfirewall firewall add rule name="Allow CRL/OCSP - CryptSvc" dir=out action=allow service=CryptSvc enable=yes profile=any

REM Allow User Applications
REM netsh advfirewall firewall add rule name="Allow" dir=out action=allow program="" enable=yes
netsh advfirewall firewall add rule name="Allow MSTSC" dir=out action=allow program="%SYSTEMROOT%\system32\mstsc.exe" enable=yes
netsh advfirewall firewall add rule name="Allow nslookup" dir=out action=allow program="%SYSTEMROOT%\system32\nslookup.exe" enable=yes
netsh advfirewall firewall add rule name="Allow Filezilla" dir=out action=allow program="%SystemDrive%\local\FileZillaPortable\App\Filezilla64\Filezilla.exe" enable=yes
netsh advfirewall firewall add rule name="Allow Firefox" dir=out action=allow program="%SystemDrive%\local\FirefoxPortable\App\Firefox64\firefox.exe" enable=yes
netsh advfirewall firewall add rule name="Allow FirefoxNoProxy" dir=out action=allow program="%SystemDrive%\local\FirefoxPortable-Noproxy\App\Firefox64\firefox.exe" enable=yes
netsh advfirewall firewall add rule name="Allow Chrome" dir=out action=allow program="%SystemDrive%\local\GoogleChromePortable\App\Chrome-bin\chrome.exe" enable=yes
netsh advfirewall firewall add rule name="Allow MullvadBrowser" dir=out action=allow program="%SystemDrive%\local\MullvadBrowser2\Browser\mullvadbrowser.exe" enable=yes
netsh advfirewall firewall add rule name="Allow MullvadBrowserProxy" dir=out action=allow program="%SystemDrive%\local\MullvadBrowserProxy\Browser\mullvadbrowser.exe" enable=yes
netsh advfirewall firewall add rule name="Allow Citrix wfica" dir=out action=allow program="%SystemDrive%\local\ICA Client 10\wfica32.exe" enable=yes
netsh advfirewall firewall add rule name="Allow Citrix wfcrun" dir=out action=allow program="%SystemDrive%\local\ICA Client 10\wfcrun32.exe" enable=yes
netsh advfirewall firewall add rule name="Allow Softether VPN Manager" dir=out action=allow program="%PROGRAMFILES%\SoftEther VPN Server Manager\vpnsmgr_x64.exe" enable=yes
netsh advfirewall firewall add rule name="Allow PHP Server" dir=in action=allow program="%SystemDrive%\local\php843\php.exe" enable=yes
netsh advfirewall firewall add rule name="Allow Steam" dir=in action=allow program="%ProgramFiles(x86)%\Steam\Steam.exe" enable=yes
netsh advfirewall firewall add rule name="Allow Steam Webhelper" dir=in action=allow program="%ProgramFiles(x86)%\Steam\bin\cef\cef.win7x64\steamwebhelper.exe" enable=yes

REM Allow wbin
setlocal

REM Set the path variable
set "wbinpath=%SystemDrive%\local\git-sys\dot-files\windows\wbin"

REM List of executables
set "executables=rclone.exe RDCMan.exe Speedtest.exe tcping.exe wget.exe wget.x64.exe winscp.exe yt-dlp.exe putty.exe pscp.exe pterm.exe plink.exe pageant.exe kitty.exe kscp.exe ksftp.exe psftp.exe klink.exe"

REM Loop through each executable and add a firewall rule
for %%E in (%executables%) do (
    netsh advfirewall firewall add rule name="Allow %%E" dir=out action=allow program="%wbinpath%\%%E" enable=yes
)

REM allow speedify
set "speedifypath=%ProgramFiles(x86)%\Speedify"
set "executables=speedify.exe speedifyui.exe speedifylauncher.exe speedifycli.exe"
for %%E in (%executables%) do (
    netsh advfirewall firewall add rule name="Allow %%E" dir=out action=allow program="%speedifypath%\%%E" enable=yes
    netsh advfirewall firewall add rule name="Allow %%E" dir=in action=allow program="%speedifypath%\%%E" enable=yes
)
endlocal
REM Add outbound firewall for Git
netsh advfirewall firewall add rule name="Git.exe" dir=out action=allow program="%ProgramFiles%\Git\bin\git.exe" enable=yes
netsh advfirewall firewall add rule name="Git Remote HTTPS" dir=out action=allow program="%ProgramFiles%\Git\mingw64\libexec\git-core\git-remote-https.exe" enable=yes
netsh advfirewall firewall add rule name="Git Remote HTTP" dir=out action=allow program="%ProgramFiles%\Git\mingw64\libexec\git-core\git-remote-http.exe" enable=yes
netsh advfirewall firewall add rule name="Git Remote SSH" dir=out action=allow program="%ProgramFiles%\Git\mingw64\libexec\git-core\git-remote-ssh.exe" enable=yes
netsh advfirewall firewall add rule name="Git Remote FTP" dir=out action=allow program="%ProgramFiles%\Git\mingw64\libexec\git-core\git-remote-ftp.exe" enable=yes
netsh advfirewall firewall add rule name="Git Remote FTPS" dir=out action=allow program="%ProgramFiles%\Git\mingw64\libexec\git-core\git-remote-ftps.exe" enable=yes
netsh advfirewall firewall add rule name="Git Remote IMAP" dir=out action=allow program="%ProgramFiles%\Git\mingw64\libexec\git-core\git-imap-send.exe" enable=yes
netsh advfirewall firewall add rule name="Git Remote HTTP Push" dir=out action=allow program="%ProgramFiles%\Git\mingw64\libexec\git-core\git-http-push.exe" enable=yes
netsh advfirewall firewall add rule name="Git Remote HTTP Fetch" dir=out action=allow program="%ProgramFiles%\Git\mingw64\libexec\git-core\git-http-fetch.exe" enable=yes
netsh advfirewall firewall add rule name="Git Remote HTTP Backend" dir=out action=allow program="%ProgramFiles%\Git\mingw64\libexec\git-core\git-http-backend.exe" enable=yes
netsh advfirewall firewall add rule name="Git credential backend" dir=out action=allow program="%ProgramFiles%\Git\mingw64\libexec\git-core\git-credential-wincred.exe" enable=yes
netsh advfirewall firewall add rule name="Git.exe " dir=out action=allow program="%ProgramFiles%\Git\mingw64\libexec\git-core\git.exe" enable=yes
netsh advfirewall firewall add rule name="Git Curl" dir=out action=allow program="%ProgramFiles%\Git\mingw64\bin\curl.exe" enable=yes
netsh advfirewall firewall add rule name="Git SSH" dir=out action=allow program="%ProgramFiles%\Git\usr\bin\ssh.exe" enable=yes

REM browsers
netsh advfirewall firewall add rule name="Microsoft Edge Outbound" dir=out action=allow program="%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" enable=yes
netsh advfirewall firewall set rule name="Microsoft Edge Outbound" new enable=yes

REM Add outbound firewall rules for Connectify programs
netsh advfirewall firewall add rule name="Connectify.exe Outbound" dir=out action=allow program="%ProgramFiles(x86)%\Connectify\Connectify.exe" enable=yes
netsh advfirewall firewall add rule name="Connectifyd.exe Outbound" dir=out action=allow program="%ProgramFiles(x86)%\Connectify\Connectifyd.exe" enable=yes
netsh advfirewall firewall add rule name="ConnectifyNetServices.exe Outbound" dir=out action=allow program="%ProgramFiles(x86)%\Connectify\ConnectifyNetServices.exe" enable=yes
netsh advfirewall firewall add rule name="ConnectifyGopher.exe Outbound" dir=out action=allow program="%ProgramFiles(x86)%\Connectify\ConnectifyGopher.exe" enable=yes

REM Allow all outbound ICMPv4 traffic
netsh advfirewall firewall add rule name="Allow ICMPv4 Outbound" protocol=icmpv4:8,any dir=out action=allow enable=yes

REM allow 43389 port
netsh advfirewall firewall add rule name="Allow 43389 TCP" dir=in action=allow protocol=TCP localport=43389 profile=any enable=yes
netsh advfirewall firewall add rule name="Allow 43389 UDP" dir=in action=allow protocol=UDP localport=43389 profile=any enable=yes

REM Hyper-V
netsh advfirewall firewall add rule name="Allow Hyper-V VMMS Service Outbound" dir=out service=vmms action=allow enable=yes
netsh advfirewall firewall add rule name="Allow Hyper-V VMMS Service Inbound" dir=in service=vmms action=allow enable=yes

:: Allow Hyper-V Virtual Machine Management Service (vmms.exe)
netsh advfirewall firewall add rule name="Allow Hyper-V VMMS Outbound" `
    dir=out program="C:\Windows\System32\vmms.exe" action=allow enable=yes
netsh advfirewall firewall add rule name="Allow Hyper-V VMMS Inbound" `
    dir=in program="C:\Windows\System32\vmms.exe" action=allow enable=yes

:: Allow Hyper-V Networking Management Service (vmmgmt.exe)
netsh advfirewall firewall add rule name="Allow Hyper-V Networking Management Outbound" `
    dir=out program="C:\Windows\System32\vmmgmt.exe" action=allow enable=yes
netsh advfirewall firewall add rule name="Allow Hyper-V Networking Management Inbound" `
    dir=in program="C:\Windows\System32\vmmgmt.exe" action=allow enable=yes

:: Allow Hyper-V Host Compute Network Service (hns.exe)
netsh advfirewall firewall add rule name="Allow Hyper-V Host Compute Network Outbound" `
    dir=out program="C:\Windows\System32\hns.exe" action=allow enable=yes
netsh advfirewall firewall add rule name="Allow Hyper-V Host Compute Network Inbound" `
    dir=in program="C:\Windows\System32\hns.exe" action=allow enable=yes

:: Allow DHCP (UDP 67–68) for VM traffic
netsh advfirewall firewall add rule name="Allow DHCP for Hyper-V VMs Outbound" `
    dir=out protocol=UDP localport=67-68 action=allow enable=yes
netsh advfirewall firewall add rule name="Allow DHCP for Hyper-V VMs Inbound" `
    dir=in protocol=UDP localport=67-68 action=allow enable=yes

echo === Rules added successfully. Restarting Hyper-V services... ===

:: Restart Hyper-V networking services
net stop vmms >nul 2>&1
net start vmms >nul 2>&1
net stop hns >nul 2>&1
net start hns >nul 2>&1

echo Firewall rules configured successfully.
REM powershell.exe -Command "New-NetFirewallRule -DisplayName 'Allow All in wbin Folder' -Direction Outbound -Action Allow -Program '%SystemDrive%\local\git-sys\dot-files\windows\wbin\*' -Profile Any"
REM powershell.exe -Command "New-NetFirewallRule -DisplayName 'Allow Git Core Tools Folder' -Direction Outbound -Action Allow -Program '%ProgramFiles%\Git\mingw64\libexec\git-core\*' -Profile Any"

