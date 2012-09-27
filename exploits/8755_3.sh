#!/bin/bash
gcc -O3 -c deskey.c
gcc -O3 -c desport.c
gcc -O3 -c md4.c
gcc -O3 -c mschap.c
gcc -O3 -lpthread -o bfnthash bfnthash.c deskey.o desport.o md4.o mschap.o
gcc -O3 -o chaptest chaptest.c deskey.o desport.o md4.o mschap.o

