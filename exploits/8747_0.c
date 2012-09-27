#include <windows.h>
#include <commctrl.h>
#include <stdio.h>
char tWindow[]="Windows Task Manager";// The name of the main window
char* pWindow;
int main(int argc, char *argv[])
{
        long hWnd,proc;
        DWORD hThread;
        printf("%% AppShutdown - Playing with PostThreadMessage\n");
        printf("%% brett.moore@security-assessment.com\n\n");
        // Specify Window Title On Command Line
        if (argc ==2)
                pWindow = argv[1];
        else
                pWindow = tWindow;

        printf("+ Finding %s Window...\n",pWindow);
        hWnd = (long)FindWindow(NULL,pWindow);
        if(hWnd == NULL)
        {
          printf("+ Couldn't Find %s Window\n",pWindow);
          return 0;
        }
        printf("+ Found Main Window At...0x%xh\n",hWnd);
        printf("+ Finding Window Thread..");
        hThread = GetWindowThreadProcessId(hWnd,&proc);
        if(hThread  == NULL)
        {
          printf("Failed\n");
          return 0;
        }
        printf("0x%xh Process 0x%xh\n",hThread,proc);
        printf("+ Send Quit Message\n");
        PostThreadMessage((DWORD) hThread,(UINT) WM_QUIT,0,0);
        printf("+ Done...\n");
        return 0;
}

