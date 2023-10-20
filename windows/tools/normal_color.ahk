userBg := DllCall("user32\GetSysColor", "int", 1) ; Desktop background color

backgroundModes := Map(
		"Normal"  , Map(0x000000, 0xC8C8C8, 1,   userBg, 2, 0xD1B499, 3, 0xDBCDBF, 4, 0xF0F0F0, 5, 0xFFFFFF, 6, 0x646464, 7, 0x000000, 8, 0x000000, 9, 0x000000, 10, 0xB4B4B4, 11, 0xFCF7F4, 12, 0xABABAB, 13, 0xD77800, 14, 0xFFFFFF, 15, 0xF0F0F0, 16, 0xA0A0A0, 17, 0x6D6D6D, 18, 0x000000, 19, 0x000000, 20, 0xFFFFFF, 21, 0x696969, 22, 0xE3E3E3, 23, 0x000000, 24, 0xE1FFFF, 26, 0xCC6600, 27, 0xEAD1B9, 28, 0xF2E4D7, 29, 0xD77800, 30, 0xF0F0F0)
                )
	try
		for displayElement, color in backgroundModes["Normal"]
			DllCall("user32\SetSysColors", "Int", 1, "IntP", displayElement, "UIntP", color)
