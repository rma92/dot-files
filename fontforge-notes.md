# FontForge Tips

## Hide empty glpyhs
Encoding > Compact (Hide unused glyphs)

Then you can manually select everything in use using the shift key.

## Change Font Settings
Element > Font Info (Ctrl+Shift+F)

## Manually set fixed-width flag?
* Font Info
* OS/2 Tab (left)
* Panose Tab
* Spacing > Monospaced

## Other shortcuts
Ctrl+\ = Transform
Ctrl+Shift+L = Set Width
Metrics > Center in Width does not get a shortcut?

## Make the font work in Windows console
Copy the OS/2 font settings for Panose and MISC from Courier.
Specifically, PFM Family should be "Serif", and IBM Family should be "SS Typewriter".

Not all Panose settings may need to be set like this, but they are:
Family Kind: Latin: Text and Display
Serifs: Thin
Weight: Light
**Proportion: Monospaced**
Contrast: None
Stroke Variation: No Variation
Arm Style: Straight Arms/Horizontal
Letterform: Normal
Midline: Standard/Trimmed
X-Height: Constant/Large

### Add it to the registry
After installing the font, add a STRING entry with a number to HKCU or HKLM of SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont.  Value is the name of the font.


