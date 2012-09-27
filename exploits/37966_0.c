#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <netinet/in.h>
#include <pthread.h>
#include <errno.h>
#include <netdb.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <fcntl.h>

#define PORT 80
#define sys_err(x)                         \
do {                                       \
   fprintf(stderr,"%s",x);                 \
   exit(-1);                               \
} while(0)

void *parse_me(void *arg);

int main(int argc, char *argv[]) {

   int r_sock,connfd,tmp,tmp2;
   struct sockaddr_in saddr;
   pthread_t bo_tak;
   struct stat statbuf;

   if ( (r_sock = socket(AF_INET, SOCK_STREAM, 0)) == -1)
      sys_err("Socket()!\n");

   tmp=sizeof(struct sockaddr_in);
   memset(&saddr,0x0,tmp);
   saddr.sin_family      = PF_INET;
   saddr.sin_port        = htons(PORT);
   saddr.sin_addr.s_addr = htonl(INADDR_ANY);

   if (bind(r_sock, (struct sockaddr *) &saddr, tmp) == -1)
      sys_err("Bind()!\n");

   if ( (listen(r_sock,0x666)) != 0)
      sys_err("Listen()!\n");

pierw_p:

   while (1) {
      if ( (connfd=accept(r_sock,(struct sockaddr*)&saddr,(socklen_t *)&tmp)) < 0) {
         if (errno == EINTR)
            goto pierw_p;
         else
            sys_err("Accept()!\n");
      }
      if ( (tmp2=pthread_create(&bo_tak,NULL,parse_me,(void *)connfd/*&tymczasowe*/) != 0))
         sys_err("Accept() => Blad przy tworzeniu watku! Wychodze...");
   }
}

void *parse_me(void *arg) {

   int sock = (int)arg;
   char buf[4096];
   char *head = "HTTP/1.1 200 OK\r\n"
                "Date: Sat, 66 Dec 666 23:56:50 GMT\r\n"
                "Server: pi3 (pi3 OS)\r\n"
                "X-Powered-By: pi3\r\n"
                "Connection: close\r\n"
                "Transfer-Encoding: chunked\r\n"
                "Content-Type: text/html; charset=UTF-8\r\n\r\n";

   memset(buf,0x0,4096);
   read(sock,buf,4096);
   write(sock,head,strlen(head));
   write(sock,"10000000FFFF0000\n",17);
   while(1)
      write(sock,"A",1);
}
