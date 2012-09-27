/* obsd-crashme.c - by Marco Peereboom <marcodsl@swbell.net> */
/* December 03, 2001 */

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <signal.h>
#include <stdarg.h>
#include <syslog.h>

/* globals */
int fd[8]; /* temp pipe file descriptors */
int fd_real[4]; /* real pipe's */

static int __DEBUG__  = 0;
static int __SYSLOG__  = 0;

void enable_debug(void)
{
         __DEBUG__ = 1;
}

void disable_debug(void)
{
         __DEBUG__ = 0;
}

void enable_syslog(void)
{
         __SYSLOG__ = 1;
}

void disable_syslog(void)
{
         __SYSLOG__ = 0;
}

void s_fprintf(FILE *file, const char *fmt, ...)
{
         va_list ap;

         if (__DEBUG__) {
                 fflush(file);

                 va_start(ap, fmt);
                 vfprintf(file, fmt, ap);
                 va_end(ap);

                 fflush(file);
         }

         if (__SYSLOG__) {
                 va_start(ap, fmt);
                 vsyslog(LOG_INFO, fmt, ap);
                 va_end(ap);
         }
}

void *s_malloc(size_t size)
{
         char serr[40]; /* can not allocate more mem so lets use this
ugly beast */
         void *p;

         if (__DEBUG__ || __SYSLOG__) {
                 s_fprintf(stderr, "PID=%-5i PPID=%-5i: malloc(%i)\n",
getpid(), getppid(), size);
         }

         if ((p = malloc(size)) == NULL ) {
                 sprintf(serr,"PID=%i, Could not allocate memory",
getpid());
                 perror(serr);
                 exit(6);
         }

         return p;
}

void s_perror(const char *str)
{
         char *buf;

         if (__DEBUG__ || __SYSLOG__) {
                 s_fprintf(stderr, "PID=%-5i PPID=%-5i: perror(%s)\n",
getpid(), getppid(), str);
         }

         buf = s_malloc(11 + strlen(str)); /* PID=%-5i = 11 chars */
         sprintf(buf, "PID=%-5i %s", getpid(), str);
         perror(buf);

         free(buf);
}

void s_pipe(int *fd)
{
         if (__DEBUG__ || __SYSLOG__) {
                 s_fprintf(stderr, "PID=%-5i PPID=%-5i: pipe(%x)\n",
getpid(), getppid(), (unsigned int)fd);
         }

         if (pipe(fd) == -1)
         {
                 s_perror("Could not create pipe");
                 exit(3);
         }
}

int main(int argc, char **argv)
{
         enable_debug();
         enable_syslog();

         fprintf(stderr, "Before pipe\n");
         s_pipe(NULL); /* test if s_pipe exits */
         fprintf(stderr, "Will never reach this\n");

         return 0;
}
