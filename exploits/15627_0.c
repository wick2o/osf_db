#include <unistd.h>

#include <stdlib.h>

#include <linux/fcntl.h>

int main(int ac, char **av)

{

    char *fname = av[0];

    int fd = open(fname, O_RDONLY);

    int r;

    

    while (1) {

        r = fcntl(fd, F_SETLEASE, F_RDLCK);

        if (r == -1) {

            perror("F_SETLEASE, F_RDLCK");

            exit(1);

        }

        r = fcntl(fd, F_SETLEASE, F_UNLCK);

        if (r == -1) {

            perror("F_SETLEASE, F_UNLCK");

            exit(1);

        }

    }

    return 0;

}


