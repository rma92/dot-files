# MacOS Setup
* Set up Mac with a local account, add iCloud after, or create if at a new workplace.  (The work iCloud account can be added to a Family Share with your personal account to access paid for apps, content and subscriptions.)

# Git settings (clone this repository)
* open Terminal.
* run `git` to install xcode cli
* make sure github cli tool is installed using brew.
```
cd ~
mkdir -s $HOME/git-sys
cd $HOME/git-sys
git clone https://github.com/rma92/dot-files
ln -s $HOME/git-sys/dot-files/linux/.vimrc $HOME/.vimrc
ln -s $HOME/git-sys/dot-files/linux/.vim $HOME/.vim
```
* `gh auth login` (note only one account can be signed in at once)
* TODO: Since the macOS config files are plists, perhaps they can be turned into code that can be pasted into Terminal to simplify setting this up.

## System Preferences
* Keyboard
  * Adjust keyboard brightness in low light: off
  * Press World Key to: Change input source
  * Key Repeat: Fast
  * Delay until repeat: 1 from the shortest.
  * Input sources (Edit):
    * Show input menu in menu bar: on
    * For each language:
      * Correct spelling automatically: off
      * Capitalize words automatically: off
      * Show inline predictive text: off
      * Add period with double-space: off
      * Use smart quotes and dashes: off
    * Add languages:
      * US International - PC (under English)
* Mouse: natural scrolling: off
* Trackpad: Tracking Speed, second from highest.
* Trackpad: Tap to click: on
* Trackpad: Scroll & Zoom: Natural Scrolling: off
* Control Center:
  * Sound - Always Show in Menu Bar
  * Bluetooth - Show in Menu Bar
  * Wi-Fi - Show in Menu Bar
  * Clock Options
    * Display the time with seconds
    * Show the date: Always
    * Show AM/PM off
  * Battery: 
    * Show in Menu Bar: On
    * Show Percentage: On
* Date & Time
  * 24-hour time: on
  * Show 24-hour time on the Lock Screen: on
* Displays
  * More Space (old 96 dpi default)
  * Brightness: turn off Automatic adjust brightness and true tone.
  * Advanced > Show Resolutions as list
  * Show all resolutions
* Desktop & Dock
  * Animate opening applications: off
  * Show suggested and recent apps in Dock: off
  * Show Widgets: In Stage Manager (not desktop)
  * Drag Windows to left or right edge of screen to tile: off
  * Drag windows to menu bar to fill screen: off
  * Desktop & Stage Manager > Click the wallpaper to show desktop: "Only in Stage Manager"
  * "Automatically hide and show the menu bar": Never
* Appearance
  * Sidebar icons size: small
* Accessibility
  * Display
    * Reduce motion: on
    * Increase Contrast: on
    * Turn on increased contrast borders.
  * Keyboard
    * TODO: Fix it so the space bar works in poorly written applications - currently it's set to activate, but this makes it impossible to search in some apps. Full Keyboard Access On
* Sound
  * Alert Volume: None
  * Play sound on startup: off
  * Play user interface sound effects: off
* Notifications
  * Show previews: Never

Control Center - Click the clock:
* Delete News and Stocks, What's New.
* Click clock, set it to UTC, Eastern, Pacific, Singapore
Settings in Terminal:
* Make function keys behave as F1-F12 by default
* Allow unsigned programs
* Make the green button zoom/maximize instead of Spaces full screen

Software Updates (System Preferences) - settings:
* Download new Updates when available: On for work laptop, off otherwise.
* Install macOS updates: off
* Install system data files and security updates: off

```
# disable fn idiot
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true
# defaults write NSGlobalDomain com.apple.keyboard.fnState -bool false

# disable Gatekeeper
sudo spctl --master-disable
spctl --status

killall Finder
```
Go into System Settings > Privacy and Security > Scroll all the way down to security.
Log in and out to fix green button behavior.

Dock: Purge all the apps, add Safari, Utilities, Terminal.
```
# Clear all Dock apps
defaults write com.apple.dock persistent-apps -array

# Add Safari
defaults write com.apple.dock persistent-apps -array-add \
'{"tile-data"={"file-data"={"_CFURLString"="/Applications/Safari.app";"_CFURLStringType"=0;}}}'

# Add Terminal
defaults write com.apple.dock persistent-apps -array-add \
'{"tile-data"={"file-data"={"_CFURLString"="/System/Applications/Utilities/Terminal.app";"_CFURLStringType"=0;}}}'

# Make the green button Zoom
defaults write NSGlobalDomain AppleWindowTabbingMode -string manual
defaults write NSGlobalDomain NSWindowShouldDragOnGesture -bool true
defaults write NSGlobalDomain AppleSpacesSwitchOnActivate -bool false
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Restart Dock and Finder
killall Dock
killall Finder
```
# Finder and Dock
Finder (Menu Bar) > Settings > Show Hard Drives on Desktop
Dock Settings > Dock position left, and make it small.
Drag the Applications folder to the Dock to make a Stack.

# Terminal

## Make Home and End work normally
* Go to Terminal > Settings...
* Go to Profiles, select the profile you use.
* Go to Keyboard.
* Add a shortcut with no modifier for the **"Home"** key, paste `\033[H` into the box (you can't press home, it won't work."
* Add a shortcut with no modifier for the **"End"** key, paste `\033[F` into the box (you can't press home, it won't work."

## Fonts
* Profiles > BAsic (or other profile) > Text.
* Font: TextMode92X 14
* Set Text color to: #F39F41 / 243 159 65
* Set background to black / #000000 / 0 0 0
* Set bold text color and cursor color to: #80A0FF / 128 160 255
* Blink cursor

## Right-click Paste: BetterTouchTool
* open BetterTouchTool
* Add Terminal.app (click the left-most + at the bottom, either browse to it or if it's running, use the running apps menu)
* Click Terminal on the left.
* Click the Normal Mouse at the top.
* Click the large + to "Add first Normal Mouse Trigger for Terminal" (or + if you already have some set up)
* Click Record, right-click the large recording box.
* Click Add first action.
* Use a keyboard action, Command + V

# Disable Notification UI
Enable Do Not Disturb forever
```
defaults write com.apple.controlcenter "NSStatusItem Visible FocusModes" -bool true
#osascript -e 'tell application "System Events" to tell process "ControlCenter" to click menu bar item "Focus" of menu bar 1'
```
Go in System Preferences > Focus > Do Not Disturb.  Set a Schedule, click Schedule On, select all days, 00:00 to 00:00 and click Done.  It will say "On - Every day" in the main screen.

You should probably turn off "Share across devices" on the main Focus panel.

Turn off Focus Status in the main channel so things like Slack don't say you're AFK automatically.

## Homebrew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
Close the shell and open a new one so the profile is updated with the brew config.

# Third party tools
* Homebrew (see above)
* xquartz (installed using brew)
* https://github.com/sbmpost/AutoRaise (note this is included in private OSS)
```
# Private OSS + Browsers
brew install --cask xquartz
brew install macvim
brew install --cask librewolf
brew install --cask firefox@esr
brew install --cask google-chrome
brew install --cask wine-stable
brew install winetricks
brew install zenity
brew install --cask stats
brew install awscli
brew install python@3.14
brew install --cask dimentium/autoraise/autoraiseapp
brew install --cask github
brew install --cask windows-app

brew install --cask hammerspoon
brew install --cask bettertouchtool
brew install --cask moom
brew install --cask alt-tab

#brew install --cask utm
#brew install --cask virtualbox

# Work tools: Note almost all of these except Zoom and Datagrip, and to an extent, 1password are also a web app.
brew install --cask slack
brew install datagrip
#brew install --cask github
brew install --cask postman
brew install --cask linear-linear
brew install --cask notion
brew install --cask zoom
brew install --cask 1password
brew install --cask 1password-cli

# Private commercial
brew install --cask microsoft-office-businesspro
# brew install --cask vmware-fusion
# VMWare Fusion cask doesn't work, download it manually.

```

Macvim:
```
cat << ""
set guioptions=egmrti
set guifont=Monaco:h14
set mouse=a
set clipboard=unnamed
set noimd
set visualbell
set ttyfast
```

# Firefox
* Open Firefox, Keep in Dock, set as Default, do not import from previous brwoser.
about:config:
```
browser.newtabpage.activity-stream.discoverystream.sendToPocket.enabled -> false
extensions.pocket.showHome -> false
media.autoplay.default -> 0
```
* New Tab - Settings:
  * Disable shortcuts
  * Disable Recommended Stories
* New Tab - Weather: Switch to Celsius

Extensions:
* Ublock Origin: ublockorigin.com > Install, Allow in private windows.
* Dark Reader: [https://addons.mozilla.org/en-US/firefox/addon/darkreader/]

# Chrome
* Install Ublock Origin.

# AltTab
* Exclude RDP - it may need to be added manually.  Use the menu bar icon for AltTab > Settings > Blacklist > click the +, navigate to the "Windows" app.  Set it to Always (since Cmd+Tab can be used to get away from RDP)
* Polices > Updates policy: "Don't check for updates periodically"

# AutoRaise
* Open the app.
* Right-click the balloons icon in the menu bar
  * Window raise: Drag all the way to the left to disable.
  * Window focus: 50 ms
  * Enable on launch
[https://www.zdnet.com/article/this-quick-mac-tip-saves-me-time-and-clicks-all-day-long/]

# Moom
Grid > Set a hot key for the grid - Control+Shift+Command+G.

# Hammerspoon
Copy `.hammerspoon` from this directory to home (`cp -r .hammerspoon ~/.hammerspoon`).

It contains the following `init.lua` that listens for left+right mouse click and sends Shift+Command+G to invoke Moom Grid.
```
local leftDown  = false
local rightDown = false
local fired     = false

local function fireMoom()
  if not fired then
    fired = true
    hs.eventtap.keyStroke({ "shift", "control", "cmd" }, "g", 0)
  end
end

local mouseWatcher = hs.eventtap.new({
  hs.eventtap.event.types.leftMouseDown,
  hs.eventtap.event.types.leftMouseUp,
  hs.eventtap.event.types.rightMouseDown,
  hs.eventtap.event.types.rightMouseUp,
}, function(e)
  local t = e:getType()

  -- LEFT DOWN
  if t == hs.eventtap.event.types.leftMouseDown then
    if rightDown then
      fireMoom()
      return true  -- swallow second click only
    end
    leftDown = true
    return false
  end

  -- RIGHT DOWN
  if t == hs.eventtap.event.types.rightMouseDown then
    if leftDown then
      fireMoom()
      return true  -- swallow second click only
    end
    rightDown = true
    return false
  end

  -- LEFT UP
  if t == hs.eventtap.event.types.leftMouseUp then
    leftDown = false
    fired = false
    return false
  end

  -- RIGHT UP
  if t == hs.eventtap.event.types.rightMouseUp then
    rightDown = false
    fired = false
    return false
  end

  return false
end)

mouseWatcher:start()

hs.alert.show("Left+Right click → Moom Grid (clean)")
```

# RDP Client / "Windows app"
* Add a custom resolution that corresponds to the size of a title bar * 2 + menu bar removed from the vertical height to prevent annoyances accessing the top of the remote computer.
* It may be nicer to just run the RDP session in a window roughly the size of the monitor.
  * Create a custom resolution a little bit smaller than the monitor with a title bar, menu bar, and dock - e.g. 1078x1800 for a vertical 1080p monitor - 1080x1920.  Set it not to be in full screen, once the session is connected, uncheck Window > Fit to Window to avoid scaling.

# Linux in VMWare or Parallels
* The scaling in VMWare or VirtualBox using `open-vm-tools` requires Wayland / Gnome on armhf.  Just install xrdp.
* Parallels Tools supports scaling with XFCE / X11 on current versions of Debian.
* Using xrdp allows further flexibility in what OS/VM/Remote system is being used.

TODO: Make an AMD64 chroot to run the production version of Chrome for buggy apps.

# Fonts
Copy the fonts from the font directory in this repository to `~/Library/Fonts` (or `/Library/Fonts` to install for all users).

# Auto-login items
System Preferences > General > Login Items & Extensions
* Hammerspoon (should add itself)
* BetterTouchTool
* Moom
* AutoRaise

# Dock Items
* Finder
* Terminal
* Firefox
* Chrome
* HotQR Generator
* HotQR Reader
* VMWare
* 1Password / KeePassium

Add a stack for Applications
