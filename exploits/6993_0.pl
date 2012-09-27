#!/usr/bin/perl
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Response;
use Digest::MD5 qw(md5_hex);
($ho,$fi) = @ARGV;
$md5 = md5_hex("$fi||||");
$ua = new LWP::UserAgent(); $ua->agent("Opera 6.0");
$uri = "http://".$ho."/typo3/showpic.php?file=$fi&md5=$md5";
$req = HTTP::Request->new("GET",$uri);
$res = $ua->request($req);
if ($res->content !~ /was not found/ && $res->content !~ /No valid/) {print "\n$fi exists\n";}
else {print "\n$fi not found\n";}
