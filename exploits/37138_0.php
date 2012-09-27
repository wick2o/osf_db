<?
putenv("BLAHBLAH=123");
putenv("LD_LIBRARY_PATH=/no/way");
putenv("PHP_TESTVAR=allowed");
$env = array('BLAHBLAH' => '123', 'LD_LIBRARY_PATH' => '/no/way',
'PHP_TESTVAR' => 'allowed');
$dptspec = array(0 => array("pipe", "r"),
                 1 => array("pipe", "w"));
$fp = proc_open('env', $dptspec, $pipes, './', $env);
echo "<pre>";
while(!feof($pipes[1])) echo fgets($pipes[1], 1024);
fclose($pipes[1]);
echo "</pre>";
?>
