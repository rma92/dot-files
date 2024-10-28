REM \local\git-system\dot-files\windows\launch\bats\19h1_release-x64.cmd
call "D:\Program Files\Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" x64
set "INCLUDE=D:\Program Files\Windows Kits\10\Include\10.0.16299.0\km\crt;D:\Program Files\Microsoft Visual Studio\2017\BuildTools\VC\Tools\MSVC\14.10.25017\ATLMFC\include;D:\Program Files\Microsoft Visual Studio\2017\BuildTools\VC\Tools\MSVC\14.10.25017\include;D:\Program Files\Windows Kits\NETFXSDK\4.8\include\um;D:\Program Files\Windows Kits\10\include\10.0.16299.0\ucrt;D:\Program Files\Windows Kits\10\include\10.0.18362.0\shared;D:\Program Files\Windows Kits\10\include\10.0.16299.0\um;D:\Program Files\Windows Kits\10\include\10.0.16299.0\winrt;D:\Program Files\Windows Kits\10\include\10.0.16299.0\cppwinrt"
set LIB=D:\Program Files\Microsoft Visual Studio\2017\BuildTools\VC\Tools\MSVC\14.10.25017\ATLMFC\lib\x64;D:\Program Files\Microsoft Visual Studio\2017\BuildTools\VC\Tools\MSVC\14.10.25017\lib\x64;D:\Program Files\Windows Kits\NETFXSDK\4.8\lib\um\x64;D:\Program Files\Windows Kits\10\lib\10.0.18362.0\ucrt\x64;D:\Program Files\Windows Kits\10\lib\10.0.18362.0\um\x64;
set LIBPATH=D:\Program Files\Microsoft Visual Studio\2017\BuildTools\VC\Tools\MSVC\14.10.25017\ATLMFC\lib\x64;D:\Program Files\Microsoft Visual Studio\2017\BuildTools\VC\Tools\MSVC\14.10.25017\lib\x64;D:\Program Files\Microsoft Visual Studio\2017\BuildTools\VC\Tools\MSVC\14.10.25017\lib\x64\store\references;D:\Program Files\Windows Kits\10\UnionMetadata\10.0.16299.0;D:\Program Files\Windows Kits\10\References\10.0.16299.0;
set PATH=%PATH%;D:\Program Files\Windows Kits\10\bin\10.0.16299.0\x64
doskey windbg64=D:\PROG#OLC\WIND#B-J\10\Debuggers\x64\windbg.exe $*
doskey windbg=D:\PROG#OLC\WIND#B-J\10\Debuggers\x64\windbg.exe $*
@rem doskey windbg=\\.\cdrom1\PROG#OLC\WIND#B-J\10\Debuggers\x64\windbg.exe $*
doskey windbg32=D:\PROG#OLC\WIND#B-J\10\Debuggers\x86\windbg.exe $*
doskey inspect=D:\PROG#OLC\WIND#B-J\10\bin\1001#20P.0\x64\inspect.exe $*
title 1703_release_amd64

