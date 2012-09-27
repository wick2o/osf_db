#include <pthread.h>
#include <semaphore.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "des.h"
#include "mschap.h"
#include "md4.h"

#define NUM_HASHES 10000

//Enter challenge response here
char *challengeResponse = "";
//Enter challenge here
char *challenge  = "";
pthread_mutex_t mut;
long filesize;
FILE *hashes;
int success;

void *brute(); // reads nt hash from file
char atoh(char hibits,char lowbits); // transforms ascii representation of 
hex value
int checkCR(int hibits,int lowbits,int CRoffset,int keybytes,char 
NTHASH[48]); // checks nt hash against the challenge response

int main(int argc, char **argv){
  long int i,fileno,threads;
  pthread_t t_ids[200];
  char *usage="\n\n./bfleapkey threads filename1 [filename2] 
[etc...]\n\n";
  char hashFile[256];
  
  if(argc<3){
    printf("%s",usage);
    goto STOP;
  }else{
    success=0;
    threads=strtol(argv[1],NULL,10);
    if((threads>199)||(threads<1)){
      printf("%s\n\n200 > threads > 0\n\n",usage);
      goto STOP;}
    for(fileno=2;(fileno<argc)&&(!success);fileno++){ // loop through all 
files
      memset(hashFile,0x0,256);
      strncpy(hashFile,argv[fileno],255);
      if(NULL==(hashes = fopen(hashFile,"r"))){
	printf("\n\nError opening fileno %d\n\n",(fileno-2));
	goto FILEDONE;}
      fseek(hashes,0,SEEK_END);
      filesize=ftell(hashes);
      fseek(hashes,0,SEEK_SET);
    
      printf("\nBruteforcing NT Hash\n\n");
      chars_out("Challenge",challenge,8);
      chars_out("Challenge Response",challengeResponse,24);
      printf("\n\nStarting with %s\n\n",argv[fileno]);
      
      pthread_mutex_init(&mut,NULL);
      for(i=0;i<threads;i++){
	pthread_create(&t_ids[i],NULL,brute,NULL);
	//printf("\n\nThread #%d started\n\n",i);
      }
      for(i=0;i<threads;i++){
	//printf("\n\nWaiting for Thread #%d end\n\n",i);
	pthread_join(t_ids[i],NULL);
	//printf("\n\nThread #%d ended\n\n",i);
      }
      printf("\n\nDone with %s\n\n",argv[fileno]);
    FILEDONE:
      fclose(hashes);
      pthread_mutex_destroy(&mut);
    }
  }
  STOP:
  return 0;
}

void *brute(){
  char NTHASH[NUM_HASHES][33];
  int i;
  long filepos=0;
  
  while(filepos<(filesize-1)){
    for(i=0;i<NUM_HASHES;i++){ // read a chunk of hashes from file
      memset(NTHASH[i],0x0,33);
      pthread_mutex_lock(&mut);
      if(success){
	pthread_mutex_unlock(&mut);
	goto BAIL;}
      fread(NTHASH[i],1,32,hashes);
      if((filesize-2)>(filepos=ftell(hashes))){
	fseek(hashes,SEEK_CUR,1); // move file pointer past delimeter 
	pthread_mutex_unlock(&mut);
      }else if(!i){ // leave if no hashes to check
	pthread_mutex_unlock(&mut);
	goto BAIL;
      }else
	pthread_mutex_unlock(&mut);
    }
    for(;i>=0;i--){ // grind on the chunk of hashes
      if(checkCR(28,29,16,2,NTHASH[i])){
	printf("\nNTHASH MATCH: %s\n",NTHASH[i]);
	pthread_mutex_lock(&mut);
	success=1;
	pthread_mutex_unlock(&mut);
	goto BAIL;}
    }
  }
 BAIL:
  pthread_exit(NULL);
}

// nt hash ascii map
// 00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF
// 01234567890123456789012345678901234567890123456
// 0         1         2         3         4

// nt hash ascii map
// 00112233445566778899AABBCCDDEEFF
// 01234567890123456789012345678901234567890123456
// 0         1         2         3         4


int checkCR(int hibits,int lowbits,int CRoffset,int keybytes,char 
NTHASH[48]){
  char rxDES[8]; // Challenge Response bytes
  char txDES[8]; // NT hash bytes
  int k;
  memset(rxDES,0x0,8);
  memset(txDES,0x0,8);
 
  // initialize des key
  for(k=0;k<keybytes;hibits+=2,lowbits+=2,k++)
      txDES[k]=atoh(NTHASH[hibits],NTHASH[lowbits]);
  
  des_encrypt(challenge,txDES,rxDES); 
  
  if(0==bcmp(rxDES,challengeResponse+CRoffset,8)){
    chars_out("FOUND 8 BYTE MATCH",rxDES,8);
    if(hibits>42) // first round was success
      return checkCR(14,15,8,7,NTHASH); // go to second round
    else if(hibits>21) //second round was success
      return checkCR(0,1,0,7,NTHASH); // go to last round
    else // third round was success
      return 1; // return success
  }else 
    return 0; // return no success
}

char atoh(char a,char b){ // converts "AB" to "\xAB"
  char result=0;
  if((a>=48)&&(a<=90)&&(b>=48)&&(b<=90)){ // 48='0' 90='Z'
    if(a<58) // a is '0' through '9'
      result = (a - 48) << 4;
    else // a is 'A' through 'F'
      result = (a - 55) << 4;
    if(b<58) // b is '0' through '9'
      result |= b - 48;
    else // b is 'A' through 'F'
      result |= b - 55;
  }
  return result;
}
      

