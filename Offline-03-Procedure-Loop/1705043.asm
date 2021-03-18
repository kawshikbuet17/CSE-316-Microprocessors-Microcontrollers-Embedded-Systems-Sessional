.MODEL SMALL
.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    input1_msg DB CR, LF,  'Enter Operand 1 : $'
    operator_msg DB CR, LF,  'Enter Operator : $'
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
    
    LEA DX, input1_msg
    MOV AH, 9
    INT 21H

    CALL INDEC 

    PUSH AX
    MOV num1, AX
      
    
    LEA DX, operator_msg
    MOV AH, 9
    INT 21H
    
    ;take operator
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
    JMP EXIT
    
    ADDITION:
        POP AX
        MOV BX, AX
        
        LEA DX, input2_msg
        MOV AH, 9
        INT 21H
        
        CALL INDEC
     
        ADD AX, BX
        
        MOV ans, AX
        
        
        LEA DX, output_msg
        MOV AH, 9
        INT 21H
        
        MOV AX, ans
        
        CALL OUTDEC
        JMP EXIT
    
    SUBSTRACTION:
        POP AX
        MOV BX, AX
        
        
        LEA DX, input2_msg
        MOV AH, 9
        INT 21H
        
        CALL INDEC
     
        SUB BX, AX
        
        MOV ans, BX
        
        
        LEA DX, output_msg
        MOV AH, 9
        INT 21H
        
        MOV AX, ans
        
        CALL OUTDEC
        JMP EXIT
    
    MULTIPLICATION:
        POP AX
        MOV BX, AX
        
        
        LEA DX, input2_msg
        MOV AH, 9
        INT 21H
        
        CALL INDEC
     
        IMUL BX
        
        MOV ans, AX
        
        
        LEA DX, output_msg
        MOV AH, 9
        INT 21H
        
        MOV AX, ans
        
        CALL OUTDEC
        JMP EXIT
        
    DIVISION:    
        
        LEA DX, input2_msg
        MOV AH, 9
        INT 21H
        
        CALL INDEC
        MOV BX, AX
        
        POP AX
        
        XOR DX, DX
        CWD
        
        IDIV BX
        
        MOV ans, AX
        
        
        LEA DX, output_msg
        MOV AH, 9
        INT 21H
        
        MOV AX, ans
        
        CALL OUTDEC

        JMP EXIT
    
    
    EXIT:
        MOV AH, 4CH
        INT 21H 
    
MAIN ENDP

INDEC PROC
    
    PUSH BX
    PUSH CX
    PUSH DX 
    
@BEGIN:
    ;MOV AH, 2
    ;MOV DL, '?'
    ;INT 21H
    
    XOR BX, BX
    
    XOR CX, CX
    
    MOV AH, 1
    INT 21H
    
    CMP AL, '-'
    JE @MINUS
    
    CMP AL, '+'
    JE @PLUS
    JMP @REPEAT2
@MINUS:
    MOV CX, 1
@PLUS:
    INT 21H
    
@REPEAT2:
    CMP AL, '0'
    JNGE @NOT_DIGIT
    CMP AL, '9'
    JNLE @NOT_DIGIT
    
    AND AX, 000FH
    PUSH AX
    
    MOV AX, 10
    MUL BX
    POP BX
    ADD BX, AX
    
    MOV AH, 1
    INT 21H
    CMP AL, 0DH
    JNE @REPEAT2
    
    MOV AX, BX
    
    OR CX, CX
    JE @EXIT
    
    NEG AX
    
@EXIT:
    POP DX
    POP CX
    POP BX
    RET

@NOT_DIGIT:
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV DL, 0AH
    INT 21H
    JMP @BEGIN
INDEC ENDP


OUTDEC PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    OR AX, AX
    JGE @END_IF1
    
    PUSH AX
    MOV DL, '-'
    MOV AH, 2
    INT 21H
    POP AX
    NEG AX
    
@END_IF1:
    XOR CX, CX
    MOV BX, 10D
    
@REPEAT1:
    XOR DX, DX
    DIV BX
    PUSH DX
    INC CX
    
    OR AX, AX
    JNE @REPEAT1
    
    MOV AH, 2

@PRINT_LOOP:
    POP DX
    OR DL, 30H
    INT 21H
    LOOP @PRINT_LOOP
    
    POP DX
    POP CX
    POP BX
    POP AX
    
    RET
OUTDEC ENDP


\N PROC
    
        MOV AH, 2
        MOV DL, 0DH
        INT 21H
        MOV DL, 0AH
        INT 21H
        RET
\N ENDP

END MAIN