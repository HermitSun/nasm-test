%include    "functions.asm"

SECTION .data
    command     db  "/bin/echo", 0H
    arg1        db  "Hello World!", 0H
    arguments   dd  command
                dd  arg1
                dd  0H
    environment dd  0H
    
SECTION .text
    global  _start
    
_start:
    mov     edx, environment
    mov     ecx, arguments
    mov     ebx, command
    mov     eax, 11
    int     0x80
    
    call    quit