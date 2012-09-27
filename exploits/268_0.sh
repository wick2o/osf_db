#!/bin/ksh
L=3000
STEP=34
MAX=16000
while [ $L -lt $MAX ]
do
./a.out $L
L=`expr $L + $STEP`
done
