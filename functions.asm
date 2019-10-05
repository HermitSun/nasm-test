;------------
; int atoi(char* eax)
; ascii char to integer function
atoi:
    push    edx
    
    mov     dl, byte[eax]
    xor     eax, eax
    mov     al, dl
    sub     eax, 0x30           ; parse *eax to int
    
    pop     edx
    ret

;------------
; int stoi(int number)
; ascii string to integer function
stoi:
    push    ebx
    push    ecx
    push    edx
    push    esi
    mov     esi, eax        ; move number's address to esi
    mov     eax, 0
    mov     ecx, 0
    
.multiplyLoop:
    xor     ebx, ebx        ; initialize ebx = 0
    mov     bl, [esi+ecx]   ; *(esi + ecx)
    cmp     bl, 0x30        ; if (bl < '0')
    jl      .finished       
    cmp     bl, 0x39        ; if (bl > '9')
    jg      .finished
    
    sub     bl, 0x30        ; convert to number
    add     eax, ebx
    mov     ebx, 10         ; eax *= 10
    mul     ebx
    inc     ecx             ; ++ecx
    jmp     .multiplyLoop

.finished:
    mov     ebx, 10         ; eax /= 10
    div     ebx
    pop     esi
    pop     edx
    pop     ecx
    pop     ebx
    ret

;------------
; void iprint(int number)
; integer print function (itoa)
iprint:
    push    eax
    push    ecx
    push    edx
    push    esi
    mov     ecx, 0

.divideLoop:
    inc     ecx
    mov     edx, 0
    mov     esi, 10         ; divisor (base 10)
    idiv    esi
    add     edx, 0x30       ; convert remainder to ASCII
    push    edx
    cmp     eax, 0
    jnz     .divideLoop

.printLoop:
    dec     ecx
    mov     eax, esp        ; number's address
    call    sprint
    pop     eax             ; next number
    cmp     ecx, 0
    jnz     .printLoop
    
    pop     esi
    pop     edx
    pop     ecx
    pop     eax
    ret

;------------
; void iprintLF(int number)
; integer printing function with line feed (itoa)
iprintLF:
    call    iprint
    
    push    eax
    mov     eax, 0x0A       ; '\n'
    push    eax
    mov     eax, esp        ; the address of '\n'
    call    sprint
    
    pop     eax             ; clear stack
    pop     eax
    ret

;------------
; int slen(const char* eax)
; string length calculation function
slen:
    push    ebx
    mov     ebx, eax        ; use ebx as *begin

.nextchar:
    cmp     byte[eax], 0
    jz      .finished
    inc     eax
    jmp     .nextchar

.finished:
    sub     eax, ebx        ; eax -= ebx
    pop     ebx
    ret
    
;------------
; void cprint(const char*)
; print current char
cprint:
    push    eax
    
    mov     edx, 1
    mov     ecx, eax
    mov     ebx, 1              ; STDOUT
    mov     eax, 4
    int     0x80                ; print char
    
    pop     eax
    ret

;------------
; void sprint(const char* eax)
; string printing function
sprint:
    push    edx
    push    ecx
    push    ebx
    push    eax
    call    slen
    
    mov     edx, eax
    pop     eax
    
    mov     ecx, eax
    mov     ebx, 1
    mov     eax, 4
    int     0x80

    pop     ebx
    pop     ecx
    pop     edx
    ret
    
;------------
; void sprintLF(const char* eax)
; string printing with line feed function
sprintLF:
    call    sprint
    
    push    eax
    mov     eax, 0x0A   ; '\n'
    push    eax
    mov     eax, esp    ; pass '\n' by esp, cause we need an address
    call    sprint
    pop     eax         ; pop '\n'
    pop     eax
    ret

;------------
; void exit()
; exit program and restore resources
quit:
    mov     ebx, 0
    mov     eax, 1
    int     0x80
    ret


