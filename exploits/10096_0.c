#include <signal.h>
#include <unistd.h>
#include <stdlib.h>
 
int main()
{
	sigset_t set;
	int i;
	pid_t pid;

	sigemptyset(&set);
	sigaddset(&set, 40);
	sigprocmask(SIG_BLOCK, &set, 0);

	pid = getpid();
	for (i = 0; i < 1024; i++)
		kill(pid, 40);

	while (1)
		sleep(1);
}
 
