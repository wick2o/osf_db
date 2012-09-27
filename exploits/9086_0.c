#include <stdio.h>
#include <sys/types.h>
#include <sys/sem.h>
#include <sys/ipc.h>

int
main()
{
    int i;

        for(i = 0; i < 0x40; i++)
                semop(i, (struct sembuf *) NULL, 0);

}

