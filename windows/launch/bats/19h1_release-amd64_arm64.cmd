REM \local\git-system\dot-files\windows\launch\bats\19h1_release-x64.cmd
call "E:\Program Files\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" amd64_arm64
set "INCLUDE=E:\Program Files\Windows Kits\10\Include\10.0.18362.0\km\crt;E:\Program Files\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.20.27508\ATLMFC\include;E:\Program Files\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.20.27508\include;E:\Program Files\Windows Kits\NETFXSDK\4.8\include\um;E:\Program Files\Windows Kits\10\include\10.0.18362.0\ucrt;E:\Program Files\Windows Kits\10\include\10.0.18362.0\shared;E:\Program Files\Windows Kits\10\include\10.0.18362.0\um;E:\Program Files\Windows Kits\10\include\10.0.18362.0\winrt;E:\Program Files\Windows Kits\10\include\10.0.18362.0\cppwinrt"
set LIB=E:\Program Files\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.20.27508\ATLMFC\lib\arm64;E:\Program Files\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.20.27508\lib\arm64;E:\Program Files\Windows Kits\NETFXSDK\4.8\lib\um\arm64;E:\Program Files\Windows Kits\10\lib\10.0.18362.0\ucrt\arm64;E:\Program Files\Windows Kits\10\lib\10.0.18362.0\um\arm64;
set LIBPATH=E:\Program Files\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.20.27508\ATLMFC\lib\arm64;E:\Program Files\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.20.27508\lib\arm64;E:\Program Files\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.20.27508\lib\arm64\store\references;E:\Program Files\Windows Kits\10\UnionMetadata\10.0.18362.0;E:\Program Files\Windows Kits\10\References\10.0.18362.0;
doskey windbg64=E:\PROG#OLC\WIND#B-J\10\Debuggers\x64\windbg.exe $*
doskey windbg=E:\PROG#OLC\WIND#B-J\10\Debuggers\x64\windbg.exe $*
@rem doskey windbg=\\.\cdrom1\PROG#OLC\WIND#B-J\10\Debuggers\x64\windbg.exe $*
doskey windbg32=E:\PROG#OLC\WIND#B-J\10\Debuggers\x86\windbg.exe $*
doskey inspect=E:\PROG#OLC\WIND#B-J\10\bin\1001#20P.0\x64\inspect.exe $*
title 19h1_release_arm64 (host x64)
