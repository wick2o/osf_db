#!/usr/bin/python

import locale

print locale.setlocale(locale.LC_COLLATE, 'pl_PL.UTF8')
print repr(locale.strxfrm('a'))
