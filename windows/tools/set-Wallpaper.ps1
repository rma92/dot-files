param (
    [string]$imagePath
)

if (-not $imagePath) {
  Write-Error "Please provide imagePath."
  exit 1
}

#stretch
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name WallpaperStyle -Value 2
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name TileWallpaper -Value 0

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Wallpaper{
  [DllImport("user32.dll", CharSet = CharSet.Auto)]
  public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
[Wallpaper]::SystemParametersInfo(0x0014, 0, $imagePath, 0x0001 -bor 0x0002);
