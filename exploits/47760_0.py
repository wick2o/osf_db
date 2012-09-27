import socket

host = 'localhost'
port = 80

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((host, port))
s.settimeout(8)    

s.send('GET ' + '/' * 4096 + ' HTTP/1.1\r\n'
       'Host: localhost\r\n\r\n')


