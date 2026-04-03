DATA SEGMENT PARA PUBLIC 'DATA'
numtoprint DB '0000','$'   ;var to store a number as string
space db 20h               ;ascii for space 
minus db '-','$'           ;minus char
numtoprint3 DB '0000','$'  ;var to store a number as string
numtoprint4 DB '0000','$'  ;var to store a number as string
value DW 0                 ;variable to store subtraction
msg1 DB 0ah,0dh,"Choose mode: (i) Interactive or (a) Automatic.",'$'
anth DB 0ah,0dh,"Typing (a) will generate a file named (Kaprekar.txt) and you will see",'$'
anth2 DB,0ah,0dh,"the number of iterations needed for each 4 digit number to reach",'$'
anth3 DB,0ah,0dh,"Kaprekar constant (6174) or (0000).Typing (i) will enter interactive mode: ",'$'
msg2 DB 0ah, 0dh, "Starting from:$"
again DB 0ah, 0dh, "Wrong input,try again: $"
msg3 DB 0ah, 0dh, "Number of iterations:$"
newline db 0dh             ;newline for formatting
numberplace dw 10          
number dw 0             
VECTOR db 4 dup (?)        ;vector to store digits of a number
ascnr DW ?                 ;var to store asc number
desnr DW ?                 ;var to store asc number
count Dw 0                 ;var to store number of iterations
ten DB 10
fname db 'kaprekar.txt',0   ;filename
fhandle dw ?        
numtoprint2 db '0'          ;var to store count
num db 0    
msg4 DB 0ah,0dh, "Continue? (y) yes / (n) no: ",'$'
msg5 DB 0ah,0dh,"Goodbye!",'$'                  
DATA ENDS




;macro to swap 2 values
SWAP MACRO X, Y
    PUSH AX
    MOV AL, X
    MOV AH, Y
    MOV X, AH 
    MOV Y, AL
    POP AX
ENDM
;macro to clear registers
CLEAR MACRO
    XOR AX,AX
    XOR BX,BX
    XOR CX,CX
    XOR DX,DX
ENDM

; macro to build descending number from digits
 buildNumDes MACRO X
    LOCAL P1
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH SI
    
    P1:
   mov al,X
   mov ah,00
   mov bx,ax

   mov ax,desnr
   dec si
   mul numberplace
   add ax,bx
   mov desnr,AX
   LOOP P1
    POP SI
    POP CX
    POP BX
    POP AX
        ENDM
        
        
; macro to build ascending number from digits       
    buildNumAsc MACRO X
    LOCAL P2
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH SI
P2: 
   mov al,X
   mov ah,00
   mov bx,ax

   mov ax,ascnr
   inc si
   mul numberplace
   add ax,bx
   mov ascnr,AX
   LOOP P2
    POP SI
    POP CX
    POP BX
    POP AX
        ENDM    


CODE SEGMENT PARA PUBLIC 'CODE'
ASSUME CS:CODE, DS:DATA
START PROC FAR
PUSH DS
XOR AX, AX
MOV DS, AX
PUSH AX
MOV AX, DATA
MOV DS, AX
    ; display mode selection message
    input1:
    mov ah,09h
    mov dx,offset msg1
    int 21h
    
    clear
    
    ; display information about modes
    mov ah,09h
    mov dx,offset anth
    int 21h
    
    mov ah,09h
    mov dx,offset anth2
    int 21h
    
    clear
    
        mov ah,09h
    mov dx,offset anth3
    int 21h
    
    clear
    
input2: 
    ; read user input for mode selection
    mov ah,01h
    int 21h

     ; check user input for interaction or automatic mode
     ; if neither i nor a is entered, ask for input again   
    cmp al,'i'
    je loop_number_main
    cmp al, 'a'
    je auto

    invalidcharacter2:
    clear
    ; display message for invalid input
   mov ah,09h
   mov dx,offset again
   int 21h
   clear
   jmp input2
    
  ; automatic mode
    auto:
    jmp automatic
    
     ; interaction mode
    loop_number_main:
    clear
     ; label for number input
    mov ah,09h
    mov dx,offset msg2
    int 21h
    mov desnr,0
    mov ascnr,0
    mov value,0
    mov number,0
    mov cx,4
    mov count,0
    mov si,0
    ; reinitilize all numtoprint vars to 0000
    reinit3:
    mov numtoprint3[si],'0'
    inc SI
    loop reinit3
    
    mov cx,4
    mov si,0
    
    reinit4:
    mov numtoprint4[si],'0'
    inc SI
    loop reinit4
    
    mov cx,4
    mov si,0
    
    
    reinit2:
    mov numtoprint[si],'0'
    inc SI
    loop reinit2
    
    mov cx,4
    mov si,0
    
    reinit:
        mov vector[si], 0
        inc SI
        loop reinit
    mov cx,4
    mov si,0
    

  loop_read_number :
    ; read input number
   mov ah,01h
   int 21h
    ; build num and vector
    cmp al,13
    jz invalidcharacter
   sub al,48
   mov VECTOR[SI],al
   inc SI
   mov ah,00
   mov bx,AX
   ; convert to ascii
   mov ax,number
   mul numberplace
   add ax,bx
   mov number,AX
   ; check if correct input
   loop loop_read_number
   mov si,0
   mov cx,4
   check:
   cmp vector[si],9
   ja invalidcharacter
   cmp vector[si],0
   jb invalidcharacter
   inc SI
   loop check
   
   jmp numbercomplete
   
   invalidcharacter:
    clear
   mov ah,09h
   mov dx,offset again
   int 21h
   clear
   jmp loop_number_main
   
   
   ; complete number input
   numbercomplete:
    mov ax,number
    xor bx,bx
    lea bx,VECTOR
    
    ; sort the digits in ascending order
    call SORTasc
    clear   
    mov cx,4
    mov si,0
    ; build the asc number from the vector
    buildNumAsc VECTOR[si]
    clear
    mov si,3
    mov cx,4
    ; build the des number from the vector
    buildNumDes VECTOR[si]
    
    
    clear
     ; print \n
    mov ah,2
    mov dl,10
    int 21h
    ; start solving the problem
    solve:
        clear
        kaploop:
        
    clear
     ; print \n
    mov ah,2
    mov dl,10
    int 21h
    clear

    ; convert descending number to ASCII and print
    push offset numtoprint
    push desnr
    call numtoascii 
    clear
    mov ah,09h
    lea dx,numtoprint
    int 21h
    CLEAR
    
     ; print '-'
    mov ah,2
    mov dl,"-"
    int 21h
    clear
    
    ; convert ascending number to ASCII and print
    push offset numtoprint3
    push ascnr
    call numtoascii
    clear
    mov ah,09h
    lea dx,numtoprint3
    int 21h
    clear
    mov ah,2
    mov dl,61
    int 21h
    clear
    
    ; calculate and print the difference
    mov ax,desnr
    mov bx,ascnr
    sub ax,bx
    mov value,AX
    CLEAR
    push offset numtoprint4
    push value
    call numtoascii
    clear
    mov ah,09h
    lea dx,numtoprint4
    int 21h
    clear
    
    ; print newline character
    mov ah,2
    mov dl,10
    int 21h
    clear
    
    ; kaprekar routine
    mov ax,desnr
    mov bx,ascnr
    inc count
    sub ax,bx
    jz done
    cmp ax,6174
    jz done
    call buildVector
    lea dx,VECTOR
    call SORTasc
    mov cx,4
    mov si,0
    mov ascnr,0
    buildNumAsc VECTOR[SI]
    lea dx,VECTOR
    mov si,3
    mov cx,4
    mov desnr,0
    buildNumDes VECTOR[SI]
    mov cx,0
    jmp kaploop

; print the number of iterations
    done:
    mov ah,09h
    mov dx,offset msg3
    int 21h
    mov dh,00
    mov dx,count
    add dl,48
    mov ah,dl
    mov ah,02h
    int 21h
    ;again
agn:    
    clear
    lea dx,msg4
    mov ah,09h
    int 21h
    
    mov ah,01h
    int 21h
    cmp al,'y'
    je yes
    cmp al,'n'
    je no

    jmp invalid

    yes :
    clear
    jmp loop_number_main
    
    invalid:
    clear
    mov ah,09h
    lea dx,again
    int 21h
    jmp agn
    
    no:
    clear
    lea dx,msg5
    mov ah,09h
    int 21h
    ret

; finish execution
finish:
    jmp exit2


; automatic mode execution
    automatic:
    mov si,0
        clear
    ;create a new file
    mov ah,3ch
    lea dx,fname
    mov cl,0
    int 21h
    mov fhandle,AX
    clear
    ;write in file
    mov number,0
    again2:
    clear
    mov ax,number
    cmp ax,10000
    jz finish
    
     ; build the vector
    call buildVector 
    xor bx,bx
    lea bx,VECTOR
    
    ; loop for printing the numbers (0000-9999) and the 
    ; nr of iterations needed to reach Kaprekar's constant
    ; for each
    
    call SORTasc
    clear   
    mov cx,4
    mov si,0
    buildNumAsc VECTOR[si]
    clear
    mov si,3
    mov cx,4
    buildNumDes VECTOR[si]
    clear
        kaploop2:
    mov ax,desnr
    mov bx,ascnr
    inc count
    sub ax,bx
    jz done2
    cmp ax,6174
    jz done2
    call buildVector
    lea dx,VECTOR
    call SORTasc
    mov cx,4
    mov si,0
    mov ascnr,0
    buildNumAsc VECTOR[SI]
    lea dx,VECTOR
    mov si,3
    mov cx,4
    mov desnr,0
    buildNumDes VECTOR[SI]
    inc CX
    inc CX
    loop kaploop2

    
    done2:
    clear
    
    ;convert nr to ascii
    push offset numtoprint
    mov bx,count
    mov ax,number
    push ax
    call numtoascii

    ;convert count to ascii
    push offset numtoprint2
    push bx
    call numtoascii2
    
    ; print the number
    mov ah,40h
    mov bx,fhandle
    mov cx,4
    lea dx,numtoprint
    int 21h

    ; space 
    mov ah,40h
    mov bx,fhandle
    mov cx,1
    lea dx,space
    int 21h
    
    ; print count
    mov ah,40h
    mov bx,fhandle
    mov cx,4
    lea dx,numtoprint2
    int 21h
    
    ;print newline
    mov ah,40h
    mov bx,fhandle
    mov cx,1
    lea dx,newline
    int 21h
    
    ;again
      inc number
      mov ascnr,0
      mov desnr,0
      mov count,0
      jmp again2
exit2:
    clear

    ;close file
    mov ah,4ch  
    int 21h
    
START ENDP


; procedure to sort the array in asc order
SORTasc PROC NEAR
push di
MOV SI, 0
MOV CX, 4
fori: ; for (i = 0; i <= n - 1; i ++)
    PUSH CX
    MOV CX, 4
    MOV DI, 0
    forj: ; for (j = 0; j <= n - 1; j++)
        MOV BL, VECTOR[SI]
        MOV BH, VECTOR[DI]
        CMP BL, BH 
        JNBE noswap
        SWAP VECTOR[SI], VECTOR[DI]
        noswap:
            INC DI ; j++
    LOOP forj
    POP CX
    INC SI ; i++
    LOOP fori
    pop di
RET
SORTasc ENDP

; procedure to sort the array in desc order
SORTdesc PROC NEAR
push di
MOV SI, 0
MOV CX, 4
fora: ; for (i = 0; i <= n - 1; i ++)
    PUSH CX
    MOV CX, 4
    MOV DI, 0
    forb: ; for (j = 0; j <= n - 1; j++)
        MOV BL, VECTOR[SI]
        MOV BH, VECTOR[DI]
        CMP BL, BH 
        JNAE nswap
        SWAP VECTOR[SI], VECTOR[DI]
        nswap:
            INC DI ; j++
    LOOP forb
    POP CX
    INC SI ; i++
    LOOP fora
    pop di
RET
SORTdesc ENDP


; procedure to build the vector from the number
buildVector PROC NEAR
    mov si,0
    mov cx,4
    mov dx,0
    bV:
        div numberplace
        mov dh,00
        mov vector[SI],dl
        inc SI
        xor dx,dx
    loop bV
    RET
buildVector ENDP

; procedure to convert number to ASCII
proc numtoascii
        push bp
        mov bp,sp
        push CX
        push BX
        mov ax,[bp+4]
        mov si,[bp+6]
        mov bx,10
        xor cx,CX
        mov di,ax   
        digit1:
        xor dx,DX
        div BX
        push DX
        inc CX
        cmp ax,0
        jne digit1
    
    xor bx,bx
    mov bx,3
    cmp di,10
    jb convdigit
    dec bx
    cmp di,100
    jb convdigit
    dec bx
    cmp di,1000
    jb convdigit
    dec bx
    cmp di,10000
    jb convdigit
    dec bx
    
convdigit:
        pop DX
        add dl,30h
        mov [si + bx],dl
        inc bx
        loop convdigit
        pop BX
        pop CX
        pop bp
        ret 4
endp numtoascii

; procedure to convert nr of iterations to ASCII
proc numtoascii2
        push bp
        mov bp,sp
        push CX
        push BX
        mov ax,[bp+4]
        mov si,[bp+6]
        mov bx,10
        xor cx,CX

        digit2:
        xor dx,DX
        div BX
        push DX
        inc CX
        cmp ax,0
        jne digit1

convdigit2:
        pop DX
        add dl,30h
        mov [si],dl
        inc si
        loop convdigit2
        pop BX
        pop CX
        pop bp
        ret 4
endp numtoascii2



CODE ENDS
END START