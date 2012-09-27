/*Decrypt password for Sawmill admin account.

Larry W. Cashdollar
lwc@vapid.betteros.org
http://vapid.betteros.org
usage ./decrypt cyphertext

*/

#include <stdio.h>



char *alpha ="abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+~<>?:\"{}|";
char *encode="=GeKMNQS~TfUVWXY[abcygimrs\"#$&-]FLq4.@wICH2!oEn}Z%(Ovt{z";

int
main (int argc, char **argv)
{

  int x, y;
  char cypher[128];

  strncpy (cypher, argv[1], 128);

  for (x = 0; x < strlen (cypher); x++)
    {

      for (y = 0; y < strlen (encode); y++)
        if (cypher[x] == encode[y])
          printf ("%c", alpha[y]);

    }

printf("\n\"+\" could also be a space [ ]\n");

}


