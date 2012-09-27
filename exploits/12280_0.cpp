#define WIN32_LEAN_AND_MEAN             // Exclude rarely-used stuff from Windows
headers
#include <stdio.h>
#include <tchar.h>

#include <windows.h>
#include <winioctl.h>
#include <conio.h>


int main(int argc, char* argv[])
{
        bool bCall = true;

        // check args - if there is an arg and it is 0, don't call the IO control.
        if (argc > 1 && 0 == strcmp(argv[1], "0"))
        {
                bCall = false;
        }

        puts("Opening \\\\.\\NPPTNT2\r");
        HANDLE hFile = CreateFile("\\\\.\\NPPTNT2", 0, 0, NULL, OPEN_EXISTING,
FILE_ATTRIBUTE_NORMAL, 0);

        if (hFile != INVALID_HANDLE_VALUE)
        {
                if (bCall)
                {
                        puts("Calling DeviceIoControl\r");
                        DWORD dwRet = 0;
                        // Take this line out and the _inp will give you an AV
                        DeviceIoControl(hFile, 0x958A2568, 0, 0, 0, 0, &dwRet, 0);
                }

                puts("About to _inp(0x378)\r");

                __try
                {
                        _inp(0x378);
                }
                __except(1)
                {
                        puts("Failed reading port\r");

                        return 0;
                }

                puts("Success reading port\r");


                CloseHandle(hFile);
        }
        else
        {
                puts("Driver not found\r");
        }

        return 0;
}

