#include <sched.h>
#include <signal.h>
#include <stdlib.h>
#include <unistd.h>

static int the_child(void* arg) {
  sleep(1);
  _exit(2);
}

int main(int argc, const char* argv[]) {
  int ret = fork();
  if (ret < 0)
  {
    perror("fork");
    _exit(1);
  }
  else if (ret > 0)
  {
    for (;;);
  }
  setgid(99);
  setuid(65534);
  {
    int status;
    char* stack = malloc(4096);
    int flags = SIGKILL | CLONE_PARENT;
    int child = clone(the_child, stack + 4096, flags, NULL);
  }
  _exit(100);
}
