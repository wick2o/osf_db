#include <asm/unistd.h>

main(){
        syscall(__NR_set_mempolicy,3,0,0);
        write(1,10,8192);
}
