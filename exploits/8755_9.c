/*
 *  mschap.c    MS-CHAP module
 *
 *  Jay Miller  jaymiller@socket.net
 *
 */

#include	<stdio.h>
#include	<stdlib.h>
#include    	<string.h>
#include	"des.h"		// des algorithm for MS-CHAP

//#void		md4_calc(u_char *, u_char *, u_int);

/* 
 *  chars_out is just a debugging tool.  Outputs a string
 *  as a series of hex numbers
 */
void chars_out(char * szLabel, char * szChars, int len) {
    u_char * ptchar;
    int i;

    printf ("%s: ", szLabel);
    for (ptchar = szChars, i = 0; i < len; ptchar++, i++) {
        printf("%02X ", *ptchar);
    }
    printf ("\n\n");
}
        

/* 
 *  parity_key takes a 7-byte string in szIn and returns an
 *  8-byte string in szOut.  It inserts a 1 into every 8th
 *  bit.  DES just strips these back out
 */
void parity_key(char * szOut, char * szIn) {
    int i;
    unsigned char cNext = 0;
    unsigned char cWorking = 0;
    
    for (i = 0; i < 7; i++) {
        /* Shift operator works in place.  Copy the char out */
        cWorking = szIn[i];
        szOut[i] = (cWorking >> i) | cNext | 1;
        cWorking = szIn[i];
        cNext = (cWorking << (7 - i));
    }
    szOut[i] = cNext | 1;
}

/* 
 *  des_encrypt takes an 8-byte string and a 7-byte key and 
 *  returns an 8-byte DES encrypted string in szOut
 */
void des_encrypt(char * szClear, char * szKey, char * szOut) {
    char szParityKey[9];
    unsigned long ulK[16][2];
    
    parity_key(szParityKey, szKey); // Insert parity bits
    strncpy(szOut, szClear, 8);     // des encrypts in place
    deskey(ulK, (unsigned char *) szParityKey, 0);  // generate keypair
    des(ulK, szOut);  // encrypt
}

/* 
 *  challenge_response takes an 8-byte challenge string and a 21-byte
 *  hash (16-byte hash padded to 21 bytes with zeros) and returns a 
24-byte
 *  response in szResponse
 */
void challenge_response(char * szChallenge, char * szHash, char * 
szResponse) {
    des_encrypt(szChallenge, szHash, szResponse);
    des_encrypt(szChallenge, szHash + 7, szResponse + 8);
    des_encrypt(szChallenge, szHash + 14, szResponse + 16);
}


/*
 *  mschap takes an 8-byte challenge string and a plain text password (up 
to
 *  256 bytes) and returns a 24-byte response string in szResponse
 */
void mschap(char * szChallenge, char * szPassword, char * szResponse) {
    char szMD4[21];
    char szUnicodePass[513];
    char nPasswordLen;
    int i;
    
    /* initialize hash string */
    for (i = 0; i < 21; i++) {
        szMD4[i] = '\0';
    }
    
    /* Microsoft passwords are unicode.  Convert plain text password
       to unicode by inserting a zero every other byte */
    nPasswordLen = strlen(szPassword);
    for (i = 0; i < nPasswordLen; i++) {
        szUnicodePass[2 * i] = szPassword[i];
        szUnicodePass[2 * i + 1] = 0;
    }
    
    /* Encrypt plain text password to a 16-byte MD4 hash */
    md4_calc(szMD4, szUnicodePass, nPasswordLen * 2);
    chars_out("NTHASH",szMD4,21); 
    /* Calculate challenge repsonse */
    challenge_response(szChallenge, szMD4, szResponse);
}   



