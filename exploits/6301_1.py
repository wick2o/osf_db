import socket

class SNMPTrapsServer:
def __init__(self):
pass

def start(self):
self.s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
self.s.bind(("0",162))
while 1:
snmp = self.s.recv(1500)
print snmp[73:]

def stop(self):
self.s.close()

server = SNMPTrapsServer()
server.start()
server.stop()