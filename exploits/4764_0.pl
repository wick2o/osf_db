#!/usr/bin/perl
# show_debug_data.pl
# make cgiscript.net scripts dump debug data

use strict;
use IO::Socket::Inet;

my $host = 'hostname.com';
my $path = '/cgi-script/CSMailto/CSMailto.cgi';

my $sock = IO::Socket::INET->new("$host:80");
print $sock "POST $path\n";
print $sock "Content-type: multipart/form-data;";
print $sock " boundary=--\n\n";
print <$sock>;
close($sock);