static ascii2bin(short x)
{
  if (x>='0' && x<'A')
    return x-'0';
  if (x>='A' && x<'a')
    return (x-'A')+9; 
  return (x-'a')+26+9;
} 
char bits[77];

char *quncrypt(char *pw)
{
  static char newpw[14];
  int i; 
  int j,rot;
  int bit,ofs;
  char salt[2];
  int temp;
  
  salt[0]=*pw++;
  salt[1]=*pw++;
  for (i=0;i<72;i++)
    bits[i]=0;
  for (i=0;i<12;i++)  
    newpw[i]=ascii2bin(pw[i]);
  newpw[13]=0;
  rot=(salt[1]*4-salt[0])%128;  /* here's all the salt
does.                                  A rotation */
  for (i=0;i<12;i++)
  {
    for (j=0;j<6;j++)
    {
      bit=newpw[i]&(1<<j);  /* move password into bit array */
      bits[i*6+j]=bit?1:0;
    } 
  }
  while (rot--)  /* do the big rotate */
  {
    bits[66]=bits[0];
    for (i=0;i<=65;i++)
      bits[i]=bits[i+1];
  }
    
  for (i=0;i<8;i++)  
  { 
    newpw[i]=0;
    for (j=0;j<7;j++)
    {                                  
      bit=bits[i+j*8];
      newpw[i]|=(bit<<j);  /* and compile the bit array back */  
    }
  }   
  newpw[8]=0;
  return newpw;
}   

