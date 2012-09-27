// Credit to: K.C. Wong
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <fcntl.h>

#define SIZE 4075

void out_err()
{
        char buffer[SIZE];
        int i = 0;

        for (i = 0; i < SIZE - 1; ++i)
                buffer[i] = 'a' + (char )(i % 26);

        buffer[SIZE - 1] = '\0';

//
fcntl(2, F_SETFL, fcntl(2, F_GETFL) | O_NONBLOCK);

        fprintf(stderr, "short test\n");
        fflush(stderr);

        fprintf(stderr, "test error=%s\n", buffer);
        fflush(stderr);
} // out_err()

int main(int argc, char ** argv)
{
        fprintf(stdout, "Context-Type: text/html\r\n");
        fprintf(stdout, "\r\n\r\n");
        out_err();
        fprintf(stdout, "<HTML>\n");
        fprintf(stdout, "<body>\n");
        fprintf(stdout, "<h1>hello world</h1>\n");
        fprintf(stdout, "</body>\n");
        fprintf(stdout, "</HTML>\n");
        fflush(stdout);
        exit(0);
} // main()
