SECTION .data
msg     db      "Hello, brave new world!", 0x0A

SECTION .text
global _start

_start:
    mov edx, 13
    mov ecx, msg
    mov ebx, 1
    mov eax, 4
    int 0x80

    mov ebx, 0
    mov eax, 1
    int 0x80

