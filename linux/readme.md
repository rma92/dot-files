# Linux Config
Contains themes, and config files, and window management tools.

# Set up everything (user)
```
mkdir -p ~/.bin
echo 'export PATH="$HOME/.bin:$PATH"' >> "$HOME/.profile"
cp -r .vim ~/
cp .vimrc ~/
mkdir -p ~/.local/share/fonts/truetype
cp ../fonts/*.ttf ~/.local/share/fonts/truetype/
cp bin_user/deskgrid ~/.bin
cp bin_user/deskgrid-invoke ~/.bin
chmod +x ~/.bin/deskgrid-invoke
chmod +x ~/.bin/deskgrid

mkdir -p /tmp/Chicago95/
unzip -q theme-zip/Chicago95_v3.0.1.zip -d /tmp/Chicago95/
ls /tmp/Chicago95/Chicago95-3.0.1/
mkdir -p ~/.themes
mkdir -p ~/.icons
cp -r /tmp/Chicago95/Chicago95-3.0.1/Theme/Chicago95 ~/.themes/
cp -r /tmp/Chicago95/Chicago95-3.0.1/Icons/* ~/.icons/

mkdir -p ~/.config/autostart
cat > ~/.config/autostart/deskgrid-invoke.desktop << EOF
[Desktop Entry]
Type=Application
Exec="$HOME/.bin/deskgrid-invoke"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Terminal=false
Name=Deskgrid Invoke
Comment=Run deskgrid-invoke on login
EOF

# apk add xdotool xwininfo xprop slop xinput
# apt install -y xdotool slop xinput wmctrl

```
# Fonts
(All users/root) Run in this directory (`linux`) in the dot-files repo:
```
cp ../fonts/*.ttf /usr/share/fonts/truetype/
```
(Current user)
```
mkdir -p ~/.local/share/fonts/truetype
cp ../fonts/*.ttf ~/.local/share/fonts/truetype/
```
# Vim
Run in this directory (`linux`) in the dot-files repo:
```
cp -r .vim ~/
cp .vimrc ~/
```
# Fix hissing noise on Devuan and Arch on some laptops
```
sudo apt update
sudo apt install alsa-tools
sudo hda-verb /dev/snd/hwC0D0 0x1d SET_PIN_WIDGET_CONTROL 0x0
```
# Deskgrid
This is deskgrid from Mabox-Linux.
Dependencies: xdotool, xwininfo, xprop, slop, xinput, wmctrl
Optional dependencies: imagemagick (only for drawing the grid)

Note that this does not work with KWin or Gnome, but works well with Openbox and xfwm.

Settings in Xfce4 that should be configured:
* Window Manager Tweaks > Accessibility > "Automatically tile windows when moving toward the screen edge"
* Window Manager > Advanced > Window snapping: select none
* Window Manager > Advanced > Wrap Workspaces when reaching the screen edge: select none

May want to set:
* Window Manager > Focus > Focus follows mouse

Bugs:
* on Xfce, the title bar and window borders are not accounted for when tiling the windows into the grid (they overlap for the areas outside the client area)

Copy to `/usr/bin` (as root):
```
# Devuan 6, Debian 13, Ubuntu 24.04
# doas apt install xdotool slop xinput wmctrl
# Alpine - compile wmctrl if architecture is not AMD64
# apk add xdotool xwininfo xprop slop xinput
# cp bin_alpine64/wmctrl /usr/bin
# cd bin
cp deskgrid /usr/bin
cp deskgrid-invoke /usr/bin
cp drawgrid /usr/bin
cp superclick /usr/bin
chmod +x /usr/bin/deskgrid
chmod +x /usr/bin/deskgrid-invoke
chmod +x /usr/bin/drawgrid
chmod +x /usr/bin/superclick
```
Add to current user autostart:
```
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/deskgrid-invoke.desktop << 'EOF'
[Desktop Entry]
Type=Application
Exec=/usr/bin/deskgrid-invoke
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Terminal=false
Name=Deskgrid Invoke
Comment=Run deskgrid-invoke on login
EOF
```
## Alpine setup (tar.gz amd64)
extract drawgrid_bin_alpine64.tar.gz to /usr/bin.
Make deskgrid-invoke autostart:
```
apk add xdotool xwininfo xprop slop xinput

mkdir -p /home/user/.config/autostart
cat > /home/user/.config/autostart/deskgrid-invoke.desktop << 'EOF'
[Desktop Entry]
Type=Application
Exec=/usr/bin/deskgrid-invoke
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Terminal=false
Name=Deskgrid Invoke
Comment=Run deskgrid-invoke on login
EOF
```
## Alpine Setup (manual)
wmctrl is not packaged on alpine.  A copy of source is in wmctrl64.zip in this directory.
```
apk add xdotool xwininfo xprop slop xinput
# apk add wmctrl
cp bin/* /usr/bin
cp bin_alpine64/wmctrl /usr/bin
chmod +x /usr/bin/deskgrid
chmod +x /usr/bin/drawgrid
chmod +x /usr/bin/deskgrid-invoke
chmod +x /usr/bin/superclick
```
To invoke it after logging in to a desktop session, run /usr/bin/drawgrid-invoke.  This runs in the background and monitors input through xinput.

You can left+right click the windows now and drag to resize them to the grid.

A config file should be created at ~/.config/superclick.cfg

### Building wmctrl on alpine
```
apk add --no-cache build-base git autoconf automake libtool pkgconf
apk add --no-cache libx11-dev libxmu-dev glib-dev

cd /tmp
git clone https://github.com/dancor/wmctrl.git
./configure
make
cp wmctrl /usr/bin/
# make install
```

# Configuring Firefox - Ublock Origin systemwide, no smooth scroll by default
Do this as root, tested on Alpine.  The lbu steps are only used if Alpine is booted in diskless mode, they can be skipped otherwise.
```
mkdir -p /usr/lib/firefox/distribution
wget -O /usr/lib/firefox/ublock_origin.xpi https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/addon-607454-latest.xpi
cat << 'EOF' > /usr/lib/firefox/distribution/policies.json
{
  "policies": {
    "Extensions": {
      "Install": ["file:///usr/lib/firefox/ublock_origin.xpi"]
    }
  }
}

mkdir -p /usr/lib/firefox
printf '%s\n' 'defaultPref("general.smoothScroll", false);' >> /usr/lib/firefox/mozilla.cfg
printf '%s\n%s\n' 'pref("general.config.filename", "mozilla.cfg");' 'pref("general.config.obscure_value", 0);' >> /usr/lib/firefox/defaults/pref/local-settings.js

EOF
lbu add /usr/lib/firefox/distribution/policies.json
lbu add /usr/lib/firefox/ublock_origin.xpi
lbu add /usr/lib/firefox/mozilla.cfg
lbu add /usr/lib/firefox/defaults/pref/local-settings.js
```

# Make xfce4-terminal not warn on paste (current user)
```
cfg="${XDG_CONFIG_HOME:-$HOME/.config}/xfce4/terminal/terminalrc"; mkdir -p "$(dirname "$cfg")"; if grep -q '^MiscConfirmPaste=' "$cfg" 2>/dev/null; then sed -i 's/^MiscConfirmPaste=.*/MiscConfirmPaste=false/' "$cfg"; else echo 'MiscConfirmPaste=false' >> "$cfg"; fi
```

# Install Chicago95 systemwide, disable xfwm compositor
This is useful for remote desktops.

Manually download Chicago95 and install it:
```
cd /tmp
wget https://github.com/grassmunk/Chicago95/archive/refs/tags/v3.0.1.zip
unzip -q v3.0.1.zip
cp -r /tmp/Chicago95-3.0.1/Theme/Chicago95 /usr/share/themes/
cp -r /tmp/Chicago95-3.0.1/Icons/* /usr/share/icons/
```

Use Chicago95 from this repository:
```
cp -r .themes/Chicago95 /usr/share/themes/
cp -r .icons/Chicago95 /usr/share/icons/
cp -r .icons/Chicago95-tux /usr/share/icons/
```

Set up xfce4 and gtk themes and settings:
```
mkdir -p /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/
cat << 'EOF' > /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="theme" type="string" value="Chicago95"/>  
    <property name="use_compositing" type="bool" value="false"/>
    <property name="tile_on_move" type="bool" value="true"/>
    <property name="snap_to_border" type="bool" value="false"/>
    <property name="snap_to_windows" type="bool" value="false"/>
    <property name="wrap_windows" type="bool" value="false"/>
    <property name="click_to_focus" type="bool" value="false"/>
  </property>
</channel>
EOF

cat << 'EOF' > /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="Chicago95"/>
    <property name="IconThemeName" type="string" value="Chicago95"/>
  </property>
  <property name="Xft" type="empty">
    <property name="DPI" type="int" value="96"/>
  </property>
</channel>
EOF

cat << 'EOF' > /etc/xdg/autostart/disable-compositing.desktop
[Desktop Entry]
Type=Application
Name=Disable Compositing
Exec=xfconf-query -c xfwm4 -p /general/use_compositing -s false
OnlyShowIn=XFCE;
X-GNOME-Autostart-enabled=true
EOF

cat << 'EOF' > /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="monitor0" type="empty">
        <property name="image-path" type="string" value=""/>
        <property name="image-show" type="bool" value="false"/>
        <property name="color-style" type="int" value="0"/>
        <property name="color1" type="string" value="#3A6EA5"/>
        <property name="color2" type="string" value="#3A6EA5"/>
      </property>
      <property name="monitorrdp0" type="empty">
        <property name="workspace0" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="rgba1" type="array">
            <value type="double" value="0"/>
            <value type="double" value="0"/>
            <value type="double" value="0"/>
            <value type="double" value="1"/>
          </property>
          <property name="image-style" type="int" value="0"/>
        </property>
      </property>
    </property>
  </property>
</channel>
EOF

mkdir -p /cfg/home/user/.config/xfce4/xfconf/xfce-perchannel-xml
cat << 'EOF' > /cfg/home/user/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
<?xml version="1.1" encoding="UTF-8"?>

<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="monitor0" type="empty">
        <property name="image-path" type="empty"/>
        <property name="image-show" type="empty"/>
        <property name="color-style" type="empty"/>
        <property name="color1" type="empty"/>
        <property name="color2" type="empty"/>
      </property>
      <property name="monitorrdp0" type="empty">
        <property name="workspace0" type="empty">
          <property name="image-style" type="int" value="0"/>
          <property name="rgba1" type="array">
            <value type="double" value="0"/>
            <value type="double" value="0"/>
            <value type="double" value="0"/>
            <value type="double" value="1"/>
          </property>
        </property>
      </property>
    </property>
  </property>
  <property name="last-settings-migration-version" type="uint" value="1"/>
  <property name="last" type="empty">
    <property name="window-width" type="int" value="684"/>
    <property name="window-height" type="int" value="486"/>
  </property>
</channel>
EOF


cat << 'EOF' > /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-panel" version="1.0">
  <property name="panels" type="array">
    <value type="int" value="1"/>
  </property>

  <!-- Main bottom panel -->
  <property name="panels" type="empty">
    <property name="panel-1" type="empty">
      <property name="position" type="string" value="p=8;x=0;y=0"/> <!-- bottom center -->
      <property name="size" type="uint" value="32"/>
      <property name="length" type="uint" value="100"/>
      <property name="autohide" type="bool" value="false"/>
      <property name="plugin-ids" type="array">
        <value type="int" value="1"/>
        <value type="int" value="2"/>
        <value type="int" value="3"/>
        <value type="int" value="4"/>
      </property>
    </property>
  </property>

  <!-- Plugin definitions -->
  <property name="plugins" type="empty">

    <!-- “Start” button (Application Menu) -->
    <property name="plugin-1" type="empty">
      <property name="plugin-name" type="string" value="applicationsmenu"/>
      <property name="button-title" type="string" value="Start"/>
      <property name="show-button-title" type="bool" value="true"/>
      <property name="button-icon" type="string" value="distributor-logo"/>
    </property>

    <!-- Task list -->
    <property name="plugin-2" type="empty">
      <property name="plugin-name" type="string" value="tasklist"/>
    </property>

    <!-- Separator -->
    <property name="plugin-3" type="empty">
      <property name="plugin-name" type="string" value="separator"/>
      <property name="expand" type="bool" value="true"/>
    </property>

    <!-- System tray / clock area -->
    <property name="plugin-4" type="empty">
      <property name="plugin-name" type="string" value="systray"/>
    </property>

  </property>
</channel>
EOF

mkdir -p /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/
cp /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/
cp /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/
cp /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/
cp /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/
cp /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/
cp /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/* /home/user/.config/xfce4/xfconf/xfce-perchannel-xml/
```
Apply Chicago95 to existing users:
```
xfconf-query -c xsettings -p /Net/ThemeName -s "Chicago95"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Chicago95"
xfconf-query -c xfwm4 -p /general/theme -s "Chicago95"
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-show -s false
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s ""
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/color-style -s 0
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/color1 -s "#3A6EA5"
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/color2 -s "#3A6EA5"
```

# Alpine Desktop Setup
## LxQt on Xrdp
```
#enable community repo by editing /etc/apk/repositories
apk update
apk add xorg-server xinit xterm dbus dbus-x11 xrdp xorgxrdp font-terminus font-dejavu xfce4 xfce4-terminal
rc-update add dbus default
rc-service dbus start
rc-update add xrdp default
rc-update add xrdp-sesman default
rc-service xrdp-sesman start
rc-service xrdp start
apk add obconf-qt pavucontrol-qt adwaita-qt oxygen 
```
as normal user:
```
echo "exec dbus-launch --exit-with-session startlxqt" >> ~/.xinitrc
```
## OpenBox on LxQt
```
#enable community repo by editing /etc/apk/repositories
apk update
apk add xorg-server openbox xinit xterm dbus dbus-x11 xrdp xorgxrdp font-terminus
rc-update add dbus default
rc-service dbus start
rc-update add xrdp default
rc-update add xrdp-sesman default
rc-service xrdp-sesman start
rc-service xrdp start
```
It tries to run the user's xinitrc.
As the normal user
```
mkdir -p ~/.config
cp -r /etc/xdg/openbox ~/.config
echo "exec dbus-launch --exit-with-session openbox-session" >> ~/.xinitrc
```
It tries to run /etc/X11/xinit/xinitrc if it's present.  That tries to run ~/.xinitrc.  Then it tries /etc/X11/xinit/xinitrc.d/?*

## XFCE on LxQt
```
#enable community repo by editing /etc/apk/repositories
apk update
apk add xorg-server xinit xterm dbus dbus-x11 xrdp xorgxrdp font-terminus font-dejavu xfce4 xfce4-terminal
rc-update add dbus default
rc-service dbus start
rc-update add xrdp default
rc-update add xrdp-sesman default
rc-service xrdp-sesman start
rc-service xrdp start
```
(No further config is required as Xfce4 sets itself up correctly)

# Add a Console / Local Desktop
### With only startx
Add xorg-server and set up your user to be in appropriate groups.
```
apk add xorg-server xinit xterm
sudo adduser $USER video
sudo adduser $USER input
sudo adduser $USER tty
```
Now you can run startx.
### With graphical logon
```
apk add elogind lightdm lightdm-gtk-greeter polkit-elogind gvfs mesa-dri-gallium udev dbus-glib xf86-input-libinput 
# xfce4-screensaver

rc-update add dbus
rc-service dbus start

rc-update add elogind boot
rc-service elogind start

rc-update add lightdm default
rc-service lightdm start

rc-update add udev default
rc-service udev start

setup-devd udev
```

## Default Set up xfce
As done by setup-desktop:
```
setup-xorg-base xfce4 elogind ${BROWSER:-firefox} gvfs lightdm lightdm-gtk-greeter polkit-elogind xfce4-terminal font-dejavu
```
## Default Setup lxqt
As done by setup-desktop, but switched to use lightdm instead of sddm:
```
setup-xorg-base lxqt-desktop lximage-qt obconf-qt pavucontrol-qt openbox arandr adwaita-qt oxygen elogind ${BROWSER:-firefox} gvfs lightdm lightdm-gtk-greeter polkit-elogind font-dejavu
```
Note: if you want to use this with xrdp, you need to create an xinitrc for the user:
```
echo "exec dbus-launch --exit-with-session startlxqt" >> ~/.xinitrc
```
Lightdm can cause less headaches when working with xrdp.

# Zero empty space on a drive
This is useful before snapshotting or compacting a VM disk:
```
dd if=/dev/zero of=/EMPTY bs=1M
rm /EMPTY
```

# Enlarge a running tmpfs 
Alpine Linux:
```
mount -o remount,size=48M /home
```

# KDE Setup
KDE Setup
* Window Management > Window Behavior
  * Window activation policy: Focus follows mouse
  * Delay focus by: 50 ms
* Window Management > Desktop Effects
  * Accessibility: Disable Zoom
  * Appearance - Disable:
    * Background Contrast
    * Blur
    * Fading Popups
    * Login
    * Logout
    * Maximize
    * Sliding Popups
    * Squash
  * Focus - Disable
    * Dialog Parent
  * Peek at Desktop Animation - Disable
    * Window Aperature
  * Virtual Desktop Switching Animation - Disable
    * Slide
  * Window Management - Disable
    * Overview
  * Window Open/Close Animation - Disable
    * Scale
* Global Theme 
  * Window Decorations > Plastik
    * look for another theme?
  * Application Style
    * MS Windows 9x
  * Colors
    * Breeze Dark
* Display & Montior
  * Compositor - Disable
    * Enable on startup
    * Keep applications to block compositing

Taskbar panel
* Right-click the taskbar panel, Add or Manage widgets
* Add a Text and Icons Task Manager
* Remove the Icons-only Task Manager
* Set panel height to 20px

[https://www.reddit.com/r/kdeneon/comments/1b3403r/quick_guide_to_kwin_tiling/]

