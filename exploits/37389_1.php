&lt;? php

$ _GET [ &#039; a1 &#039; ] = &quot; \xf0 &quot;; // \xf0 - \xfc で可能 $ _GET [ &#039;A1&#039;] = &quot;\ xf0&quot;; / / \ xf0 - \ xfc possible
$ _GET [ &#039; a2 &#039; ] = &quot;  href=dummy onmouseover=alert(document.title) dummy=dummy &quot;; $ _GET [ &#039;A2&#039;] = &quot;href = dummy onmouseover = alert (document.title) dummy = dummy&quot;;

header ( &quot; Content-Type:text/html; charset=Shift_JIS &quot; ) ; header ( &quot;Content-Type: text / html; charset = Shift_JIS&quot;);
?&gt; ? &quot;
&lt; html &gt; &lt;Html&gt;
&lt; head &gt;&lt; title &gt; Shift_JIS test &lt;/ title &gt;&lt;/ head &gt; &lt;Head&gt; &lt;title&gt; Shift_JIS test &lt;/ title&gt; &lt;/ head&gt;
&lt; body &gt; &lt;Body&gt;
&lt; p &gt;&lt; a &lt;P&gt; &lt;a   title = &quot; &lt;?php echo htmlspecialchars ( $ _GET [ &#039; a1 &#039; ] , ENT_QUOTES, &#039; SJIS &#039; ) ?&gt; &quot; title = &quot;&lt;? php echo htmlspecialchars ($ _GET [ &#039;a1&#039;], ENT_QUOTES, &#039;SJIS&#039;)?&gt;&quot;   href = &quot; &lt;?php echo htmlspecialchars ( $ _GET [ &#039; a2 &#039; ] , ENT_QUOTES, &#039; SJIS &#039; ) ?&gt; &quot; &gt; test &lt;/ a &gt;&lt;/ p &gt; href = &quot;&lt;? php echo htmlspecialchars ($ _GET [ &#039;a2&#039;], ENT_QUOTES, &#039;SJIS&#039;)?&gt;&quot;&gt; test &lt;/ a&gt; &lt;/ p&gt;
&lt;/ body &gt; &lt;/ Body&gt;
&lt;/ html &gt; &lt;/ Html&gt;
