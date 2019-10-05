%include    "functions.asm"

SECTION     .data
    msg     db      "Seconds since Jan 01 1970: ", 0H

SECTION     .text
    global  _start
    
_start:
    mov     eax, msg
    call    sprint
    
    mov     eax, 13
    int     0x80
    
    call    iprintLF
    call    quit