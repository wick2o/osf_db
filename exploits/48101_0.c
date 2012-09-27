#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#define BUFSIZE getpagesize()

int main(int argc, char **argv)
{
	void *ptr;
	if (posix_memalign(&ptr, getpagesize(), BUFSIZE) < 0) {
		perror("posix_memalign");
		exit(1);
	}
	if (madvise(ptr, BUFSIZE, MADV_MERGEABLE) < 0) {
		perror("madvise");
		exit(1);
	}
	*(char *)NULL = 0;
	return 0;
}