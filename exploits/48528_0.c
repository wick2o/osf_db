/*
127# gcc -o grr grr.c && ./grr 6050
127# gcc -o grr grr.c && ./grr 6051
Memory fault (core dumped)
127#


*/
#include <stdlib.h>
#include <string.h>
#include <netdb.h>

int main(int argc, char *argv[]){
	char *cycek;
	cycek=malloc(atoi(argv[1]));

	if(!cycek) return 1;
	memset(cycek,'A',atoi(argv[1]));

	getservbyname(cycek,"tcp");

	return 0;
}