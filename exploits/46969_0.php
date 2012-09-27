<?php

$target_file = 'META-INF/MANIFEST.MF';

$za = new ZipArchive();
if ($za->open('test.jar') !== TRUE)
{
    return FALSE;
}

if ($za->statName($target_file) !== FALSE)
{
    $fd = $za->getStream($target_file);
}
else
{
    $fd = FALSE;
}
$za->close();

if (is_resource($fd))
{
    echo strlen(stream_get_contents($fd));
}

?>

