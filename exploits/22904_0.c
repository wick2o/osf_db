#include <netinet/in.h>
int main(int argc, char *argv[]) {
  int s;
  unsigned int optlen = 4;
  s = socket(AF_INET6, SOCK_STREAM, IPPROTO_TCP);
  setsockopt(s, IPPROTO_IPV6, 6, (void *)NULL, 0);
  getsockopt(s, IPPROTO_IPV6, 59, (void *)NULL, &optlen);
  return 0;
}

