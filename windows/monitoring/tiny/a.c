#include <windows.h>
/*
Test of making a small program with no C standard library
TCC: 

\local\tcc32\tcc.exe -nostdlib a.c -lkernel32 -luser32
\local\tcc32\tcc.exe -c a.c -o a.o
TODO: Is it possible to link a.obj from Tiny C Compier with Visual C++.
link a.o /entry:_start /nodefaultlib /nologo /incremental:no /machine:I386 /out:testnt.exe /subsystem:windows,3.10 

Build with Visual C++ 2003 (this will run on NT 3.1)
cl a.c
link a.obj kernel32.lib user32.lib /entry:_start /nodefaultlib /nologo /incremental:no /machine:I386 /out:testnt.exe /subsystem:windows,3.10
*/
void _start()
{
  MessageBoxA(0, "Hi", "Test program", 0);
  ExitProcess(0);
}
