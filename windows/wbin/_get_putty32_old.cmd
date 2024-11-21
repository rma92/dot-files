cmd /c ..\downloader\dump-winjs.cmd
cmd /c js "https://the.earth.li/~sgtatham/putty/latest/w32old/putty.exe" -saveTo putty.exe -ignoreCertError yes -force yes
cmd /c js "https://the.earth.li/~sgtatham/putty/latest/w32old/pscp.exe" -saveTo pscp.exe -ignoreCertError yes -force yes

cmd /c js "https://the.earth.li/~sgtatham/putty/latest/w32old/plink.exe" -saveTo plink.exe -ignoreCertError yes -force yes
cmd /c js "https://the.earth.li/~sgtatham/putty/latest/w32old/pageant.exe" -saveTo pageant.exe -ignoreCertError yes -force yes
cmd /c js "https://the.earth.li/~sgtatham/putty/latest/w32old/puttygen.exe" -saveTo puttygen.exe -ignoreCertError yes -force yes
cmd /c js "https://the.earth.li/~sgtatham/putty/latest/w32old/pterm.exe" -saveTo pterm.exe -ignoreCertError yes -force yes

