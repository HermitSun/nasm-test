%include        "functions.asm"

SECTION .data
    msg1 db "Hello, brave new world!", 0x0A, 0x00
    msg2 db "This is how we recycle in NASM.", 0x0A, 0x00

SECTION .text
    global _start

_start:
    mov     eax, msg1
    call    sprint

    mov     eax, msg2
    call    sprint

    call    quit
