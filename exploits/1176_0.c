#include <sys/fcntl.h>

main(int argc,char*argv[]) {
  char buf[80*24];
  int f=open(argv[1],O_RDWR);
  while (1) {
    lseek(f,0,0);
    read(f,buf,sizeof(buf));
    write(1,"\033[2J\033[H",7); // clear terminal, vt100/linux/ansi
    write(1,buf,sizeof(buf));
    usleep(10000);
  }
}
