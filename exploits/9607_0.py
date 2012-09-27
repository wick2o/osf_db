# http://felinemenace.org/~nd/SMUDGE
# Sambar script (c) nd@felinemenace.org
from SMUDGE import *
import sys
sm = SMUDGE(1)

sm.setname("SambarOverflow")

sm.plain("POST /search/results.stm HTTP/1.1")
sm.addcrlf()
sm.plain("Host: MSUDGEDPU")
sm.addcrlf()
sm.plain("Content-Length: ")
sm.blocksize("postdata")
sm.addcrlf()
sm.addcrlf()
sm.putblock("postdata")
sm.addcrlf()
sm.addcrlf()

sm.newblock("postdata")
sm.updateblock("postdata","spage=0&indexname=docs&query=")
sm.blockvariable("postdata","MEEP")
sm.updateblock("postdata","&style=page")

sm.run("127.0.0.1",80,"topdown","single")
