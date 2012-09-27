<?php
$o = new ZipArchive();
if (! $o->open('test.zip',ZipArchive::CHECKCONS)) {
	exit ('error can\'t open');
}
$o->getStream('file2'); // this file is ok
echo "OK";
$r = $o->getStream('file1'); // this file has a wrong crc
while (! feof($r)) {
	fread($r,1024);
}
echo "never here\n";
?>
