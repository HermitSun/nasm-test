%include    "functions.asm"

SECTION .text
    global  _start
    
_start:
    pop     ecx         ; number of args
    pop     edx         ; program's name(discarded)
    dec     ecx         ; -1, cause dicarded program's name
    xor     edx, edx    ; initialize edx
    
nextArg:
    cmp     ecx, 0H
    jz      noMoreArgs
    pop     eax
    call    atoi
    add     edx, eax    ; sum stored in edx
    dec     ecx
    jmp     nextArg
    
noMoreArgs:
    mov     eax, edx
    call    iprintLF
    
    call    quit