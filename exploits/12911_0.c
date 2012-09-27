#include <sys/socket.h>
#include <bluetooth/bluetooth.h>
#include <bluetooth/hci.h>
#include <bluetooth/hci_lib.h>

main()
{
        int ctl;

        /* Open HCI socket  */
        if ((ctl = socket(AF_BLUETOOTH, SOCK_RAW, -1111)) < 0)
        {
                perror("Can't open HCI socket.");
                exit(1);
        }
}
