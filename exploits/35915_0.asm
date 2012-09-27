; nasm -f elf vmhostreboot.asm
; gcc vmhostreboot.o -o vmhostreboot

BITS 32
SECTION .text
GLOBAL main

main:
    sysenter
    ret