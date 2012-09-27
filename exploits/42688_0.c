#include <windows.h>

int main()
{
  WinExec("calc", SW_NORMAL);
  exit(0);
  return 0;
}

BOOL WINAPI DllMain(HINSTANCE hinstDLL,DWORD fdwReason, LPVOID lpvReserved)
{
  main();
  return 0;
}
