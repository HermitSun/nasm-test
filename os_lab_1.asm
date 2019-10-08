%include    "functions.asm"

SECTION .data
    ; constants
    NUM_LENGTH      equ 20  ; max number length
    NUM_STR_LENGTH  equ 21  ; max number string length (40 + '\0')
    P_ACTUAL_LENGTH equ 40  ; actual product length
    PRODUCT_LENGTH  equ 41  ; max product length
    INPUT_LENGTH    equ 45  ; max length = 2 * (1 + 21) + ' ' = 45
    ; variables
    title       db  "OS_LAB_1  sample big number add & mul", 0H
    prompt      db  "Please input x and y: ", 0H
    x           db  "000000000000000000000", 0H
    y           db  "000000000000000000000", 0H
    xIsNegative db  0
    yIsNegative db  0   
    sum         db  "000000000000000000000", 0H         
    productTmp  db  "00000000000000000000000000000000000000000", 0H ; save temp product
    product     db  "00000000000000000000000000000000000000000", 0H
    productSum  db  "00000000000000000000000000000000000000000", 0H ; save product + productTmp
    ;input       db  "99999999999999999999 100000000000000000000", 0H  

SECTION .bss
    input   resb    INPUT_LENGTH

SECTION .text
    global  _start

_start:
    mov     eax, title
    call    sprintLF            ; print title
    mov     eax, prompt
    call    sprint              ; print prompt
    
    mov     edx, INPUT_LENGTH
    mov     ecx, input
    mov     ebx, 0              ; STDIN
    mov     eax, 3              ; sys_read
    int     0x80                ; read input
    
    jmp     split               ; call split()
    
splitFinished:
    pop     esi                 ; restore esi
    pop     eax                 ; restore str
    
adder:    
    mov     esi, NUM_LENGTH     ; pointer=20
    mov     edi, NUM_STR_LENGTH ; counter=21
    mov     ecx, 0              ; carry=0
   ;call    sprintLF            ; TODO: eax will be 0x15... but why? 
adderLoop:
    cmp     edi, 0
    je      addFinished         ; while(pointer>0)
    
    mov     eax, x         
    add     eax, esi            ; eax=x+pointer
    call    atoi                ; parse *eax to int
    push    eax                 ; store eax
    
    mov     eax, y           
    add     eax, esi            ; eax=y+pointer
    mov     dl, byte[eax]
    xor     eax, eax
    mov     al, dl
    sub     eax, 0x30           ; parse *eax to int
    
    pop     ebx                 ; pop eax to ebx
    add     eax, ebx
    add     eax, ecx            ; *eax + *ebx + carry
    
    xor     edx, edx            ; clear edx
    mov     ecx, 10
    div     ecx
    mov     ecx, eax            ; carry
    
    mov     ebx, sum
    add     ebx, esi            
    add     edx, 0x30           ; itoa
    mov     byte[ebx], dl       ; save add result
    
    dec     esi                 ; --pointer
    dec     edi                 ; --counter
    jmp     adderLoop
    
addFinished:
    mov     eax, sum
    call    sprintWithoutStartZero
    
    mov     eax, NUM_STR_LENGTH ; YCount
    mov     ecx, 0              ; carry = 0
multiply:
    cmp     eax, 0
    je      multiplyFinished    ; while(YCount > 0)
    mov     ebx, NUM_STR_LENGTH ; XCount = 20
    mov     esi, y              
    add     esi, eax            
    dec     esi                 ; int currentY = (Y + YCount - 1)          
    
    mov     edi, productTmp
    add     edi, NUM_LENGTH
    dec     edi
    add     edi, eax            ; char* pPoint = (productTmp + NUM_LENGTH + YCount - 1)

innerMultiplyLoop:
    cmp     ebx, 0              ; while(XCount > 0)
    je      innerMultiplyLoopFinished
    mov     edx, x
    add     edx, ebx
    dec     edx                 ; int currentX = (X + XCount - 1)
    
    push    eax
    push    ebx
    xor     ebx, ebx
    mov     bl, byte[edx]
    sub     ebx, 0x30           ; actual currentX(int)
    mov     eax, ebx
    xor     ebx, ebx
    mov     bl, byte[esi]
    sub     ebx, 0x30           ; actual currentY(int)
    mul     ebx
    add     eax, ecx            ; int product = currentX * currentY + carry;
    pop     ebx
    
    push    edx
    xor     edx, edx            ; clear edx
    push    ebx
    mov     ebx, 10
    div     ebx                 
    mov     ecx, eax            ; carry = product / 10
    
    add     edx, 0x30
    mov     byte[edi], dl       ; *pPoint = product % 10 + '0'
    
    pop     ebx
    pop     edx
    pop     eax                 ; restore
    
    dec     edi                 ; --pPoint
    dec     ebx                 ; --XCount
    
multiplyAdder:
    push    esi
    push    edi
    push    eax
    push    ebx
    push    ecx
    push    edx
    
    mov     esi, P_ACTUAL_LENGTH; pointer=40
    mov     edi, PRODUCT_LENGTH ; counter=41
    mov     ecx, 0              ; carry=0
.adderLoop:
    cmp     edi, 0
    je      .addFinished        ; while(pointer>0)
    
    mov     eax, productTmp         
    add     eax, esi            ; eax=x+pointer
    call    atoi                ; parse *eax to int
    push    eax                 ; store eax
    
    mov     eax, product           
    add     eax, esi            ; eax=y+pointer
    mov     dl, byte[eax]
    xor     eax, eax
    mov     al, dl
    sub     eax, 0x30           ; parse *eax to int
    
    pop     ebx                 ; pop eax to ebx
    add     eax, ebx
    add     eax, ecx            ; *eax + *ebx + carry
    
    xor     edx, edx            ; clear edx
    mov     ecx, 10
    div     ecx
    mov     ecx, eax            ; carry
    
    mov     ebx, productSum    
    add     ebx, esi            
    add     edx, 0x30           ; itoa
    mov     byte[ebx], dl       ; save add result
    
    dec     esi                 ; --pointer
    dec     edi                 ; --counter
    jmp     .adderLoop
    
.addFinished:
    pop     edx
    pop     ecx
    pop     ebx
    pop     eax
    pop     edi
    pop     esi

;------------
; void copyToProduct()
; copy productSum to product
copyToProduct:
    push    eax
    push    ebx
    push    ecx
    mov     ecx, PRODUCT_LENGTH; counter=40
.nextchar:
    cmp     ecx, 0
    jl      .finished           ; while(count>=0)
    mov     eax, productSum
    mov     bl, byte[eax + ecx]
    mov     eax, product
    mov     byte[eax + ecx], bl
    dec     ecx                 ; --counter
    jmp     .nextchar
.finished:
    pop     ecx
    pop     ebx
    pop     eax
     
;------------
; void resetProduct()
; reset productTmp & productSum
resetProduct:
    push    eax
    push    ebx
    push    ecx
    mov     ecx, P_ACTUAL_LENGTH; counter=40
.nextchar:
    cmp     ecx, 0
    je      .finished
    mov     eax, productTmp
    mov     ebx, productSum
    mov     byte[eax + ecx], '0'
    mov     byte[ebx + ecx], '0'
    dec     ecx
    jmp     .nextchar
.finished:
    pop     ecx
    pop     ebx
    pop     eax

    jmp     innerMultiplyLoop
    
innerMultiplyLoopFinished:
    dec     eax                 ; --YCount
    jmp     multiply
    
multiplyFinished:
    xor     eax, eax
    mov     al, byte[xIsNegative]
    xor     ebx, ebx
    mov     bl, byte[yIsNegative]
    xor     al, bl    
    cmp     eax, 0              ; if(xIsNegative ^ yIsNegative)
    je     .finished
    mov     eax, '-'
    push    eax
    mov     eax, esp
    call    sprint              ; print '-'
    pop     eax
.finished:
    mov     eax, product
    call    sprintWithoutStartZero

exit:
    call    quit

;------------
; void split()
; split input to x,y
split:
    mov     eax, input
    cmp     byte[eax], '-'      ; if(*str=='-')
    jne     .xIsNotNegative
    mov     byte[xIsNegative], 1; xIsNegative = true
    inc     eax                 ; ++str
.xIsNotNegative:
    mov     ebx, eax            ; eax is string's address
    xor     ecx, ecx            ; count=0    
.nextXChar:
    cmp     byte[eax], 0x20     ; while(*str!=' ')
    je      .dealX
    inc     eax                 ; ++str
    inc     ecx                 ; ++count
    jmp     .nextXChar
    
.dealX:
    push    eax                 ; save eax
    push    esi                 ; save esi
    dec     eax                 ; --str (point to the last char of the first valid part)
    mov     esi, NUM_LENGTH     ; pointer=20 (point to the last char of x)
.dealXLoop:
    cmp     ecx, 0              ; while(count>0)
    je      .split             
    mov     dl, byte[eax]
    mov     byte[x + esi], dl   ; *(x+pointer)=*str
    dec     esi                 ; --pointer
    dec     ecx                 ; --count
    dec     eax                 ; --str
    jmp     .dealXLoop
    
.split:
    pop     esi                 ; restore esi
    pop     eax                 ; restore str
    xor     ecx, ecx            ; count=0
    inc     eax                 ; ++str
    cmp     byte[eax], '-'      ; if(*str=='-')
    jne     .nextYChar
    mov     byte[yIsNegative], 1; yIsNegative = true
    inc     eax                 ; ++str
.nextYChar:
    cmp     byte[eax], 0H       ; while(*str!='\0')
    je      .dealY
    inc     eax                 ; ++str
    inc     ecx                 ; ++count
    jmp     .nextYChar
    
.dealY:
    push    eax                 ; save eax
    push    esi                 ; save esi
    dec     eax                 ; --str (point to the last char of the second valid part)
    mov     esi, NUM_LENGTH + 1 ; pointer=21 (point to the last char of y, plus an '\n')
.dealYLoop:    
    cmp     ecx, 0              ; while(count>0)
    je      splitFinished
    mov     dl, byte[eax]
    mov     byte[y + esi], dl   ; *(y+pointer)=*str
    dec     esi                 ; --pointer
    dec     ecx                 ; --count
    dec     eax                 ; --str
    jmp     .dealYLoop

;------------
; void sprintWithoutStartZero(const char* eax)
; print a string without start zero
sprintWithoutStartZero:
    push    esi
    push    ecx
    
    mov     ecx, 0x30           
    push    ecx
    mov     ecx, esp            ; *lastChar='0'
    xor     esi, esi            ; hasPrinted=false
    
.nextchar:
    cmp     byte[eax], 0H             
    je      .finished           ; while(*str!='\0')
    cmp     byte[eax], 0x30     ; if(*str=='0')     
    je      .whetherContinue
.print:
    call    cprint
    mov     esi, 1              ; hasPrinted=true
    jmp     .continue           ; continue

.whetherContinue:
    cmp     byte[ecx], 0x30     ; if(*str=='0' && *lastChar!='0')
    jne     .print              
    cmp     esi, 0              ; if(*str=='0' && *lastChar=='0' && !hasPrinted)
    jne     .print
.continue:
    mov     ecx, eax            ; lastChar=str
    inc     eax                 ; str++
    jmp     .nextchar

.finished:
    cmp     esi, 0              ; if printed nothing
    jne     .done
    mov     eax, '0'
    push    eax
    mov     eax, esp
    call    sprint              ; print '0'
    pop     eax
.done:
    mov     eax, 0x0A
    push    eax
    mov     eax, esp
    call    sprint              ; print '\n'
    pop     eax
    
    pop     ecx                 ; pop '0'
    pop     ecx                 ; restore ecx
    pop     esi
    ret