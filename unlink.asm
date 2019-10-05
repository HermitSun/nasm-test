%include    "functions.asm"

SECTION     .data
    filename    db  "readme.txt", 0H

SECTION     .text
    global  _start
    
_start:
    mov     ebx, filename
    mov     eax, 10
    int     0x80
    
    call    quit