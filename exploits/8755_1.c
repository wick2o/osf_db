// chaptest.c

#include	<stdio.h>
#include	<stdlib.h>
#include    	<string.h>
#include	"des.h"		// des algorithm for MS-CHAP
#include        "mschap.h"
#include        "md4.h"

void		md4_calc(u_char *, u_char *, u_int);

int main(int argc, char **argv){
  char *challenge = "\xB5\x48\x40\xFE\x97\x66\x57\x2D";
  char *password = "m@st@hp1mp";
  char challengeResponse[25];
  
  memset(challengeResponse,0x0,25);

  mschap(challenge,password,challengeResponse);
  
  chars_out("Challenge",challenge,8);
  printf("Password: %s\n\n",password);
  chars_out("ChallengeResponse",challengeResponse,24);
  
  return 0;
}





