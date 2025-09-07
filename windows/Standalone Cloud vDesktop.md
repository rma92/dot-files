# Set up remote desktop server with minimal footprint on VPS (Win10 LTSC 2021)
Since the VPS uses ethernet, we can disable the network services.

Change the port of RDP, and remember to unblock it in the firewall after running the firewall script.
Activate Windows if it hasn't been set up already (just to minimize hassle)
Open admin cmd and Run the following in the root of the windows directory in dot-files

```
netsh advfirewall reset
set_browser_gpo.cmd
powershell -NoProfile -ExecutionPolicy Bypass -File install_fonts.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File install_firewall_context_menu.ps1
set_firewall_rules.cmd
reg import disable_annoyance.reg
services\mk_blackviper.cmd
services\mk_disable_network_ui_svc.cmd
services\mk_extrem_anti_ltsc2021.cmd
services\disable_wu_services.cmd
services\disable_net_share_services.cmd
REM if DHCP is needed, skip for static IP:
sc config nsi start= demand
sc config dhcp start= demand
sc start dhcp

tools\purge_sounds.cmd
powershell.exe -ExecutionPolicy Bypass -File "tools\set_cursor_black_extra_large.ps1"

netsh advfirewall firewall add rule name="Allow TCP 43389" dir=in action=allow protocol=TCP localport=43389
netsh advfirewall firewall add rule name="Allow UDP 43389" dir=in action=allow protocol=UDP localport=43389
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber /t REG_DWORD /d 43389 /f
netsh advfirewall firewall add rule name="Allow Curl" dir=out action=allow program="C:\Windows\System32\curl.exe" enable=yes
```
Also probably should run:
```
reg\_setup_noadmin_w10.cmd
reg\_setup_admin.cmd
reg\Disable Visual Effects.cmd
```
If very memory constrained, disable start menu search app:
```
taskkill -f -im explorer.exe
ren Microsoft.Windows.Search_cw5n1h2txyewy Microsoft.Windows.Search_cw5n1h2txyewy_dud
start explorer.exe
```
