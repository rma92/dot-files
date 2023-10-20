These batch files launch a visual studio build prompt with proper include paths set for the various architectures, with the EWDK 19h1 (1903) mounted on the E drive.

Usage: 
-Mount EWDK ISO
-Replace drive letters if needed in batch file.
-cmd /k <batch>.cmd
-Compile with cl, csc, nmake, msbuild, masm, etc.  Basically it's a standard Visual Studio Tools command prompt + Windows SDK 