org 0x7C00
mov ax,cs
mov es,ax
call    DispStr
jmp $

DispStr:
    mov bp,BootMessage
    mov cx,10
    mov ax,0x1301
    mov bx,0x000C
    mov dx,0x0000
    int 10H
    ret
BootMessage:        db "Hello, OS!"

times   510-($-$$)  db 0
dw  0xAA55
