It is possible to create a VSS snapshot of the boot drive and image it.

# Setup
```
sc config vss start= demand
sc start vss
vssadmin create shadow /for=C:
REM note the volume name of the shadow copy. Use vssadmin list shadows if needed.

dism /capture-image /imagefile:C:\image.wim /capturedir:\\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy1\ /name:"host" /compress:max
```

# Cleanup
(Only stop and disable the service if needed)
```
vssadmin list shadows
vssadmin delete shadows /for=C: /all
sc stop vss
sc config vss start= disabled
```

# Deploying the snapshot
Boot into WinPE/Windows Setup.
* Use `diskpart` to partition drive.  If MBR, make the relevant drive active.
* `dism /apply-image /imagefile:image.wim /index:1 /applydir:T:\`
* `bcdboot T:\Windows`

Note: use the script in driver.txt to run DISM to remove the OEM drivers from an offline image.
