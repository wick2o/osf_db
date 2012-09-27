#!/usr/bin/perl
my $buffer = "A" x 61447;
my $filename = "BOV.XML";
open (FILE,">$filename") || die "\nCan't open $file: $!";
print FILE "$buffer";
close (FILE);
print "\nSuccessfully!\n";
