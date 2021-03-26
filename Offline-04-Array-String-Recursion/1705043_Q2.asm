.MODEL SMALL
.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    input1_msg DB CR, LF,  'Enter value of n : $'
    
    n DW '?'
    ans DW '?'

.CODE

MAIN PROC
    
    ; INITIALIZE DS
    MOV AX, @DATA
    MOV DS, AX
    

    LEA DX, input1_msg
    MOV AH, 9
    INT 21H
    

    ; num1 input as decimal
    CALL INDEC

   
     
    MOV n, AX

    CALL \N 
      
    MOV AX, n
    PUSH AX
    CALL FIBONACCI
    
    
    CALL OUTDEC    
    MOV ans, AX
    
    
    
    QUIT:
        MOV AH, 4CH
        INT 21H 
                           
MAIN ENDP


FIBONACCI PROC
    PUSH BP
    MOV BP, SP ; STACK POINTER
                          
    MOV BX, [BP+4]   ; get n
    CMP BX, 1        
    JE ONE           ;if n==1
    
    CMP BX, 2
    JE TWO
    JMP NOT_ONE_TWO   ;if n!=1 && n!=2
    
    ONE:
        MOV AX, 0    ;return 0
        JMP RETURN
    
    TWO:
        MOV AX, 1    ;return 1
        JMP RETURN   

    NOT_ONE_TWO:
        SUB BX, 1
        PUSH BX
        CALL FIBONACCI  ; get F(n-1)
        PUSH AX         ; save result F(n-1)
        
        
        MOV BX, [BP+4]
        SUB BX, 2
        PUSH BX
        CALL FIBONACCI  ; get F(n-2)
        
        
        POP BX          ; get F(n-1) 
        ADD AX, BX      ; F(n-1) + F(n-2)
                
        
    RETURN:
        POP BP
        RET 2     
    
FIBONACCI ENDP

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
 
 
;DECIMAL output procedure
OUTDEC PROC
    ;push values of registers
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    OR AX, AX           
    JGE @END_IF1        ;if AX>=0 go to @END_IF1
                        ;else
    PUSH AX             
    MOV DL, '-'         ;print '-' sign
    MOV AH, 2
    INT 21H
    POP AX
    NEG AX              ;make 2's completement
    
@END_IF1:
    XOR CX, CX          ;clear CX
    MOV BX, 10D         ;BX = 10
    
@REPEAT1:
    XOR DX, DX          ;clear DX
    DIV BX              ;DX = AX % 10 , AX = AX / 10
    PUSH DX             ;push remainer into stack
    INC CX              ;count digit++
    
    OR AX, AX           
    JNE @REPEAT1        ;if AX!=0, repeat
                        ;else
    MOV AH, 2

@PRINT_LOOP:
    POP DX              ;pop MSB of DECIMAL
    OR DL, 30H          ;DECIMAL to ASCII
    INT 21H             ;print
    LOOP @PRINT_LOOP    ;till CX=0, @PRINT_LOOP continues
    
    ;pop all in reverse order of push
    POP DX
    POP CX
    POP BX
    POP AX                  
    RET                 ;return
OUTDEC ENDP


;new line procedure
\N PROC
        MOV AH, 2
        MOV DL, 0DH
        INT 21H
        MOV DL, 0AH
        INT 21H
        RET
\N ENDP 



END MAIN