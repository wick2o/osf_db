#include <windows.h>
#include <stdio.h>
#include <ddk/ntifs.h>


void TextError(LPTSTR lpszFunction)
{
   // Retrieve the system error message for the last-error code

   LPVOID lpMsgBuf;
   LPVOID lpDisplayBuf;
   DWORD dw = GetLastError();

   FormatMessage(
       FORMAT_MESSAGE_ALLOCATE_BUFFER |
       FORMAT_MESSAGE_FROM_SYSTEM |
       FORMAT_MESSAGE_IGNORE_INSERTS,
       NULL,
       dw,
       MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
       (LPTSTR) &lpMsgBuf,
       0, NULL );

   // Display the error message and exit the process

   lpDisplayBuf = (LPVOID)LocalAlloc(LMEM_ZEROINIT,
       (lstrlen((LPCTSTR)lpMsgBuf)+lstrlen((LPCTSTR)lpszFunction)+40) \
       *sizeof(TCHAR));
   sprintf((LPTSTR)lpDisplayBuf,
       TEXT("%s failed with error %d: %s"),
       lpszFunction, dw, lpMsgBuf);
   //MessageBox(NULL, (LPCTSTR)lpDisplayBuf, TEXT("Error"), MB_OK);

   printf(lpDisplayBuf);

   LocalFree(lpMsgBuf);
   LocalFree(lpDisplayBuf);
}


BOOL TestIOCTL(PCHAR DeviceName, DWORD Ioctl, DWORD InputBuffer, \
        DWORD InputLen, DWORD OutputBuffer, DWORD OutputLen )
{
 HANDLE hDevice;               // handle to the drive to be examined
 BOOL bResult;                 // results flag
 DWORD junk;                   // discard results
 IO_STATUS_BLOCK  IoStatusBlock;

 hDevice = CreateFile(DeviceName,
                   0,                // no access to the drive
                   FILE_SHARE_READ | // share mode
                   FILE_SHARE_WRITE,
                   NULL,             // default security attributes
                   OPEN_EXISTING,    // disposition
                   0,                // file attributes
                   NULL);            // do not copy file attributes

 if (hDevice == INVALID_HANDLE_VALUE) // cannot open the drive
 {
    TextError("CreateFile");
   return (FALSE);
 }


 bResult = DeviceIoControl(hDevice,  // device to be queried
                             Ioctl,
                           (PVOID)InputBuffer,
                           InputLen,
                           (PVOID)OutputBuffer,
                           OutputLen,     // output buffer
                           &junk,                 // # bytes returned
                           (LPOVERLAPPED)NULL);  // synchronous I/O


 if(!bResult){
      TextError("DeviceIoControl");
 }

 CloseHandle(hDevice);

 return TRUE;
}

int main(int argc, char *argv[])
{
    DWORD Ioctl, Input, ILen, Output, OLen;
    DWORD SSDT;
    char *ptr;

    if(TestIOCTL("\\\\.\\hcmon", 0x8101232B, 0x80000001, 0, 0x80000002, 0)){
        printf("You should not see this");
    }
    else{
        printf("Failed to open device");
    }


     return 0;
}
