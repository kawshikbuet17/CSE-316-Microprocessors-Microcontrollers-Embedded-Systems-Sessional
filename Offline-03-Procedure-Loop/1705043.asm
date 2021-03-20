.MODEL SMALL
.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    input1_msg DB CR, LF,  'Enter Operand 1 : $'
    operator_msg DB CR, LF,  'Enter Operator : $'
    wrong_operator_msg DB CR, LF,  'Wrong Operator $'
    input2_msg DB CR, LF,  'Enter Operand 2 : $'
    output_msg DB CR, LF,  'Ans = $'
    
    num1 DW '?'
    num2 DW '?'
    operator DB '?'
    ans DW '?'

.CODE

MAIN PROC
    
    ; INITIALIZE DS
    MOV AX, @DATA
    MOV DS, AX
    
    CONTINUOUS_INP:
    ; num1 input message
    LEA DX, input1_msg
    MOV AH, 9
    INT 21H

    ; num1 input as decimal
    CALL INDEC 
    
    ; push num1 into stack
    PUSH AX
    MOV num1, AX ; take num1 backup
      
    ; operator input message
    LEA DX, operator_msg
    MOV AH, 9
    INT 21H
    
    ;take operator input
    MOV AH, 1
    INT 21H
    
    MOV operator, AL
    CMP AL, '+'
    JE ADDITION
    
    CMP AL, '-'
    JE SUBSTRACTION
    
    
    CMP AL, '*'
    JE MULTIPLICATION
    
    CMP AL, '/'
    JE DIVISION
    
    CMP AL, 'q'
    JE QUIT
    
    JMP WRONG_OPERATOR
    
    ADDITION:
        POP AX                  ;get num1
        MOV BX, AX              ;store num1 into BX
        
        LEA DX, input2_msg      ;num2 input message
        MOV AH, 9
        INT 21H
        
        CALL INDEC
        MOV num2, AX
     
        ADD AX, BX              ;num1+num2
        
        MOV ans, AX             ;ans = num1+num2
        
        JMP PRINT
    
    SUBSTRACTION:
        POP AX
        MOV BX, AX
        
        
        LEA DX, input2_msg
        MOV AH, 9
        INT 21H
        
        CALL INDEC
        MOV num2, AX
     
        SUB BX, AX
        
        MOV ans, BX
                
        JMP PRINT
    
    MULTIPLICATION:
        POP AX
        MOV BX, AX
        
        
        LEA DX, input2_msg
        MOV AH, 9
        INT 21H
        
        CALL INDEC
        MOV num2, AX
     
        IMUL BX
        
        MOV ans, AX
                
        JMP PRINT
        
    DIVISION:    
        
        LEA DX, input2_msg
        MOV AH, 9
        INT 21H
        
        CALL INDEC
        MOV num2, AX
        
        MOV BX, AX
        
        POP AX
        
        XOR DX, DX
        CWD
        
        IDIV BX
        
        MOV ans, AX

        JMP PRINT
    
    PRINT:
        CALL PRINT_ALL_PROC
        MOV AL, operator
        CMP AL, 'q'
        JNE CONTINUOUS_INP
        JMP QUIT
    
    WRONG_OPERATOR:
        LEA DX, wrong_operator_msg
        MOV AH, 9
        INT 21H
        CALL \N
        MOV AL, operator
        CMP AL, 'q'
        JNE CONTINUOUS_INP
        
    QUIT:
        MOV AH, 4CH
        INT 21H 
    
MAIN ENDP


;DECIMAL output procedure
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


;print procedure
PRINT_ALL_PROC PROC
    CALL \N
    MOV AH, 2
    MOV DL, '['
    INT 21H
    
    MOV AX, num1
    CALL OUTDEC
    
    MOV AH, 2
    MOV DL, ']'
    INT 21H
    
    MOV AH, 2
    MOV DL, operator
    INT 21H
    
    MOV AH, 2
    MOV DL, '['
    INT 21H
    
    MOV AX, num2
    CALL OUTDEC
    
    MOV AH, 2
    MOV DL, ']'
    INT 21H
    
    MOV AH, 2
    MOV DL, '='
    INT 21H
    
    MOV AH, 2
    MOV DL, '['
    INT 21H
    
    MOV AX, ans
    CALL OUTDEC
    
    MOV AH, 2
    MOV DL, ']'
    INT 21H
    
    CALL \N
    RET
PRINT_ALL_PROC ENDP

END MAIN