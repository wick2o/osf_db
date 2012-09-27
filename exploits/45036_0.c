#include <sys/inotify.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
        int fds[2];

        /* Circumvent max inotify instances limit */
        while (pipe(fds) != -1)
                ;

        while (1)
                inotify_init();

        return 0;
}

