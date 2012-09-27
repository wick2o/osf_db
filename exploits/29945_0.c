#include <stdlib.h>
#include <sys/ptrace.h>

int main(int argc, char *argv[])
{
	pid_t pid = atoi(argv[1]);

	while (1)
		ptrace(PTRACE_ATTACH, pid, NULL, NULL);

	return 0;
}


