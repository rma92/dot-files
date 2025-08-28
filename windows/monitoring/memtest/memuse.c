#include <stdio.h>
#include <windows.h>
#include <stdlib.h>

int main()
{
  char* str;
  int iSize = 1024 * 1024 * 256;
  char* memory;
  str = HeapAlloc( GetProcessHeap(), 0x8, 1024);
  memory = HeapAlloc( GetProcessHeap(), 0x8, iSize );
  printf("filling the memory");
  for( int i = 0; i < iSize; ++i )
  {
    memory[i] = rand() % 250;
    if( i % (100 * 1024 * 1024) == 0)
    {
      printf("%d MB\n", i / (1024 * 1024) );
    }
  }

  printf("Enter to exit.");
  gets(str);
  return 0;
}
