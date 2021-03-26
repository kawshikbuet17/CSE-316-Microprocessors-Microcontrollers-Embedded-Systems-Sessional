.MODEL SMALL
.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    input1_msg DB CR, LF,  'Enter 2 x 2 Matrix1 : $'  
    input2_msg DB CR, LF,  'Enter 2 x 2 Matrix2 : $'
    
    
    matrix1 DW 4 DUP (?)
    matrix2 DW 4 DUP (?)
    matrix3 DW 4 DUP (?)

    M DW 2
    N DW 2

    how_many DW '?'
    cnt DW '?'
    operator DB '?'
    off DW '?'

.CODE

MAIN PROC
    
    ; INITIALIZE DS
    MOV AX, @DATA
    MOV DS, AX
    
   
    ; num1 input message
    LEA DX, input1_msg
    MOV AH, 9
    INT 21H
    CALL \N

    
    MOV AX, M
    MOV BX, N
    MUL BX
    MOV how_many, AX
    
    LEA SI, matrix1
    MOV CX, 4
    INSERT_MATRIX1:
        MOV AH, 1
        INT 21H
        
        AND AX, 000FH
        MOV [SI], AX
        
        ADD SI, 2
        CALL \T
        LOOP INSERT_MATRIX1 
    
    LEA DX, input2_msg
    MOV AH, 9
    INT 21H
    CALL \N
    
    LEA SI, matrix2
    MOV CX, 4
    INSERT_MATRIX2:
        MOV AH, 1
        INT 21H
        
        AND AX, 000FH
        MOV [SI], AX
        
        ADD SI, 2
        CALL \T
        LOOP INSERT_MATRIX2
    
     
     
    LEA SI, matrix3
    MOV CX, 4
    MOV off, 0
    INSERT_MATRIX3:
        LEA SI, matrix1
        ADD SI, off
        MOV AX, [SI]
        
        LEA SI, matrix2
        ADD SI, off
        MOV BX, [SI]
        
        ADD AX, BX
        
        
        LEA SI, matrix3 
        ADD SI, off
        MOV [SI], AX
        
        ADD off, 2
        CALL \T
        LOOP INSERT_MATRIX3
    
    CALL \N
    
    LEA SI, matrix3
    MOV CX, 4
    PRINT_MATRIX3:
        MOV AX, [SI]
        CALL OUTDEC
        CALL \T
        ADD SI, 2
        LOOP PRINT_MATRIX3
        
    
    MOV AH, 4CH
    INT 21H 
    
MAIN ENDP



 
 
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


\T PROC
        MOV AH, 2
        MOV DL, ' '
        INT 21H
        RET
\T ENDP
END MAIN