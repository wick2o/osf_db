import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(('example.com',554))

setRequest = "SETUP / RTSP/1.0\r\n\r\n"

s.send(setRequest)
s.close()
