%include "functions.asm"

SECTION .text
    global _start
    
_start:
    mov     ecx, 0

nextNumber:
    inc     ecx         ; ++ecx
    
    mov     eax, ecx
    add     eax, 0x30   ; convert num to ASCII
    push    eax
    mov     eax, esp
    call    sprintLF
 
    pop     eax
    cmp     ecx, 10
    jne     nextNumber

    call    quit