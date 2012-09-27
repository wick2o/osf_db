int main(void)
    {
    	unsigned char buf[4] = { 0, 0, 0, 0 };
    	int len;
    	int sock;
    	sock = socket(33, 2, 2);
    	getsockopt(sock, 1, SO_BSDCOMPAT, &buf, &len);
    	printf("%x%x%x%x\n", buf[0], buf[1], buf[2], buf[3]);
    	close(sock);
    }
