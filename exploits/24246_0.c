#include <sys/io.h>

       int main(int argc, char **argv) {
       iopl(3);
       outw(0x5292, 0x24c);
       outw(0xffff, 0x245);(a)
       outw(0x1ffb, 0x24e);
       outb(0x76, 0x241);
       outb(0x7b, 0x240);
       outw(0x79c4, 0x247);
       outw(0x59e6, 0x240);
       return 0;
                     }

(a) <- TXCNT is inserted here.


