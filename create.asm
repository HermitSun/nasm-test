%include    "functions.asm"

SECTION .data
    filename    db  "readme.txt", 0H
    contents    db  "Hello World!", 0H
    
SECTION .text
    global  _start
    
_start:
    mov     ecx, 0777
    mov     ebx, filename
    mov     eax, 8
    int     0x80
    
    mov     edx, 12
    mov     ecx, contents
    mov     ebx, eax
    mov     eax, 4
    int     0x80
    
    mov     ecx, 0
    mov     ebx, filename
    mov     eax, 5
    int     0x80
    
    call    iprintLF
    call    quit