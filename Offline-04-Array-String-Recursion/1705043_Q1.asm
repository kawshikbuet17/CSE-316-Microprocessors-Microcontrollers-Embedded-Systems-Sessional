.MODEL SMALL
.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    input1_msg DB CR, LF,  'Enter 2 x 2 Matrix1 : $'  
    input2_msg DB CR, LF,  'Enter 2 x 2 Matrix2 : $'
    output_msg DB CR, LF,  'Matrix1 + Matrix2 : $'
    
    matrix1 DW 4 DUP (?)
    matrix2 DW 4 DUP (?)
    matrix3 DW 4 DUP (?)

    M DW 2
    N DW 2

    how_many DW '?'

    off DW '?'

.CODE

MAIN PROC
    
    ; INITIALIZE DS
    MOV AX, @DATA
    MOV DS, AX
    
   
    LEA DX, input1_msg
    MOV AH, 9
    INT 21H
    CALL \N

    
    MOV AX, M
    MOV BX, N
    MUL BX
    MOV how_many, AX
    
    LEA SI, matrix1
    MOV CX, how_many
    INSERT_MATRIX1:
        CMP CX, 2
        JNE no_newline1
        CALL \N
        
        no_newline1:
         
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
    MOV CX, how_many
    INSERT_MATRIX2:
        CMP CX, 2
        JNE no_newline2
        CALL \N
        
        no_newline2:
        
        MOV AH, 1
        INT 21H
        
        AND AX, 000FH
        MOV [SI], AX
        
        ADD SI, 2
        CALL \T
        LOOP INSERT_MATRIX2
    
     
     
    LEA SI, matrix3
    MOV CX, how_many
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
    
    LEA DX, output_msg
    MOV AH, 9
    INT 21H
    CALL \N
    
    LEA SI, matrix3
    MOV CX, how_many
    PRINT_MATRIX3:
        CMP CX, 2
        JNE no_newline3
        CALL \N
        
        no_newline3:
        MOV AX, [SI]
        CALL OUTDEC
        CALL \T
        ADD SI, 2
        LOOP PRINT_MATRIX3
        
    
    MOV AH, 4CH
    INT 21H 
    
MAIN ENDP
 
 
;includes procedures

INCLUDE newLine_proc.asm
INCLUDE wordSpace_proc.asm
INCLUDE output_decimal_proc.asm

END MAIN