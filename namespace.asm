%include    "functions.asm"

SECTION .data
    msg1    db  "Jumping to finished label.", 0H
    msg2    db  "Inside subroutine number: ", 0H
    msg3    db  "Inside subroutine 'finished'.", 0H

SECTION .text
    global  _start
    
_start:

subroutine1:
    mov     eax, msg1
    call    sprintLF
    jmp     .finished
    
.finished:
    mov     eax, msg2
    call    sprint
    mov     eax, 1
    call    iprintLF

subroutine2:
    mov     eax, msg1
    call    sprintLF
    jmp     .finished

.finished:
    mov     eax, msg2
    call    sprint
    mov     eax, 2
    call    iprintLF
    
    mov     eax, msg1
    call    sprintLF
    jmp     finished

finished:
    mov     eax, msg3
    call    sprintLF
    call    quit