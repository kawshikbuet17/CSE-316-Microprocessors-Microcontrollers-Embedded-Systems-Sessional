;DECIMAL intput procedure
INDEC PROC
    PUSH BX
    PUSH CX
    PUSH DX 
    
@BEGIN:
    XOR BX, BX          ;clear BX
    
    XOR CX, CX          ;clear CX
    
    MOV AH, 1           ;take char input
    INT 21H
    
    CMP AL, '-'         ;handle minus sign
    JE @MINUS
    
    CMP AL, '+'         ;handle plus sign
    JE @PLUS
    
    JMP @REPEAT2        ;handle no sign (consider as plus)

@MINUS:
    MOV CX, 1           ;CX=1 is minus sign

@PLUS:
    INT 21H             ;take next char input
    
@REPEAT2:
    CMP AL, '0'         
    JNGE @AGAIN         ;if char<0 go to @AGAIN

    CMP AL, '9'         
    JNLE @AGAIN         ;if char>9 go to @AGAIN
    
    
    AND AX, 000FH       ;ASCII to DECIMAL and store to AX
    PUSH AX             ;push DECIMAL digit to stack
    
    MOV AX, 10          
    MUL BX              
    POP BX              
    ADD BX, AX          ;BX = total*10 + decimal 
    
    @AGAIN:
    
    MOV AH, 1
    INT 21H
    CMP AL, 0DH
    JNE @REPEAT2        ;if char is not \n, repeat input
                        ;else
    MOV AX, BX          ;store ans in AX
    
    OR CX, CX           ;if CX==0
    JE @EXIT            ;done, go to @EXIT
    
    NEG AX              ;make 2's complement is CX != 0
    
@EXIT:
    POP DX
    POP CX
    POP BX
    RET                 ;return
INDEC ENDP