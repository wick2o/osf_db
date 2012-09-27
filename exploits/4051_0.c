#include <stdio.h>
#include <unistd.h>
#include <dirent.h>

int main(void)
{
    register DIR *d;
    register const struct dirent *e;

    if (chdir("/") || chroot("/tmp") || chdir("/") ||
        (d = opendir("..")) == NULL) {
        return 1;
    }
    while ((e = readdir(d)) != NULL) {
        puts(e->d_name);
    }
    return 0;
}
