%include    "functions.asm"

SECTION .data
    filename        db      "readme.txt", 0H
    contents        db      "Hello World!", 0H

SECTION .bss
    fileContents    resb    255
    
SECTION .text
    global  _start

_start:
    mov     ecx, 0777
    mov     edx, filename
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
    
    mov     edx, 12
    mov     ecx, fileContents
    mov     ebx, eax
    mov     eax, 3
    int     0x80
    
    mov     eax, fileContents
    call    sprintLF
    
    mov     ebx, ebx
    mov     eax, 6
    int     0x80
    
    call    quit