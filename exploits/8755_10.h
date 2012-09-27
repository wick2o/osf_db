#define PW_MSCHAP_RESPONSE 131073
#define PW_MSCHAP_CHALLENGE 131083

void chars_out(char * szLabel, char * szChars, int len);
void parity_key(char * szOut, char * szIn);
void des_encrypt(char * szClear, char * szKey, char * szOut);
void challenge_response(char * szChallenge, char * szHash, char * 
szResponse);
void mschap(char * szChallenge, char * szPassword, char * szResponse);

