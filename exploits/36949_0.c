#include <stdio.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>

#define FIFOPATH "/tmp/fifobug.debug"

void getsysctl(name, ptr, len)
    const char *name;
    void *ptr;
    size_t len;
{
    size_t nlen = len;
    if (sysctlbyname(name, ptr, &nlen, NULL, 0) != 0) {
                perror("sysctl");
                printf("name: %s\n", name);
                exit(-1);
    }
    if (nlen != len) {
        printf("sysctl(%s...) expected %lu, got %lu", name,
            (unsigned long)len, (unsigned long)nlen);
                exit(-2);
    }
}

This function is used as a wrapper around sysctlbyname(3) library routine. The following code is this…

main(int argc, char *argv[])
{
	int acnt = 0, bcnt = 0, maxcnt;
	int fd;
	unsigned int maxiter;
	int notdone = 1;
	int i= 0;

	getsysctl("kern.ipc.maxsockets", &maxcnt, sizeof(maxcnt));
	if (argc == 2) {
		maxiter = atoi(argv[1]);
	} else {
		maxiter = maxcnt*2;
	}

They retrive the maximum IPC socket number using the previous wrapper routine and set ‘maxiter’ to that value multiplied by two unless the user specified a value through the first argument of the program. The next code is this.

	unlink(FIFOPATH);
	printf("Max sockets: %d\n", maxcnt);
	printf("FIFO %s will be created, opened, deleted %d times\n",
		FIFOPATH, maxiter);

	getsysctl("kern.ipc.numopensockets", &bcnt, sizeof(bcnt));

They unlink the “/tmp/fifobug.debug” file and after some printf(3)s, they store the number of the open IPC sockets to ‘bcnt’ variable. Next part is…

	while(notdone && (i++ < maxiter)) {
		if (mkfifo(FIFOPATH, 0) == 0) {
			chmod(FIFOPATH,
				S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP|S_IROTH|S_IWOTH);
		}
		fd = open(FIFOPATH, O_WRONLY|O_NONBLOCK);
		if ((fd <= 0) && (errno != ENXIO)) {
			notdone = 0;
		}
		unlink(FIFOPATH);
	}

This loop will iterate as long as it has not reached more than ‘maxiter’ (maximum IPC socket number multiplied by two) times and flag ‘notdone’ is non-zero. Inside the ‘while’ loop, it creates a FIFO in the previously unlinked file and sets its mode accordingly. Then, it opens that FIFO as write only and non-blocking and then it just unlinks it. If the open(2) system call returns ‘ENXIO’, flag ‘notdone’ is zeroed out. This is a simple code to reach the fiflo_open() bug discussed above since the FIFO created is on write and non-blocking mode and it has no readers on it.
Finally, the code continues…

	getsysctl("kern.ipc.numopensockets", &acnt, sizeof(acnt));
	printf("Open Sockets: Before Test: %d, After Test: %d, diff: %d\n",
		 bcnt, acnt, acnt - bcnt);
	if (notdone) {
		printf("FIFO/socket bug is fixed\n");
		exit(0);
	} else {
		printf("FIFO/socket bug is NOT fixed\n");
		exit(-1);
	}
}

