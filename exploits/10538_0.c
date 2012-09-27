  #include <sys/time.h>
  #include <signal.h>
  #include <unistd.h>
  
  static void Handler(int ignore)
  {
   char fpubuf[108];
   __asm__ __volatile__ ("fsave %0\n" : : "m"(fpubuf));
   write(2, "*", 1);
   __asm__ __volatile__ ("frstor %0\n" : : "m"(fpubuf));
  }
  
  int main(int argc, char *argv[])
  {
   struct itimerval spec;
   signal(SIGALRM, Handler);
   spec.it_interval.tv_sec=0;
   spec.it_interval.tv_usec=100;
   spec.it_value.tv_sec=0;
   spec.it_value.tv_usec=100;
   setitimer(ITIMER_REAL, &spec, NULL);
   while(1)
    write(1, ".", 1);
  
   return 0;
  }