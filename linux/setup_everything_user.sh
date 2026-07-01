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

# fonts
mkdir -p ~/.local/share/fonts/truetype
cp ../fonts/*.ttf ~/.local/share/fonts/truetype/


# apk add xdotool xwininfo xprop slop xinput
# apt install -y xdotool slop xinput wmctrl

