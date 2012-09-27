import socket

host = 'localhost'
port = 80

include_file = True
complete_path = True

try:
    for i in range(0, 1024):

        for x in range(0, 8):
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.connect((host, port))
            s.settimeout(2)
            s.send('GET http:/// HTTP/1.1\r\n'
                   'Host: ' + host + '\r\n\r\n')
            print '.',

        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((host, port))
        s.settimeout(2)
        s.send('GET / HTTP/1.1\r\n'
               'Host: ' + host + '\r\n\r\n')
        s.recv(8192)

        print 'response received'
except:
    print 'error contacting server'
