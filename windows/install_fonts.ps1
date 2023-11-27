$fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
dir ../fonts/*.ttf | %{ $fonts.CopyHere($_.fullname) }
