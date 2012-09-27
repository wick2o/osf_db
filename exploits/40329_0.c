#include <stdio.h>
#include <stdlib.h>

int main (int argc, char *argv[]){

char number[10000];

int a,b;

printf("%s", fconvert((double)1,atoi(argv[1]),&a,&b,number));
return 0;
}
