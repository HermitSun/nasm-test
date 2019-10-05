%include "functions.asm"

SECTION .data
    fizz    db  "Fizz", 0H
    buzz    db  "Buzz", 0H

SECTION .text
    global  _start
    
_start:
    mov     ecx, ecx         ; ecx = 0

nextNum:
    inc     ecx              ; ++ecx
    cmp     ecx, 100
    jg      .finished        ; while (ecx <= 100)
    mov     eax, ecx
    mov     ebx, 15
    xor     edx, edx         ; reset edx
    idiv    ebx
    cmp     edx, 0          
    je      .fizzbuzz        ; if(ecx % 15 == 0)
    mov     eax, ecx
    mov     ebx, 3
    xor     edx, edx         ; reset edx
    idiv    ebx
    cmp     edx, 0          
    je      .fizz            ; if(ecx % 3 == 0)
    mov     eax, ecx
    mov     ebx, 5
    xor     edx, edx         ; reset edx
    idiv    ebx
    cmp     edx, 0          
    je      .buzz            ; if(ecx % 5 == 0)
    mov     eax, ecx
    call    iprintLF
    jmp     nextNum          ; else
    
.fizzbuzz:
    mov     eax, fizz
    call    sprint
    mov     eax, buzz
    call    sprintLF        ; print fizzbuzz
    jmp     nextNum
    
.fizz:
    mov     eax, fizz       ; print fizz
    call    sprintLF
    jmp     nextNum

.buzz:
    mov     eax, buzz       ; print buzz
    call    sprintLF
    jmp     nextNum
    
.finished:
    call    quit