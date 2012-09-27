#include <unistd.h>
#include <err.h>
#include <errno.h>
#include <fcntl.h>
#include <string.h>
#include <sys/stat.h>

int main()
{
unlink("afifo");

if (mkfifo("afifo", 0666) == -1) {
errx(1, "%s: %s", "mkfifo", strerror(errno));
}

truncate("afifo", 16000);

return 0;
}
