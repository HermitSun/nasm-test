%include    "functions.asm"

SECTION .data
    childMsg    db  "This is the child process", 0H
    parentMsg   db  "This is the parent process", 0H

SECTION .text
    global  _start
    
_start:
    mov     eax, 2
    int     0x80
    
    cmp     eax, 0
    jz      child
    
parent:
    mov     eax, parentMsg
    call    sprintLF
    
    call    quit
    
child:
    mov     eax, childMsg
    call    sprintLF
    
    call    quit