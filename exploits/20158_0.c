#include <stdio.h>
#include <stdlib.h>
#include <machine/segments.h>
#include <machine/sysarch.h>

int main(int argc,char **argv){

    if(i386_set_ldt(LUDATA_SEL+1,NULL,-1)==-1){
        perror("i386_set_ldt");
        exit(EXIT_FAILURE);
    }

    exit(EXIT_FAILURE);
}
