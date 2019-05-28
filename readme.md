# dot-files
(public rma92 dot-files repo)
Eventually, this will contain pretty much all of my user config.  It's incomplete now, but contains my most important things.

# Linux
The stuff here mostly goes in ~.  The .vimrc file should be the same as the _vimrc for Windows, and the .vim folder should be the same as the vimfiles folder for Windows.

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

# Fonts
This contains various fonts.  They go in the .font folder on Linux
## Cloning using PowerShell
```powershell
$cmd = "svn export https://github.com/rma92/dot-files/trunk/fonts"
iex $cmd
```
