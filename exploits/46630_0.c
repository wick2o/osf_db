#include <unistd.h>
 #include <sys/epoll.h>
 int main(void) {
     int e1, e2, p[2];
     struct epoll_event evt = {
         .events = EPOLLIN
     };
     e1 = epoll_create(1);
     e2 = epoll_create(2);
     pipe(p);

     epoll_ctl(e2, EPOLL_CTL_ADD, e1, &evt);
     epoll_ctl(e1, EPOLL_CTL_ADD, p[0], &evt);
     write(p[1], p, sizeof p);
     epoll_ctl(e1, EPOLL_CTL_ADD, e2, &evt);

     return 0;
 }