<?


$user_passwords = array (

       "$admin_username" => "$admin_password"  );

// This is the page to show when the user has been logged out
$logout_page = "$siteurl";

// Page with login form
$login_page = "login.php";

// Page to show if the user enters an invalid login name or password
$invalidlogin_page = "invalidlogin.php";


//DON'T EDIT ANYTHING BELOW THIS!!!

if ($action == "logout")
{
       Setcookie("logincookie[pwd]","",time() -86400);
       Setcookie("logincookie[user]","",time() - 86400);
       include($logout_page);
       exit;
}
else if ($action == "login")
{
       if (($loginname == "") || ($password == ""))
       {
               include($invalidlogin_page);
               exit;
       }
       else if (strcmp($user_passwords[$loginname],$password) == 0)
       {
               Setcookie("logincookie[pwd]",$password,time() + 86400);
               Setcookie("logincookie[user]",$loginname,time() + 86400);
       }
       else
       {
               include($invalidlogin_page);
               exit;
       }
}
else
{
       if (($logincookie[pwd] == "") || ($logincookie[user] == ""))
       {
               include($login_page);
               exit;
       }
       else if
(strcmp($user_passwords[$logincookie[user]],$logincookie[pwd]) =
= 0)
       {
               Setcookie("logincookie[pwd]",$logincookie[pwd],time() +
86400);
               Setcookie("logincookie[user]",$logincookie[user],time() +
86400)
;
       }
       else
       {
               include($invalidlogin_page);
               exit;
       }
}

