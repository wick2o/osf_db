#include <stdlib.h>
#include <string.h>
int main(int argc, char **argv)
{
        char * buf = NULL;
        puts("Usage: ./test A 3492348247\n");
        memcpy(buf, argv[1], atoi(argv[2]));
        return 0;
}