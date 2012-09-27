<?php

$data = "jfdslkjvflsdkjvlkfjvlkjfvlkdm,4w 043920r 9234r 32904r 09243 r7-89437 r892374 r894372 r894 7289r7 f  frwerfh i iurf iuryw uyrfouiwy ruy 972439 8478942 yrhfjkdhls";
$pass = "r23498rui324hjbnkj";

$maxi = 200000;
$t = microtime(1);
for ($i=0;$i<$maxi; $i++){
	openssl_encrypt($data.$i, 'des3', $pass, false, '1qazxsw2');
}
$t = microtime(1)-$t;
print "mode: openssl_encrypt ($maxi) tests takes ".$t."secs ".($maxi/$t)."#/sec \n";

?>
