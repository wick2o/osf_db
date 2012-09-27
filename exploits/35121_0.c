hookproc.dll:

BOOL APIENTRY DllMain( HANDLE hModule, 
                       DWORD  ul_reason_for_call, 
                       LPVOID lpReserved
					 )
{
    return TRUE;
}

extern "C" __declspec(dllexport) LRESULT CALLBACK DummyHookProc(int nCode, WPARAM wParam,LPARAM lParam)
{
    ::Sleep(0);
    return ::CallNextHookEx(0, nCode, wParam, lParam);
}

launch.exe:
// launch.cpp : Defines the entry point for the application.
//

#include "stdafx.h"

extern "C" __declspec(dllimport) LRESULT CALLBACK DummyHookProc(int nCode, WPARAM wParam,LPARAM lParam);
HANDLE g_stop_event = CreateEvent(NULL, TRUE, FALSE, NULL);


DWORD CALLBACK WinThreadProc(PVOID p)
{
    TCHAR name[32];
    if (p)
        wsprintf(name, "desk_%x", p);
    else
        wsprintf(name, "default");
    HDESK desk = ::CreateDesktop(name, 0, 0, 0, GENERIC_ALL, 0);
    HDESK old_desk = ::GetThreadDesktop(::GetCurrentThreadId());
    ::SetThreadDesktop(desk);

    for(int i=0; i<8; i++)
    {
        CreateWindow(TEXT("STATIC"), TEXT("dummy"), 
            WS_VISIBLE, 10, i*30, 200, 30, 0, 0, 0, 0);
    }
    MSG msg;
    while (1) 
    { 
        ::GetMessage(&msg, NULL, 0, 0);
        ::TranslateMessage(&msg); 
        ::DispatchMessage(&msg); 
    }
    ::SetThreadDesktop(old_desk);
    ::CloseDesktop(desk);
    return 0;
}

DWORD CALLBACK ThreadProc(PVOID p)
{
    TCHAR name[32];
    if (p)
        wsprintf(name, "desk_%x", p);
    else
        wsprintf(name, "default");
    
    HDESK desk = ::CreateDesktop(name, 0, 0, 0, GENERIC_ALL, 0);
    ::SwitchDesktop(desk);
    ::Sleep(0);
    HDESK old_desk = ::GetThreadDesktop(::GetCurrentThreadId());
    ::SetThreadDesktop(desk);
    HINSTANCE dll = ::GetModuleHandle(TEXT("HOOKPROC.dll"));
    HHOOK hk1 = ::SetWindowsHookEx(WH_MOUSE, DummyHookProc, dll, 0);
    HHOOK hk2 = ::SetWindowsHookEx(WH_CALLWNDPROC, DummyHookProc, dll, 0);
    HHOOK hk3 = ::SetWindowsHookEx(WH_CALLWNDPROCRET, DummyHookProc, dll, 0);
    HHOOK hk4 = ::SetWindowsHookEx(WH_GETMESSAGE, DummyHookProc, dll, 0);
    
    for (;;)
    {
        MSG msg;
        while (::PeekMessage(&msg, NULL, 0, 0, PM_REMOVE)) 
        { 
            ::TranslateMessage(&msg); 
            ::DispatchMessage(&msg); 
        }
        
        if (::MsgWaitForMultipleObjects(1, &g_stop_event, 
            FALSE, INFINITE, QS_ALLINPUT) == WAIT_OBJECT_0)
        {
            break;
        }
    }
    ::SwitchDesktop(old_desk);
    ::Sleep(0);

    ::UnhookWindowsHookEx(hk1);
    ::UnhookWindowsHookEx(hk2);
    ::UnhookWindowsHookEx(hk3);
    ::UnhookWindowsHookEx(hk4);
	::PostMessage(HWND_BROADCAST, WM_NULL, 0, 0);
	::SendNotifyMessage(HWND_BROADCAST, WM_NULL, 0, 0);
    ::SetThreadDesktop(old_desk);
    ::CloseDesktop(desk);
    return 0;

}

int APIENTRY WinMain(HINSTANCE hInstance,
                     HINSTANCE hPrevInstance,
                     LPSTR     lpCmdLine,
                     int       nCmdShow)
{

    int i;
    for(i=0; i<4; i++)
    {
        ::CloseHandle(::CreateThread(NULL, 0, WinThreadProc, (LPVOID)i, 0, NULL));
    }

    ::Sleep(1000);;
    while((::GetAsyncKeyState(VK_ESCAPE)&32768)==0)
    {
        for(i=0; i<4; i++)
        {
            HANDLE trd = ::CreateThread(NULL, 0, ThreadProc, (LPVOID)i, 0, NULL);
            ::Sleep(100);
            ::SetEvent(g_stop_event);
            ::WaitForSingleObject(trd, INFINITE);
            ::ResetEvent(g_stop_event);
            ::CloseHandle(trd);
        }
    }

	return 0;
}
