#ifndef WIN32_NO_STATUS
# define WIN32_NO_STATUS    // I prefer working with ntstatus.h
#endif
#include <windows.h>
#include <assert.h>
#include <stdio.h>
#include <winerror.h>
#include <winternl.h>
#include <stddef.h>
#include <winnt.h>
#ifdef WIN32_NO_STATUS
# undef WIN32_NO_STATUS
#endif
#include <ntstatus.h>
 
#pragma comment(lib, "GDI32")
#pragma comment(lib, "USER32")
 
int main(int argc, char **argv)
{
    WNDCLASS Class;
    HWND Window;
    HDC Device;
 
    Class.style             = CS_OWNDC;
    Class.lpfnWndProc       = DefWindowProc;
    Class.cbClsExtra        = 0;
    Class.cbWndExtra        = 0;
    Class.hInstance         = GetModuleHandle(NULL);
    Class.hIcon             = NULL;
    Class.hCursor           = NULL;
    Class.hbrBackground     = NULL;
    Class.lpszMenuName      = NULL;
    Class.lpszClassName     = "Class";
 
    RegisterClass(&Class);
 
    Window                  = CreateWindowEx(WS_EX_COMPOSITED, "Class", "Window", 0, 32, 32, 32, 32, NULL, NULL, NULL, NULL);
    Device                  = GetWindowDC(Window);
 
    BitBlt(Device, 32, 32, 32, 32, Device, 32, 32, CAPTUREBLT | SRCCOPY);
     
    return 0;
}
